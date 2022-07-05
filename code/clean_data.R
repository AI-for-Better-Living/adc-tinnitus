# Importing and cleaning the data

# ------------------------------------------------------------------------------
# Import and clean the data
tyt <- read.csv("~/Code/data/TrackMyTinnitus/statistics21062020.csv", 
                na.strings="NULL")
tyt=tyt[,c(2,3,4,11)]
require(tidyr)
tyt=drop_na(tyt)
tyt=unique(tyt)
# there are also some duplicates which have same time and user_id, but different 
# tinnitus severity; only the first of this duplicates is considered. 
d1=tyt[c(1,2,3)]
c=duplicated(d1)
tyt=tyt[which(c==FALSE),]
rm(d1,c)

# ------------------------------------------------------------------------------
# The table tot1 shows the total number of samples collected from each 
# participant to the study
tot1=as.data.frame(table(tyt["user_id"]))

# First, we restrict the table to consider only the samples collected within 
# 30 days from the first interaction with the app for each subject
# We keep track of the number of samples lost in this processes in column 
# tot1$obs_lost_2
tot1$obs_lost_2 = rep(NaN,length(tot1$Var1))

hoped_x_day=6;
length_exp_in_days=30;
hoped_final=hoped_x_day*length_exp_in_days;

df=data.frame()

for (subject_id in tot1$Var1) {
  temp = subset(tyt, user_id==subject_id)
  supp = length(temp[,1])
  
  if (any(TRUE == (difftime(temp$save_date,temp$save_date[1],units = "days")>length_exp_in_days))) {
    temp=temp[-which(difftime(temp$save_date,temp$save_date[1],units = "days")>length_exp_in_days),]
    df=rbind(df,temp)
    tot1$obs_lost_2[which(tot1$Var1==subject_id)] = supp-length(temp[,1])
  } else {
    df=rbind(df,temp)
    tot1$obs_lost_2[which(tot1$Var1==subject_id)] = 0
  }
}

# we lose a total of 53395 samples
length(tyt$user_id)- length(df$user_id)

# we rewrite tyt as the new dataframe df
tyt=df;
rm(df)

tot1$newFreq=tot1$Freq-tot1$obs_lost_2

plot(sort(tot1$obs_lost_2/tot1$Freq), ylab="percentage of lost information",
     xlab="particpants - reordered based on the values on the y axis")
# table(tot1$obs_lost_2/tot1$Freq)
# For 77% of the participants (2130/2752), there is no information loss in this
# process, that is they interacted with the app only during their first month.

# ---------------------------------------------------------------------------
# Finally, only participants with more than 6 observations  within 30 days from
# their first interaction with the app are considered
# They amount to 33%(=911) of the total number of participants after the data
# has been cleaned (=2752)
tot=subset(tot1,newFreq>6)

# Notice that if we had not excluded samples after the first 30 days, this 
# percentage would be 38%

# barplot
prova=rep(0,max(tot$newFreq))
for (i in 1:max(tot$newFreq)) {
  prova[i] = length(which(tot$newFreq==i))
}
barplot(prova, ylim=c(0,70), 
        main="barplot",
        xlab="n", 
        ylab="number of users with n observations")
length(tot$newFreq)/length(tot1$newFreq)
rm(tot1,i,prova)

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

rm(subject_id, supp, temp, length_exp_in_days,hoped_final, hoped_x_day)


