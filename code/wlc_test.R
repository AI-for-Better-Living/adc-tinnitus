wlc_test = function(tot) {
  # Wilcoxon signed-rank
  # https://www.rdocumentation.org/packages/stats/versions/3.6.2/topics/wilcox.test
  
  f1score = rep(NaN,6); u1 = rep(NaN,6);  
  Alg = c("static > random", "alg0 > random", "alg0 > static", "alg1 > random", "alg1 > static", "alg1 > alg0")
  wlc = data.frame(f1score, u1, Alg)
  rm(Alg, f1score, u1)
  
  alt = "greater"
  temp1 = TRUE # TRUE = Wilcoxon signed-rank test
               # FALSE = Mann–Whitney U test
  
  #f1score
  wlc[1,1]=wilcox.test(tot$f1_static, tot$f1_random,
                            paired = temp1, alternative=alt,
                            correct=FALSE)$p.value
  wlc[2,1]=wilcox.test(tot$f1_alg0, tot$f1_random,
                            paired = temp1, alternative=alt,
                            correct=FALSE)$p.value
  wlc[3,1]=wilcox.test(tot$f1_alg0, tot$f1_static,
                            paired = temp1, alternative=alt,
                            correct=FALSE)$p.value
  wlc[4,1]=wilcox.test(tot$f1_alg1, tot$f1_random,
                            paired = temp1, alternative=alt,
                            correct=FALSE)$p.value
  wlc[5,1]=wilcox.test(tot$f1_alg1, tot$f1_static,
                            paired = temp1, alternative=alt,
                            correct=FALSE)$p.value
  wlc[6,1]=wilcox.test(tot$f1_alg1, tot$f1_alg0,
                            paired = temp1, alternative=alt,
                            correct=FALSE)$p.value
  # u1
  wlc[1,2]=wilcox.test(tot$u1_static, tot$u1_random,
                            paired = temp1, alternative=alt,
                            correct=FALSE)$p.value
  wlc[2,2]=wilcox.test(tot$u1_alg0, tot$u1_random,
                            paired = temp1, alternative=alt,
                            correct=FALSE)$p.value
  wlc[3,2]=wilcox.test(tot$u1_alg0, tot$u1_static,
                            paired = temp1, alternative=alt,
                            correct=FALSE)$p.value
  wlc[4,2]=wilcox.test(tot$u1_alg1, tot$u1_random,
                            paired = temp1, alternative=alt,
                            correct=FALSE)$p.value
  wlc[5,2]=wilcox.test(tot$u1_alg1, tot$u1_static,
                            paired = temp1, alternative=alt,
                            correct=FALSE)$p.value
  wlc[6,2]=wilcox.test(tot$u1_alg1, tot$u1_alg0,
                            paired = temp1, alternative=alt,
                            correct=FALSE)$p.value
  return(wlc)
}

### Description of the function ------------------------------------------------

# Input: 
#     tot = dataframe such as tot_sim.Rdata, tot_sim2.Rdata or tot_real.Data
# Output:
#     wlc = table with the Wilcoxon signed-rank test results


