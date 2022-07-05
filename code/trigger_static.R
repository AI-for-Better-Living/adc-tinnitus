# Implementation of static algorithm 

trigger_static =function(data,
                   S=6, 
                   type="1", 
                   upper_threshold=0.85,lower_threshold=0.15, 
                   stopping_rule=10) {
  
  triggers = rep(NaN,length(data))
  
  for (n in S:length(data)) {
    
    if (type=="1" & sum(triggers,na.rm=TRUE)<=stopping_rule) {# algorithm 1
      if (data[n] < lower_threshold
          | upper_threshold < data[n]) {
        triggers[n]=1
      } else {
        triggers[n]=0
      } 
    } else if (type=="H" & sum(triggers,na.rm=TRUE)<=stopping_rule/2) {# algorithm H
      if (upper_threshold < data[n]) {
        triggers[n]=1
      } else {
        triggers[n]=0
      } 
    } else if (type == "L" & sum(triggers,na.rm=TRUE)<=stopping_rule/2) {# algorithm L
      if (data[n] < lower_threshold) {
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
#   type               = "1" for the static algorithm,
#                        "H" for the static algorithm with only high levels,
#                        "L" for the static algorithm with only low levels;
#   upper_threshold    = upper threshold of the static algorithm;
#   lower_threshold    = lower threshold of the static algorithm;
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
