sim = function(var = TRUE, 
               seeds_var, seeds_samples,
               var_shape1 = 1, var_shape2 = 4, 
               N_subjects = 3000) {
  # This script produces simulated data
  
  hoped_x_day=6;
  length_exp_in_days=30;
  hoped_final=hoped_x_day*length_exp_in_days;
  
  N_samples_x_particpant = rep(NaN,N_subjects)
  if (var == TRUE) {
    rate = rep(NaN,N_subjects)
    
    for (i in 1:N_subjects) {
      set.seed(seeds_var[i])
      rate[i] = rbeta(1,shape1 = var_shape1,var_shape2)
      N_samples_x_particpant[i] = rbinom(1,size=hoped_final,prob=rate[i])
    }
  } else if (var == FALSE) {
    prob = 0.1985608
    set.seed(310194)
    rate = rep(prob,N_subjects)
    N_samples_x_particpant = rbinom(N_subjects,
                                    size=hoped_final,
                                    prob=prob)
  }
  
  gg=seq(from=as.Date("2014/09/01"), to=as.Date("2014/09/30"),by="1 days")
  gg=c(gg,gg,gg,gg,gg,gg)
  gg=sort(gg)
  
  shape1 = rep(NaN, N_subjects); shape2 = rep(NaN, N_subjects);
  
  df=data.frame()
  
  for (i in 1:N_subjects) {
    set.seed(seeds_samples[i])
    A = c(1,sample(c(0,1),size=(hoped_final-1),prob=c(1-rate[i],rate[i]), replace=TRUE))
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
    
    df2=data.frame(user_id,save,save_date,question2, shape1[i], shape2[i])
    df=rbind(df,df2)
  }
  
 return(df)
  
}

### Description of the function ------------------------------------------------

# Input
#     var          = is the probability of adherence varaible across subjects?
#                    either TRUE or FALSE
#     var_shape1   = first parameter of the Beta distribution to sample the
#                    probability that a subject is adherent
#     var_shape2   = second parameter of the Beta distribution to sample the
#                    probability that a subject is adherent
#     seeds_var    = list of seeds used to compute the probability of 
#                    adherence; used only if var is TRUE
#     seeds_sample = list of seeds used to sample the quantity of interest
#     N_subjects   = Number of participants


# Output
#     df           = a simulated datasets which inclused the user_is, the save data, 
#                    the save_time and data and the tinnitus severity and the 
#                    true values of the Beta distribution parameters

