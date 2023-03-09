# Analysis of how many tasks are prevented by a stopping rule set to 10

load("data/simulated_data.RData")
source("prevented_tasks_main.R")
count_tot_sim1 = count_tot_sim

load("data/simulated_data2.RData")
source("prevented_tasks_main.R")
count_tot_sim2 = count_tot_sim

rm(count_tot_sim, tot, tyt)

## DESCRIPTIVE ANALYSIS OF THE RESULTS

# I consider the proportion of subjects for which at least one task has been prevented

p_nt = matrix(0,2,6)
for (i in c(3,4,6,7)) {
  z1 = as.data.frame(table(count_tot_sim1[,i]))
  z2 = as.data.frame(table(count_tot_sim2[,i]))
  z1 <- apply(as.matrix.noquote(z1),2,as.numeric)
  z2 <- apply(as.matrix.noquote(z2),2,as.numeric)
  p_nt[,i-2] = c(sum(z1[2:length(z1[,1]),2])/sum(z1[,2]),
                 sum(z2[2:length(z2[,1]),2])/sum(z2[,2]))
}

p_nt = data.frame(p_nt, row.names = c("first simulated dataset", "second simulated dataset"))
colnames(p_nt) = names(count_tot_sim1[,3:8])

rm(i, z1,z2)
rm(count_tot_sim1, count_tot_sim2)

save.image("results/p_nt.RData")
write.csv(p_nt, "results/p_nt.csv", row.names=TRUE, quote=FALSE) 

