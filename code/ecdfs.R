# This macro creates the graph for te eCDFs, i.e. Figure 2

#load("data/tot.RData")

png(file="results/ecdfs.png",width=2586, height=1281)

par(mfrow=c(2,3))
initialcolumn = 3;
limits = c(0,1)
tot = tot_sim
source("ecdfs_plot.R")
title(expression("eCDF of the "*F[1]*" score for the first simulated data"))
tot = tot_sim2
source("ecdfs_plot.R")
title(expression("eCDF of the "*F[1]*" score for the second simulated data"))
tot = tot_real
source("ecdfs_plot.R")
title(expression("eCDF of the "*F[1]*" score for the real data"))


initialcolumn = 7;
limits = c(-50, 10)
tot = tot_sim
source("ecdfs_plot.R")
title("eCDF of the utility score for the first simulated data")
tot = tot_sim2
source("ecdfs_plot.R")
title("eCDF of the utility score for the second simulated data")
tot = tot_real
source("ecdfs_plot.R")
title("eCDF of the utility score for the real data")

rm(i, initialcolumn, limits, tempdata, tot)

dev.off()

# if the plot are not shown by rstudio, run the following lines
# graphics.off()
# dev.list()
# then re-run the content of this macro without the lines used to 
# automatically save the figures in the result folder (i.e. lines 5 and 35)
