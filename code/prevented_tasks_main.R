# Creates a dataframe to store informations on how many tasks are prevented 
# by using the stopping rule

# requires the following scripts
source("est_beta.R"); 
source("trigger1.R"); 
source("trigger0.R"); 
source("trigger_random.R"); 
source("trigger_static.R");
source("true_trigger1.R");

# and the following functions
false_positives = function(triggers,true_triggers) {
  FP = length(which(triggers!=true_triggers & triggers==1))
  return(FP)
}
false_negatives = function(triggers,true_triggers) {
  FN = length(which(triggers!=true_triggers & triggers==0))
  return(FN)
}

count_tot_sim = tot[,1:2] # initializing the data.frame using the original data
                          # as base

for (subject_id in tot$Var1) {
  temp = subset(tyt, user_id==subject_id)
  
  x=temp$question2
  y=as.Date(temp$save_date)
  
  # ----------------------------------------------------------------------------
  # CHOICE OF THE RANDOM ALGORITHM TO APPLY
  
  triggers_static = trigger_static(data=x)
  triggers_trigger0 = trigger0(data=x)
  triggers_trigger1 = trigger1(data=x,dates=y)
  
  triggers_static_inf = trigger_static(data=x, stopping_rule = 500)
  triggers_trigger0_inf = trigger0(data=x, stopping_rule = 500)
  triggers_trigger1_inf = trigger1(data=x,dates=y, stopping_rule = 500)
  
  # ----------------------------------------------------------------------------
  # ground truth for shape1 and shape2 in the SIMULATED DATA -------------------
  param = c(tot$shape1[which(tot$Var1==subject_id)],
            tot$shape2[which(tot$Var1==subject_id)]) # ------------------------
  
  # ----------------------------------------------------------------------------
  # RESULTS
  # ground truth
  true_triggers=true_trigger1(data=x, param=param)
  
  # difference between (TP_inf + FP_inf) - (TP_10 + FP_10)
  count_tot_sim$burden_static[which(tot$Var1==subject_id)] = 
    sum(triggers_static_inf, na.rm = TRUE) -
    sum(triggers_static, na.rm = TRUE)
  count_tot_sim$burden_trigger0[which(tot$Var1==subject_id)] = 
    sum(triggers_trigger0_inf, na.rm = TRUE) -
    sum(triggers_trigger0, na.rm = TRUE) 
  count_tot_sim$burden_trigger1[which(tot$Var1==subject_id)] = 
    sum(triggers_trigger1_inf, na.rm = TRUE) -
    sum(triggers_trigger1, na.rm = TRUE)
  
  # difference between FN_inf - FN_10 
  count_tot_sim$FN_diff_static[which(tot$Var1==subject_id)] = 
    false_negatives(triggers_static_inf, true_triggers) - 
    false_negatives(triggers_static, true_triggers)
  count_tot_sim$FN_diff_trigger0[which(tot$Var1==subject_id)] = 
    false_negatives(triggers_trigger0_inf, true_triggers) - 
    false_negatives(triggers_trigger0, true_triggers)
  count_tot_sim$FN_diff_trigger1[which(tot$Var1==subject_id)] = 
    false_negatives(triggers_trigger1_inf, true_triggers) - 
    false_negatives(triggers_trigger1, true_triggers)
  
  # difference between FP_inf - FP_10 
  count_tot_sim$FP_diff_static[which(tot$Var1==subject_id)] = 
    false_positives(triggers_static_inf, true_triggers) - 
    false_positives(triggers_static, true_triggers)
  count_tot_sim$FP_diff_trigger0[which(tot$Var1==subject_id)] = 
    false_positives(triggers_trigger0_inf, true_triggers) - 
    false_positives(triggers_trigger0, true_triggers)
  count_tot_sim$FP_diff_trigger1[which(tot$Var1==subject_id)] = 
    false_positives(triggers_trigger1_inf, true_triggers) - 
    false_positives(triggers_trigger1, true_triggers)
}

count_tot_sim$loss_static = count_tot_sim$FN_diff_static + 
  count_tot_sim$FP_diff_static
count_tot_sim$loss_trigger0 = count_tot_sim$FN_diff_trigger0 + 
  count_tot_sim$FP_diff_trigger0
count_tot_sim$loss_trigger1 = count_tot_sim$FN_diff_trigger1 + 
  count_tot_sim$FP_diff_trigger1

count_tot_sim = count_tot_sim[,c(1,2,3,4,5,12,13,14)]

rm(temp, param, subject_id, triggers_static, triggers_trigger0, 
   triggers_trigger1, true_triggers, x, y, N_adherence, est_beta, 
   trigger0, trigger1, true_trigger1, trigger_random, 
   trigger_static,
   triggers_static_inf, triggers_trigger0_inf, triggers_trigger1_inf, 
   false_negatives, false_positives)