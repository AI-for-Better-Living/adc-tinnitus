## graphical representation of the algorithms

# ------------------------------------------------------------------------------
## CREATE SIMULATED DATA
N=30
param=c(0.9896832, 1.1785485, 100.0000000, 0.0000000)
p=N/180
set.seed(1)
A = c(1,sample(c(0,1),size=(180-1),prob=c(1-p,p), replace=TRUE))
x = rbeta(sum(A),shape1=param[1], shape2=param[2])
gg=seq(from=as.Date("2014/09/01"), to=as.Date("2014/09/30"),by="1 days")
gg2 = seq(from=as.POSIXct("2014-09-01 01:00"),to=as.POSIXct("2014-09-30 23:59"),by="4 hours")
gg=c(gg,gg,gg,gg,gg,gg)
gg=sort(gg)
df=data.frame()
count=1
user_id=rep(NaN,sum(A))
save=as.POSIXct(rep(NaN,sum(A)))
save_date=as.Date(rep(NaN,sum(A)))
question2=rep(NaN,sum(A))
for (j in 1:180) {
  if (A[j]==1) {
    user_id[count]=1
    save[count]=gg2[j]
    save_date[count]=gg[j]
    question2[count]=x[count]
    count=count+1
  }
}
df=data.frame(user_id,save,save_date,question2)

rm(count, gg, gg2, j, N, p, param, question2, save, save_date, 
   user_id, x, A)

source("plot_repr.R")

# ------------------------------------------------------------------------------
## GRAPHICAL REPRESEANTATION OF ALGORITHM 1

source("trigger1.R");
triggers=trigger1(data=df$question2,dates=df$save_date)

df$high_quantiles= rep(NaN, length(triggers))
df$low_quantiles= rep(NaN, length(triggers))
df$triggers= triggers
for (n in 6:length(df$question2)) {
  
  # estimation of the tinnitus severity parameters
  param=est_beta(df$question2[1:(n-1)]) 
  
  # incorporating adherence 
  N_t=N_adherence(df$save_date[c(1:n)], hoped_x_day=6, length_exp_in_days=30)
  
  if (N_t>4+6-1) {
    alpha= 4/(N_t-6+1)
  } else {
    alpha = 1
  }
  
  df$high_quantiles[n] = qbeta(1-alpha/2, shape1=param[1], shape2=param[2])
  df$low_quantiles[n] = qbeta(alpha/2, shape1=param[1], shape2=param[2])
}

df1 = subset(df, triggers==1)
df0 = subset(df, triggers==0)

temp1 = df$high_quantiles[length(df$user_id)]
temp2 = df$low_quantiles[length(df$user_id)]
df$gt_h =  temp1
df$gt_l = temp2

fig4 = plot_repr(df,df1,df0, title_xaxis = "Algorithm 2")

# ------------------------------------------------------------------------------
## GRAPHICAL REPRESENTATION OF THE RANDOM ALGORITHM
source("trigger_random.R"); source("N_adherence.R")
y=as.Date(df$save_date)
triggers=trigger_random(dates=y)

df$high_quantiles= rep(NaN, length(triggers))
df$low_quantiles= rep(NaN, length(triggers))
df$triggers= triggers

df1 = subset(df, triggers==1)
df0 = subset(df, triggers==0)
df$gt_h = temp1
df$gt_l = temp2

fig1 = plot_repr(df,df1,df0, legend=FALSE, title_xaxis = "Random algorithm")


# ------------------------------------------------------------------------------
## GRAPHICAL REPRESENTATION OF THE STATIC ALGORITHM
source("trigger_static.R"); source("N_adherence.R")
triggers=trigger_static(data=df$question2)

df$high_quantiles= rep(NaN, length(triggers))
df$high_quantiles[6:length(df$user_id)]= 0.85
df$low_quantiles= rep(NaN, length(triggers))
df$low_quantiles[6:length(df$user_id)]= 0.15
df$triggers= triggers

df1 = subset(df, triggers==1)
df0 = subset(df, triggers==0)
df$gt_h =  temp1
df$gt_l = temp2

fig2 = plot_repr(df,df1,df0, legend=FALSE, title_xaxis = "Static algorithm")

# ------------------------------------------------------------------------------
## GRAPHICAL REPRESENTATION OF ALGORITHM 0
source("trigger0.R"); source("N_adherence.R")
triggers=trigger0(data=df$question2)

df$high_quantiles= rep(NaN, length(triggers))
df$low_quantiles= rep(NaN, length(triggers))
df$triggers= triggers
for (n in 6:length(df$question2)) {
  
  # estimation of the tinnitus severity parameters
  param=est_beta(df$question2[1:(n-1)]) 
  
  alpha = 0.10;
  
  df$high_quantiles[n] = qbeta(1-alpha/2, shape1=param[1], shape2=param[2])
  df$low_quantiles[n] = qbeta(alpha/2, shape1=param[1], shape2=param[2])
}

df1 = subset(df, triggers==1)
df0 = subset(df, triggers==0)
df$gt_h =  temp1
df$gt_l = temp2

fig3 = plot_repr(df,df1,df0, legend=FALSE, title_xaxis = "Algorithm 1")

#-------------------------------------------------------------------------------
fig <- subplot(fig1, fig2, fig3, fig4, nrows = 2, margin = 0.06, titleX = TRUE) 
fig

rm(alpha, n, param, triggers, N_adherence, est_beta, trigger0, N_t, 
   temp1, temp2, y, plot_repr, trigger_random, trigger_static, trigger1,
   fig1, fig2, fig3, fig4, df, df1, df0)

save.image("reprgraph.RData")
