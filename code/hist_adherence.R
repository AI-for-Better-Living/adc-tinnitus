# overlayed histograms of adherence

load("~/Code/triggering algorithm/clean_data.RData")
tot_real=tot
load("~/Code/triggering algorithm/simulated_data.RData")
tot_sim=tot
rm(tyt, tot)

require(plotly)

color1="rgb(0,204,204)"
color2="rgb(153,153,255)"

prova=rep(0,max(tot_real$newFreq))
prova2=rep(0,max(tot_real$newFreq))
for (i in 1:max(tot_real$newFreq)) {
  prova[i] = length(which(tot_real$newFreq==i))
  prova2[i] = length(which(tot_sim$newFreq==i))
}

fig <- plot_ly()
fig <- fig %>% add_trace(x = c(1:max(tot_real$newFreq)), 
                         y = prova2, 
                         type="bar",
                         name="simulated data", 
                         opacity=0.5, 
                         marker = list(color=color2))
fig <- fig %>% add_trace(x=c(1:max(tot_real$newFreq)),
                         y=prova, type="bar", 
                         name ="real data", 
                         opacity=0.5, 
                         marker = list(color=color1))
fig <- fig %>% layout(barmode = "overlay",xaxis = list(title="number of samples"))

fig = fig  %>% layout(title = "Adherence",
         yaxis = list(
           side = "left",
           title = "number of subjects"
         ))
 fig 
 
length(which(tot_real$newFreq<=19)) - length(which(tot_real$newFreq<10))

