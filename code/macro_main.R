# macro which applies the main.R script to the simulated and real data to obtain
# summaries of the performance of the algorithms in those scenarios

source("main.R")

load("simulated_data.RData")
tot_sim = main(tot, tyt)

load("simulated_data2.RData")
tot_sim2=main(tot, tyt)

load("real_data.RData")
tot_real= main(tot, tyt, ground_truth = FALSE)

rm(est_beta, f1score, main, N_adherence, 
   trigger_random, trigger_static, trigger0, trigger1, 
   true_trigger1, u1score, tyt, tot)

save.image("tot.RData")
