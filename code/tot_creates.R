tot_creates = function(tyt) {
  # this function initialize a dataframe tot to store the results of the analysis
  
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
  tot["shape1"] = rep(NaN, length(tot$Freq))
  tot["shape2"] = rep(NaN, length(tot$Freq))
  for (i in 1:length(tot$Var1)) {
    temp = subset(tyt,user_id == i)
    tot$shape1[i] = temp$shape1[1]
    tot$shape2[i] = temp$shape2[1]
  }

  
  tot = subset(tot, tot$Freq>6)
  tot = tot[1:1000,]
  
  return(tot)
}