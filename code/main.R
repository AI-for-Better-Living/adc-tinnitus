main = function(tot, tyt, ground_truth = TRUE) {
  
  # requires the following scripts
  source("accuracy.R"); source("est_beta.R"); 
  source("trigger1.R"); 
  source("trigger0.R"); 
  source("trigger_random.R"); 
  source("trigger_static.R");
  source("true_trigger1.R");
  
  for (subject_id in tot$Var1) {
    temp = subset(tyt, user_id==subject_id)
    
    x=temp$question2
    y=as.Date(temp$save_date)
    
    # --------------------------------------------------------------------------
    # CHOICE OF THE RANDOM ALGORITHM TO APPLY
    load("seeds2.RData")
    triggers_random = trigger_random(dates=y, 
                                     fix_seed = seeds2[which(tot$Var1==subject_id)])
    triggers_static = trigger_static(data=x)
    triggers_trigger0 = trigger0(data=x)
    triggers_trigger1 = trigger1(data=x,dates=y)
    
    # --------------------------------------------------------------------------
    if (ground_truth==TRUE) {
      # ground truth for shape1 and shape2 in the SIMULATED DATA ---------------
      # extrapolated from the dataframe tot
      param = c(tot$shape1[which(tot$Var1==subject_id)],
                tot$shape2[which(tot$Var1==subject_id)]) # ---------------------
    } else if (ground_truth ==FALSE) {
      # ground truth for shape1 and shape2 in the REAL DATA --------------------
      # computed for each subject at the end of the experiment
      param=est_beta(data=x)
      tot$shape1[which(tot$Var1==subject_id)] = param[1]
      tot$shape2[which(tot$Var1==subject_id)] = param[2]
    }
    
    # --------------------------------------------------------------------------
    # RESULTS
    # ground truth
    true_triggers=true_trigger1(data=x, param=param)
    
    tot$f1_random[which(tot$Var1==subject_id)]=f1score(triggers_random, true_triggers)
    tot$f1_static[which(tot$Var1==subject_id)]=f1score(triggers_static, true_triggers)
    tot$f1_alg0[which(tot$Var1==subject_id)]=f1score(triggers_trigger0, true_triggers)
    tot$f1_alg1[which(tot$Var1==subject_id)]=f1score(triggers_trigger1, true_triggers)
    
    tot$u1_random[which(tot$Var1==subject_id)]=u1score(triggers_random, true_triggers)
    tot$u1_static[which(tot$Var1==subject_id)]=u1score(triggers_static, true_triggers)
    tot$u1_alg0[which(tot$Var1==subject_id)]=u1score(triggers_trigger0, true_triggers)
    tot$u1_alg1[which(tot$Var1==subject_id)]=u1score(triggers_trigger1, true_triggers)
  }
  return(tot)
}

### Description of the function ------------------------------------------------

# Input
#   tot                = dataframe which summarized the results
#   tyt                = dataframe which collects the raw data
#   ground_truth       = is the ground truth saved in the dataframe tot?


# Output
#   triggers = a dataframe which includes the F1scores and u1scores of all the
#              algorithms considered applied to each individual subject 

# Note: the unit of measure of the starting point S is the number of samples, 
# not the days.