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

rm(alpha, n, N_t, param, triggers, N_adherence, est_beta, trigger1)

require(plotly)
color1 = "rgb(58,95,205)"
color2 = "rgba(0,100,80,0.2)"
color3 = "rgb(200, 200, 200)"

vline <- function(x = 0, color = "green") {
  list(
    type = "line",
    y0 = 0,
    y1 = 1,
    yref = "paper",
    x0 = x,
    x1 = x,
    line = list(color = color, dash="dot")
  )
}

fig = plot_ly(df) %>% 
  layout(xaxis=list(range = c(min(df$save_date)-1,max(df$save_date)+1), 
                    title = "time"),
         yaxis = list(title = "tinnitus severity"))

fig = fig%>% add_trace(df, x=~save, y=df$high_quantiles[length(df$user_id)], type='scatter', mode='lines', 
                       name = "ground truth thresholds",line = list(color=color3, shape="hv"), opacity = 1)
fig = fig%>% add_trace(df, x=~save, y=df$low_quantiles[length(df$user_id)], type='scatter', mode='lines', 
                       showlegend = FALSE,line = list(color=color3, shape="hv"), opacity = 1)
fig = fig%>% add_trace(df, x=~save, y=df$low_quantiles[length(df$user_id)], type='scatter', mode='lines',
                       name = "ground truth CI", line = list(color=color3, shape="hv"), opacity =0.5,
                       fill = 'tonexty', fillcolor=color3)
fig = fig%>% layout(plot_bgcolor = "#e5ecf6", shapes = list(type = "rect",
                                                            fillcolor = color3,
                                                            line = list(color = color3),
                                                            opacity = 0.2,
                                                            y0 = df$low_quantiles[length(df$user_id)],
                                                            y1 = df$high_quantiles[length(df$user_id)],
                                                            x0 = min(df$save_date) ,
                                                            x1 = max(df$save)))


fig = fig%>% add_trace(df, x=~save, y=~high_quantiles, type='scatter', mode='lines', 
                       name="thresholds",line = list(color=color2, shape="hv"), opacity = 1)
fig = fig%>% add_trace(df, x=~save, y=~low_quantiles, type='scatter', mode='lines', 
                       name = "adaptive confidence intervals", line = list(color=color2, shape="hv"), opacity =0.5, 
                       fill = 'tonexty', fillcolor=color2)
fig = fig%>% add_trace(df, x=~save, y=~low_quantiles, type='scatter', mode='lines', 
                       showlegend=FALSE, line = list(color=color2, shape="hv"), opacity =1)


fig = fig%>% add_trace(data=df1, x=~save, y=~question2, type = 'scatter', mode = 'markers',
                       marker = list(color=color1, size =6.5, 
                                     line = list(color=color1, width=1)), 
                       name = "triggered tasks")
fig = fig%>% add_trace(data=df0, x=~save, y=~question2, type = 'scatter', mode = 'markers',
                       marker = list(color="rgb(255, 255, 255)", size = 7.5, 
                                     line=list(color=color1, width = 1.5 )), 
                       name='untriggered tasks')
fig = fig%>% add_trace(data = df, x=~save, y=~question2, type='scatter', mode='lines',
                       name="tinnitus sevrity", line = list(color=color1))

fig
fig1 = fig


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

rm(alpha, n, param, triggers, N_adherence, est_beta, trigger0)

require(plotly)
color1 = "rgb(58,95,205)"
color2 = "rgba(0,100,80,0.2)"
color3 = "rgb(200, 200, 200)"

vline <- function(x = 0, color = "green") {
  list(
    type = "line",
    y0 = 0,
    y1 = 1,
    yref = "paper",
    x0 = x,
    x1 = x,
    line = list(color = color, dash="dot")
  )
}

fig = plot_ly(df) %>% 
  layout(xaxis=list(range = c(min(df$save_date)-1,max(df$save_date)+1), 
                    title = "time"),
         yaxis = list(title = "tinnitus severity"))

fig = fig%>% add_trace(df, x=~save, y=df$high_quantiles[length(df$user_id)], type='scatter', mode='lines', 
                       showlegend = FALSE, line = list(color=color3, shape="hv"), opacity = 1)
fig = fig%>% add_trace(df, x=~save, y=df$low_quantiles[length(df$user_id)], type='scatter', mode='lines', 
                       showlegend = FALSE,line = list(color=color3, shape="hv"), opacity = 1)
fig = fig%>% add_trace(df, x=~save, y=df$low_quantiles[length(df$user_id)], type='scatter', mode='lines',
                       showlegend = FALSE, line = list(color=color3, shape="hv"), opacity =0.5,
                       fill = 'tonexty', fillcolor=color3)
fig = fig%>% layout(plot_bgcolor = "#e5ecf6", shapes = list(type = "rect",
                                                            fillcolor = color3,
                                                            line = list(color = color3),
                                                            opacity = 0.2,
                                                            y0 = df$low_quantiles[length(df$user_id)],
                                                            y1 = df$high_quantiles[length(df$user_id)],
                                                            x0 = min(df$save_date) ,
                                                            x1 = max(df$save)))


fig = fig%>% add_trace(df, x=~save, y=~high_quantiles, type='scatter', mode='lines', 
                       showlegend = FALSE,line = list(color=color2, shape="hv"), opacity = 1)
fig = fig%>% add_trace(df, x=~save, y=~low_quantiles, type='scatter', mode='lines', 
                       showlegend = FALSE, line = list(color=color2, shape="hv"), opacity =0.5, 
                       fill = 'tonexty', fillcolor=color2)
fig = fig%>% add_trace(df, x=~save, y=~low_quantiles, type='scatter', mode='lines', 
                       showlegend=FALSE, line = list(color=color2, shape="hv"), opacity =1)


fig = fig%>% add_trace(data=df1, x=~save, y=~question2, type = 'scatter', mode = 'markers',
                       marker = list(color=color1, size =6.5, 
                                     line = list(color=color1, width=1)), 
                       showlegend = FALSE)
fig = fig%>% add_trace(data=df0, x=~save, y=~question2, type = 'scatter', mode = 'markers',
                       marker = list(color="rgb(255, 255, 255)", size = 7.5, 
                                     line=list(color=color1, width = 1.5 )), 
                       showlegend = FALSE)
fig = fig%>% add_trace(data = df, x=~save, y=~question2, type='scatter', mode='lines',
                       showlegend = FALSE, line = list(color=color1))

fig
fig2 = fig

fig <- subplot(fig2, fig1, nrows = 2) %>% 
  layout(title = "Graphical representation of the algorithms")
fig
