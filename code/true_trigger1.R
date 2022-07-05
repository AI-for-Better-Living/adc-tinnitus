# Implementation of algorithm 1 with prior knowledge of the final number of 
# samples for each subject

# requires the following scripts
source("est_beta.R")

true_trigger1 =function(data,
                        S=6,wanted_triggers=4, 
                        type="1", 
                        param) {
  triggers = rep(NaN,length(data))
  
  # def of the significance level
  N=length(data)
  if (type=="H" | type=="L") {wanted_triggers=round(wanted_triggers/2)}
  
  if (N>wanted_triggers+S-1) {
    alpha= wanted_triggers/(N-S+1)
  } else {
    alpha = 1
  }
  
  for (n in S:length(data)) {
    
    # anomaly detection step
    if (type=="1") {# algorithm 1
      if (data[n] < qbeta(alpha/2,shape1=param[1],shape2=param[2]) 
          | qbeta((1-alpha/2),shape1=param[1],shape2=param[2])<data[n]) {
        triggers[n]=1
      } else {
        triggers[n]=0
      } 
    } else if (type=="H") {# algorithm H
      if (qbeta((1-alpha/2),shape1=param[1],shape2=param[2])<data[n]) {
        triggers[n]=1
      } else {
        triggers[n]=0
      } 
    } else if (type == "L") {# algorithm L
      if (data[n] < qbeta(alpha/2,shape1=param[1],shape2=param[2])) {
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
#   wanted_triggers    = the total number of triggers the researcher is aiming to;
#   type               = "1" for algorithm 1,
#                        "H" for algorithm H,
#                        "L" for algorithm L;
#   param              = vector of length two with the ground truth values of 
#                        the Beta distr. parameters.

# Output
#   triggers = vector of 0 and 1 of the same length of the data,
#              1 --> the algorithm detects an anomaly and triggers the 
#                    decision-making task,
#              0 --> it does not detect an anomaly and no task is triggered.

# Note: the unit of measure of the starting point S is the number of samples, 
# not the days.

# Note: the algorithm in this case assume prior knowledge of the total number 
# of samples for each subjects. This algorithm is used as the ground truth in 
# both the real data and the simulations case.