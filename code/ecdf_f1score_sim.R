# Ecdf of the f1-score distribution for the first simulated data with 

# load("tot_sim.RData")

for (i in 1:4) {
  
  f1score = tot_sim[,i+3]
  
  print(summary(f1score))
  print(sd(f1score, na.rm=TRUE))
  if (i==1) {
    plot(ecdf(f1score), col = i, main = "", xlim = c(0,1))
  } else {
    plot(ecdf(f1score), add = TRUE, col = i)
  }
  
  legend("bottomright", legend = c("random", "static", "alg1", "alg2"), col = c(1,2,3,4), fill = c(1,2,3,4))
  title(expression("eCDF of the "*F[1]*" score for the first simulated data"))
}

rm(f1score, i)
