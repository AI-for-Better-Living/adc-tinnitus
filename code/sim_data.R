# This macro creates the simulated data using the R function sim
# Moreover, it creates a new data_frame to save the results of the following analysis

source("sim.R")
source("tot_creates.R")

load("seeds.RData")
tyt = sim(var = FALSE, seeds_var = seeds, 
          seeds_samples = seeds, 
          N_subjects = 1000)
tot = tot_creates(tyt)

rm(seeds, sim, tot_creates)
save.image("simulated_data.RData")

source("sim.R")
source("tot_creates.R")

load("seeds3.RData")
load("seeds4.RData")
tyt = sim(var = TRUE, seeds_var = seeds3, seeds_samples = seeds4)
tot = tot_creates(tyt)

rm(seeds3, seeds4, sim, tot_creates)
save.image("simulated_data2.RData")

# # ------------------------------------------------------------------------------
# # The FAKE REAL DATA added to the code has been created using the following code
# source("sim.R")
# source("tot_creates.R")
# 
# load("seeds3.RData")
# load("seeds4.RData")
# tyt = sim(var = TRUE, seeds_var = seeds3, seeds_samples = seeds4, 
#           var_shape1 = 6, var_shape2 = 2)
# tot = tot_creates(tyt)
# 
# rm(seeds3, seeds4, sim, tot_creates)
# save.image("real_data.RData")
