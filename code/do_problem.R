# simulation of A^{star} 
# i.e. set of maximum points of U_{1}(S,alpha) = -(E(W)-4)^{2}

N = 180;
wanted_triggers=4
alpha = seq(0,1,by=0.05); S = seq(1,N,by=1);
alpha2 = wanted_triggers/(N-S+1)
alpha2[alpha2>=1] = 1
z = matrix(NaN, length(S),length(alpha));
for (i in 1:length(alpha)) {
  for (j in 1:length(S)) {
    z[j,i] = - (N-S[j]+1)*alpha[i]*(1-alpha[i]);
  }
}
z = t(z)
U2 = z
require(plotly)

color1 = "red"
color2 = "rgb(255,128,0)"

fig <- plot_ly(x = S)
fig = fig %>% add_contour(x = S, y = ~alpha,z = ~U2, type = "contour", 
                          contours = list(coloring = 'heatmap', 
                                          showlabels = TRUE), opacity = 1)
fig = fig %>% hide_colorbar()
fig = fig %>% add_trace(x =S, y =~alpha2, type = "scatter",  mode = 'markers', 
                        name =TeX("A^\\text{*}"), 
                        showlegend=TRUE, marker = list(color=color1, size = 4))
fig <- fig %>% layout(legend = list(x = 200, y = 0.5), 
                      xaxis = list(title = "starting point"),
                      yaxis = list(title = "significance level"))
fig <- fig %>% config(mathjax = 'cdn')

fig

require("processx")
withr::with_dir("results", orca(fig, "do_problem.png", width = 2038, height = 848))

rm(U2, z, alpha, alpha2, i, j, N, S, wanted_triggers, alpha3, color1, color2)

save.image("results/do_problem.RData")