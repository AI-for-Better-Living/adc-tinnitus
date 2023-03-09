# Implementation of Algorithm 2

# requires the following scripts
source("est_beta.R")
source("N_adherence.R")

trigger1 =function(data,dates,
                   S=6,wanted_triggers=4, 
                   hoped_x_day=6,length_exp_in_days=30, 
                   stopping_rule=10) {
  
  triggers = rep(NaN,length(data))
  
  for (n in S:length(data)) {
    
    # estimation of the tinnitus severity parameters
    param=est_beta(data[1:(n-1)]) 

    # incorporating adherence 
    N_t=N_adherence(dates[c(1:n)], hoped_x_day, length_exp_in_days)
    
    alpha= max(0,min(wanted_triggers/(N_t-S+1), 1))
    
    # anomaly detection step
    if (sum(triggers,na.rm=TRUE)<=stopping_rule) {
      if (data[n] < qbeta(alpha/2,shape1=param[1],shape2=param[2]) 
          | qbeta((1-alpha/2),shape1=param[1],shape2=param[2])<data[n]) {
        triggers[n]=1
      } else {
        triggers[n]=0
      }
    }
  }
  
  return(triggers)
}

### Description of the function ------------------------------------------------

# Input
#   data               = tinnitus severity time series;
#   dates              = dates ("dd/mm/yyyy") relative to the data;
#   S                  = starting point of the algorithm;
#   wanted_triggers    = the total number of triggers the researcher is aiming to;
#   hoped_x_day        = samples of data hoped to be collected daily;
#   length_exp_in_days = length of the experiment in days;
#   stopping_rule      = maximum amount of triggers allowed by the algorithm.

# Output
#   triggers = vector of 0 and 1 of the same length of the data,
#              1 --> the algorithm detects an anomaly and triggers the 
#                    decision-making task,
#              0 --> it does not detect an anomaly and no task is triggered.

# Note: the unit of measure of the starting point S is the number of samples, 
# not the days.
