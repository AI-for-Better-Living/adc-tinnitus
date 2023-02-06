# Implementation of algorithm 0

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

# Note: the stopping rule for the one-sided versions of the algorithm is half
# of the one for the two-sided version.

# Note: the default significance level here has been chosen based on
# alpha = 4/(mean(number of samples per subjects) - 6 + 1) = 0.116 ~ 0.12
# and mean(number of samples per subjects) = 39.46
# In the simulated data, we should have 
# alpha = 4/(mean(number of samples per subjects) - 6 + 1) = 0.128 ~ 0.13
# and mean(number of samples per subjects) = 36.23
# Nevertheless, we used alpha - 0,12 anyway in order to simplify the code