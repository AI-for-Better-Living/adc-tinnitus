# Mann-Whitney-Wilcox test / Wilcoxon signed-rank test for the simulated data
# https://www.rdocumentation.org/packages/stats/versions/3.6.2/topics/wilcox.test

load("~/Code/triggering algorithm/tot_sim.RData")

f1score = rep(NaN,6); u1 = rep(NaN,6);  
Alg = c("static > random", "alg0 > random", "alg0 > static", "alg1 > random", "alg1 > static", "alg1 > alg0")
wlc_sim = data.frame(f1score, u1, Alg)
# wlc_real = data.frame(f1score, u1, Alg)
rm(Alg, f1score, u1)

# alt ="two.sided"
# alt ="less"
alt = "greater"
temp1 = TRUE # TRUE = Wilcoxon signed-rank test
             # FALSE = Mann–Whitney U test


#f1score
wlc_sim[1,1]=wilcox.test(tot_sim$f1_static, tot_sim$f1_random,
                         paired = temp1, alternative=alt,
                         correct=FALSE)$p.value
wlc_sim[2,1]=wilcox.test(tot_sim$f1_alg0, tot_sim$f1_random,
                         paired = temp1, alternative=alt,
                         correct=FALSE)$p.value
wlc_sim[3,1]=wilcox.test(tot_sim$f1_alg0, tot_sim$f1_static,
                         paired = temp1, alternative=alt,
                         correct=FALSE)$p.value
wlc_sim[4,1]=wilcox.test(tot_sim$f1_alg1, tot_sim$f1_random,
                         paired = temp1, alternative=alt,
                         correct=FALSE)$p.value
wlc_sim[5,1]=wilcox.test(tot_sim$f1_alg1, tot_sim$f1_static,
                         paired = temp1, alternative=alt,
                         correct=FALSE)$p.value
wlc_sim[6,1]=wilcox.test(tot_sim$f1_alg1, tot_sim$f1_alg0,
                         paired = temp1, alternative=alt,
                         correct=FALSE)$p.value
# u1
wlc_sim[1,2]=wilcox.test(tot_sim$u1_static, tot_sim$u1_random,
                         paired = temp1, alternative=alt,
                         correct=FALSE)$p.value
wlc_sim[2,2]=wilcox.test(tot_sim$u1_alg0, tot_sim$u1_random,
                         paired = temp1, alternative=alt,
                         correct=FALSE)$p.value
wlc_sim[3,2]=wilcox.test(tot_sim$u1_alg0, tot_sim$u1_static,
                         paired = temp1, alternative=alt,
                         correct=FALSE)$p.value
wlc_sim[4,2]=wilcox.test(tot_sim$u1_alg1, tot_sim$u1_random,
                         paired = temp1, alternative=alt,
                         correct=FALSE)$p.value
wlc_sim[5,2]=wilcox.test(tot_sim$u1_alg1, tot_sim$u1_static,
                         paired = temp1, alternative=alt,
                         correct=FALSE)$p.value
wlc_sim[6,2]=wilcox.test(tot_sim$u1_alg1, tot_sim$u1_alg0,
                         paired = temp1, alternative=alt,
                         correct=FALSE)$p.value

rm(tot_sim, alt, temp1)



