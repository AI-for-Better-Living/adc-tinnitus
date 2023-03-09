# Implementation of Algortithm 1

# requires the following scripts
source("est_beta.R")

trigger0 =function(data,
                   S=6,alpha=0.12, 
                   stopping_rule=10) {
  
  triggers = rep(NaN,length(data))
  
  for (n in S:length(data)) {
    
    # estimation of the tinnitus severity parameters
    param=est_beta(data[1:(n-1)]) 
    
    # anomaly detection step
    if (sum(triggers,na.rm=TRUE)<=stopping_rule) {# algorithm 1
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
#   S                  = starting point of the algorithm;
#   alpha              = significance level;
#   stopping_rule      = maximum amount of triggers allowed by the algorithm.

# Output
#   triggers = vector of 0 and 1 of the same length of the data,
#              1 --> the algorithm detects an anomaly and triggers the 
#                    decision-making task,
#              0 --> it does not detect an anomaly and no task is triggered.

# Note: the unit of measure of the starting point S is the number of samples, 
# not the days.
