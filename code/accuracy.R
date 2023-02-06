# Usual measures of accuracy for classification algorithms

f1score = function(triggers,true_triggers) {
  FP = length(which(triggers!=true_triggers & triggers==1))
  FN = length(which(triggers!=true_triggers & triggers==0))
  TP = length(which(triggers==true_triggers & triggers==1))
  # TN = length(which(triggers==true_triggers & triggers==0))
  f1score =  2*TP/(2*TP+FP+FN)
  return(f1score)
}

u1score = function(triggers,true_triggers, wanted_triggers=4) {
  FP = length(which(triggers!=true_triggers & triggers==1))
  # FN = length(which(triggers!=true_triggers & triggers==0))
  TP = length(which(triggers==true_triggers & triggers==1))
  # TN = length(which(triggers==true_triggers & triggers==0))
  u1score =   - ( TP + FP - wanted_triggers )^2
  return(u1score)
}

### Description of the functions -----------------------------------------------

# Input
#   triggers             = vector of 0 and 1 which represents the anomalies 
#                          detected by the algorithm considered
#   true_triggers        = ground truth

# Output
#   -- = f1score/ utility u1
