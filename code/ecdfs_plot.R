
  for (i in 1:4) {
    
    tempdata = tot[,i+initialcolumn]
    if (i==1) {
      plot(ecdf(tempdata), col = i, main = "", xlim = limits)
      } else {
      plot(ecdf(tempdata), add = TRUE, col = i)
      }
  legend("bottomright", legend = c("random", "static", "alg1", "alg2"), 
         col = c(1,2,3,4), fill = c(1,2,3,4))
  }
  