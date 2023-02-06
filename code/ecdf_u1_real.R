# Ecdf of the utility u1 distribution for the real data

#load("tot_real.RData")

for (i in 1:4) {
  
  u1 = tot_real[,i+8]
  
  print(summary(u1))
  print(sd(u1, na.rm=TRUE))
  if (i==1) {
    plot(ecdf(u1), col = i, main = "", xlim = c(-50, 10))
  } else {
    plot(ecdf(u1), add = TRUE, col = i)
  }
}
legend("bottomright", legend = c("random", "static", "alg1", "alg2"), col = c(1,2,3,4), fill = c(1,2,3,4))
title("eCDF of the utility score for the real data")

rm(u1, i)
