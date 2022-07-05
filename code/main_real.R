# The following code produces the datasets tot_real.RData and tot_sim.Rdata
# which summarise the accuracy of the algorithm in both the real tinnitus 
# dataset and the simulated data. 

# source("clean_data.R")
load("~/Code/triggering algorithm/clean_data.RData")

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
  
  # ----------------------------------------------------------------------------
  # CHOICE OF THE RANDOM ALGORITHM TO APPLY
  load("~/Code/triggering algorithm/seeds2.RData")
  triggers_random = trigger_random(dates=y, 
                                   fix_seed = seeds2[which(tot$Var1==subject_id)])
  triggers_static = trigger_static(data=x)
  triggers_trigger0 = trigger0(data=x)
  triggers_trigger1 = trigger1(data=x,dates=y)
  
  # ----------------------------------------------------------------------------
  # ground truth for shape1 and shape2 in the REAL DATA ------------------------
  param=est_beta(data=x)
  tot$shape1[which(tot$Var1==subject_id)] = param[1]
  tot$shape2[which(tot$Var1==subject_id)] = param[2]
  
  # ----------------------------------------------------------------------------
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

tot_real = tot

rm(temp, tot, tyt,
   param, subject_id, triggers_random, triggers_static, triggers_trigger0, 
   triggers_trigger1, true_triggers, x, y, N_adherence, est_beta, 
   f1score, u1score, trigger0, trigger1, true_trigger1, trigger_random, 
   trigger_static, seeds2)