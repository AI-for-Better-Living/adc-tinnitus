# This script produces simulated data for the application of Algorithm 2

N_particpants = 1000;

# seeds = sample(c(1:10000), N_particpants, replace = FALSE)
load("~/Code/triggering algorithm/seeds.RData")

hoped_x_day=6;
length_exp_in_days=30;
hoped_final=hoped_x_day*length_exp_in_days;

# load("~/Code/triggering algorithm/clean_data.RData")
# prob = mean(tot$newFreq[tot$newFreq])/hoped_final
prob = 0.1985608
set.seed(310194)
N_samples_x_particpant = rbinom(N_particpants,
                                size=hoped_final,
                                prob=prob)

gg=seq(from=as.Date("2014/09/01"), to=as.Date("2014/09/30"),by="1 days")
gg=c(gg,gg,gg,gg,gg,gg)
gg=sort(gg)

shape1 = rep(NaN, N_particpants); shape2 = rep(NaN, N_particpants);

df=data.frame()

for (i in 1:N_particpants) {
  p=N_samples_x_particpant[i]/hoped_final
  set.seed(seeds[i])
  A = c(1,sample(c(0,1),size=(hoped_final-1),prob=c(1-p,p), replace=TRUE))
  count=1
  # this can improve
  shape1[i]=runif(1,0.5,10)
  shape2[i]=runif(1,0.5,10)
  
  user_id=rep(NaN,sum(A))
  save=as.Date(rep(NaN,sum(A)))
  save_date=as.Date(rep(NaN,sum(A)))
  question2=rep(NaN,sum(A))
  
  for (j in 1:hoped_final) {
    if (A[j]==1) {
      user_id[count]=i
      save[count]=gg[j]
      save_date[count]=gg[j]
      question2[count]=rbeta(1,shape1=shape1[i], shape2=shape2[i])
      count=count+1
    }
  }
  
  df2=data.frame(user_id,save,save_date,question2)
  df=rbind(df,df2)
}

tyt=df
tot=as.data.frame(table(tyt$user_id))
tot$newFreq=tot$Freq

# ------------------------------------------------------------------------------
# Columns for the measures of accuracy 
tot["f1_random"]=rep(NaN, length(tot$Freq))
tot["f1_static"]=rep(NaN, length(tot$Freq))
tot["f1_alg0"]=rep(NaN, length(tot$Freq))
tot["f1_alg1"]=rep(NaN, length(tot$Freq))

tot["u1_random"]=rep(NaN, length(tot$Freq))
tot["u1_static"]=rep(NaN, length(tot$Freq))
tot["u1_alg0"]=rep(NaN, length(tot$Freq))
tot["u1_alg1"]=rep(NaN, length(tot$Freq))


# ------------------------------------------------------------------------------
# saving the real values of the Beta parameters
tot["shape1"] = shape1
tot["shape2"] = shape2

rm(N_particpants, N_samples_x_particpant, gg, count,
  A, i,j,p,user_id, save, save_date,question2, df2, df, 
   shape1, shape2, hoped_final, hoped_x_day, length_exp_in_days, prob, 
  seeds)
  
