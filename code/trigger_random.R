# random triggering algorithm 

trigger_random = function(dates, 
                          S=6,
                          hoped_x_day=6, length_exp_in_days=30, 
                          stopping_rule = 10, 
                          fix_seed = 1) {
  
  set.seed(fix_seed)
  triggers=rep(NaN, length(dates))
  
  gg=seq(from=as.Date(dates[1]),by="1 days", length.out = length_exp_in_days)
  ind_triggers = sort(sample(c(round(S/hoped_x_day):length_exp_in_days), 
                             size = stopping_rule))

  for (j in S:length(dates)) {
    if (length(ind_triggers)==0) {
      triggers[j]=0
    } else if (dates[j]<gg[ind_triggers[1]]) {
      triggers[j]=0
    } else if (dates[j]==gg[ind_triggers[1]]) {
      triggers[j]=1
      ind_triggers=ind_triggers[-1]
    } else if (dates[j]>gg[ind_triggers[1]]) {
      triggers[j]=1
      ind_triggers=ind_triggers[-1]
    } 
  }
  
  return(triggers)
}

### Description of the function ------------------------------------------------

# Input
#   dates              = dates ("dd/mm/yyyy") relative to the data;
#   S                  = starting point of the algorithm;
#   hoped_x_day        = samples of data hoped to be collected daily;
#   length_exp_in_days = length of the experiment in days;
#   stopping_rule      = maximum amount of triggers allowed by the algorithm, 
#   seed               = optional seed for reproducibility

# Output
#   triggers = vector of 0 and 1 of the same length of the data,
#              1 --> the algorithm detects an anomaly and triggers the 
#                    decision-making task,
#              0 --> it does not detect an anomaly and no task is triggered.

# Note: the unit of measure of the starting point S is the number of samples, 
# not the days.

