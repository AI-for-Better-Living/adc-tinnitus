# This macro performs a Wilcoxon signed-rank test on them. 

#load("tot.RData")

source("wlc_test.R")

a1 = wlc_test(tot_sim)
a1$data = rep("sim data 1", 6)
a2 = wlc_test(tot_sim2)
a2$data = rep("sim data 2", 6)
a3 = wlc_test(tot_real)
a3$data = rep("real data", 6)

wlc = rbind(a1,a2,a3)

rm(a1, a2, a3, wlc_test)
save.image("wlc.RData")
