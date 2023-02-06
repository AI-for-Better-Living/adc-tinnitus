# Analysis of how many tasks are prevented by a stopping rule set to 10

load("simulated_data.RData")
source("prevented_tasks_main.R")
count_tot_sim1 = count_tot_sim

load("simulated_data2.RData")
source("prevented_tasks_main.R")
count_tot_sim2 = count_tot_sim

rm(count_tot_sim, tot, tyt)

## DESCRIPTIVE ANALYSIS OF THE RESULTS

summary(count_tot_sim1) # summary for the first simulated dataset
#       Var1          Freq       burden_static    burden_trigger0 burden_trigger1  loss_static     loss_trigger0   loss_trigger1
# 1      :  1   Min.   :13.00   Min.   : 0.000   Min.   :0.000   Min.   :0       Min.   : 0.000   Min.   :0.000   Min.   :0    
# 2      :  1   1st Qu.:31.00   1st Qu.: 0.000   1st Qu.:0.000   1st Qu.:0       1st Qu.: 0.000   1st Qu.:0.000   1st Qu.:0    
# 3      :  1   Median :36.00   Median : 0.000   Median :0.000   Median :0       Median : 0.000   Median :0.000   Median :0    
# 4      :  1   Mean   :36.38   Mean   : 1.776   Mean   :0.002   Mean   :0       Mean   : 1.791   Mean   :0.001   Mean   :0    
# 5      :  1   3rd Qu.:41.00   3rd Qu.: 0.000   3rd Qu.:0.000   3rd Qu.:0       3rd Qu.: 0.000   3rd Qu.:0.000   3rd Qu.:0    
# 6      :  1   Max.   :60.00   Max.   :34.000   Max.   :1.000   Max.   :0       Max.   :32.000   Max.   :1.000   Max.   :0  

summary(count_tot_sim2) # summary for the second simulated dataset
#       Var1          Freq        burden_static     burden_trigger0  burden_trigger1  loss_static      loss_trigger0   loss_trigger1
# 1      :  1   Min.   :  7.00   Min.   :  0.000   Min.   : 0.000   Min.   :0       Min.   :  0.000   Min.   :0.000   Min.   :0    
# 2      :  1   1st Qu.: 18.00   1st Qu.:  0.000   1st Qu.: 0.000   1st Qu.:0       1st Qu.:  0.000   1st Qu.:0.000   1st Qu.:0    
# 3      :  1   Median : 34.00   Median :  0.000   Median : 0.000   Median :0       Median :  0.000   Median :0.000   Median :0    
# 4      :  1   Mean   : 40.11   Mean   :  3.179   Mean   : 0.278   Mean   :0       Mean   :  3.177   Mean   :0.185   Mean   :0    
# 5      :  1   3rd Qu.: 57.00   3rd Qu.:  0.000   3rd Qu.: 0.000   3rd Qu.:0       3rd Qu.:  0.000   3rd Qu.:0.000   3rd Qu.:0    
# 6      :  1   Max.   :146.00   Max.   :105.000   Max.   :12.000   Max.   :0       Max.   :104.000   Max.   :9.000   Max.   :0 

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

save.image("p_nt.RData")

