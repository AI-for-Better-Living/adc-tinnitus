# Ecdf of the f1-score distribution for the real data

load("~/Code/triggering algorithm/tot_real.RData")
for (i in 1:4) {
  
  f1score = tot_real[,i+4]
  
  print(summary(f1score))
  print(sd(f1score, na.rm=TRUE))
  if (i==1) {
    plot(ecdf(f1score), col = i, main = "", xlim = c(0,1))
  } else {
    plot(ecdf(f1score), add = TRUE, col = i)
  }
  
  legend("bottomright", legend = c("random", "static", "alg0", "alg1"), col = c(1,2,3,4), fill = c(1,2,3,4))
  title("eCDF of the F_{1} score for the real data")
}

rm(f1score, i)