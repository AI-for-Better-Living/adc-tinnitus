# Mann-Whitney-Wilcox test / Wilcoxon signed-rank test for the real data
# https://www.rdocumentation.org/packages/stats/versions/3.6.2/topics/wilcox.test

load("~/Code/triggering algorithm/tot_real.RData")

f1score = rep(NaN,6); u1 = rep(NaN,6);  
Alg = c("static > random", "alg0 > random", "alg0 > static", "alg1 > random", "alg1 > static", "alg1 > alg0")
wlc_real = data.frame(f1score, u1, Alg)
rm(Alg, f1score, u1)

alt = "greater"
temp1 = TRUE # TRUE = Wilcoxon signed-rank test
# FALSE = Mann–Whitney U test

#f1score
wlc_real[1,1]=wilcox.test(tot_real$f1_static, tot_real$f1_random,
                          paired = temp1, alternative=alt,
                          correct=FALSE)$p.value
wlc_real[2,1]=wilcox.test(tot_real$f1_alg0, tot_real$f1_random,
                          paired = temp1, alternative=alt,
                          correct=FALSE)$p.value
wlc_real[3,1]=wilcox.test(tot_real$f1_alg0, tot_real$f1_static,
                          paired = temp1, alternative=alt,
                          correct=FALSE)$p.value
wlc_real[4,1]=wilcox.test(tot_real$f1_alg1, tot_real$f1_random,
                          paired = temp1, alternative=alt,
                          correct=FALSE)$p.value
wlc_real[5,1]=wilcox.test(tot_real$f1_alg1, tot_real$f1_static,
                          paired = temp1, alternative=alt,
                          correct=FALSE)$p.value
wlc_real[6,1]=wilcox.test(tot_real$f1_alg1, tot_real$f1_alg0,
                          paired = temp1, alternative=alt,
                          correct=FALSE)$p.value
# u1
wlc_real[1,2]=wilcox.test(tot_real$u1_static, tot_real$u1_random,
                          paired = temp1, alternative=alt,
                          correct=FALSE)$p.value
wlc_real[2,2]=wilcox.test(tot_real$u1_alg0, tot_real$u1_random,
                          paired = temp1, alternative=alt,
                          correct=FALSE)$p.value
wlc_real[3,2]=wilcox.test(tot_real$u1_alg0, tot_real$u1_static,
                          paired = temp1, alternative=alt,
                          correct=FALSE)$p.value
wlc_real[4,2]=wilcox.test(tot_real$u1_alg1, tot_real$u1_random,
                          paired = temp1, alternative=alt,
                          correct=FALSE)$p.value
wlc_real[5,2]=wilcox.test(tot_real$u1_alg1, tot_real$u1_static,
                          paired = temp1, alternative=alt,
                          correct=FALSE)$p.value
wlc_real[6,2]=wilcox.test(tot_real$u1_alg1, tot_real$u1_alg0,
                          paired = temp1, alternative=alt,
                          correct=FALSE)$p.value

rm(tot_real, alt, temp1)