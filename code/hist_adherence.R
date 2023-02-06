# overlayed histograms of adherence

load("tot.RData")

require(plotly)

color1="rgb(0,204,204)"
color2="rgb(153,153,255)"
color3="rgb(255,255,0)"

# temp=max(tot_real$newFreq)
temp = 458
prova=rep(0,temp)
prova2=rep(0,temp)
prova3=rep(0,temp)
for (i in 1:temp) {
  prova[i] = length(which(tot_real$newFreq==i))
  prova2[i] = length(which(tot_sim$newFreq==i))
  prova3[i] = length(which(tot_sim2$newFreq==i))
}

fig <- plot_ly()
fig <- fig %>% add_trace(x=c(1:temp),
                         y=prova, type="bar",
                         name ="real data",
                         opacity=0.5,
                         marker = list(color=color1))
fig <- fig %>% add_trace(x = c(1:temp), 
                         y = prova2, 
                         type="bar",
                         name="sim data 1", 
                         opacity=0.5, 
                         marker = list(color=color2))
fig <- fig %>% add_trace(x = c(1:temp), 
                         y = prova3, 
                         type="bar",
                         name="sim data 2", 
                         opacity=0.5, 
                         marker = list(color=color3))
fig <- fig %>% layout(barmode = "overlay",xaxis = list(title="number of samples"))

fig = fig  %>% layout(yaxis = list(
           side = "left",
           title = "number of subjects"
         ))
fig 

rm(color1, color2, color3, i, prova2, prova3, prova, temp)
#rm(tot_sim, tot_sim2, tot_real)

save.image("hist_adherence.RData")

