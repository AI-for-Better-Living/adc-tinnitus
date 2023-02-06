## Sensitivity analysis for the artificial data 0.4 and 0.6

# seeds6 = sample(c(1:1000000000),10000, replace = FALSE)
load("seeds6.RData")

# First, we need to create a simulated dataset.

# We assume the starting point S=6 to be fixed, thus we consider the estimations
# of the Beta parameters for samples of size S-1 = 5
temp=5
N=5000 # number of subjects
shape1 = rep(NaN, N); shape2 = rep(NaN, N);
df= matrix(NaN,N,temp)
threshold = 0.1
df2 = data.frame()

for (i in 1:N) {
  set.seed(seeds6[i])
  shape1[i]=runif(1,0.5,10)
  shape2[i]=runif(1,0.5,10)
  df[i,] = rbeta(temp,shape1=shape1[i], shape2=shape2[i])
  data = df[i,] 
  if (sd(data)<threshold | sd(data)^2>=mean(data)*(1-mean(data))) {
    df2 = rbind(df2,c(df[i,],shape1[i], shape2[i]))
  }
}
colnames(df2) = c('x1','x2','x3','x4','x5','shape1','shape2')

source("est_beta.R"); 

grid = seq(0, 1, by=0.05)
P = length(df2[,1])
df3 = data.frame(rep(NaN,P), rep(NaN,P))
colnames(df3) = c('est_shape1','est_shape2')

# change to a diagonal matrix?

mse_shape1 = matrix(NaN, length(grid), length(grid))
mse_shape2 = matrix(NaN, length(grid), length(grid))
count1 = 1
for (k in grid) {
  count2 = 1 
  for (j in grid) {
    for (i in 1:P) {
      df3[i,] = est_beta(data=df[i,1:temp], art_data= c(k,j), sd_lb = threshold)
    }
    mse_shape1[count1,count2] = mean((df3$est_shape1 - df2$shape1)^2) 
    mse_shape2[count1,count2] = mean((df3$est_shape2 - df2$shape2)^2) 
  count2 = count2 + 1
  }
  count1 = count1+1
}


# plot the surface
require(plotly)

# fig1 <- plot_ly(x = ~grid, y = ~grid, z = ~mse_shape1, scene = 'scene2') %>% add_surface()
# fig1 <- fig1 %>% layout(
#   scene = list(
#     camera=list(
#       eye = list(x=1.87, y=1, z=0.64)
#     )
#   )
# )
# fig1
# fig2 <- plot_ly(x = ~grid, y = ~grid, z = ~mse_shape2, scene = 'scene2') %>% add_surface()
# fig2 <- fig2 %>% layout(
#   scene = list(
#     camera=list(
#       eye = list(x=1.87, y=1, z=0.64)
#     )
#   )
# )
# fig2
MSE = mse_shape1 + mse_shape2
fig3 <- plot_ly(x = ~grid, y = ~grid, z = ~MSE, scene = 'scene1') %>% add_surface()
fig3 <- fig3 %>% layout(
  scene = list(
    camera=list(
      eye = list(x=1.99, y=1, z=0.64)
    )
  )
)
fig3


mse = data.frame(MSE)
colnames(mse) = c('0','0.05','0.1','0.15','0.2','0.25','0.3','0.35','0.4','0.45','0.5','0.55','0.6','0.65','0.7','0.75','0.8','0.85','0.9','0.95','1')
rownames(mse) = c('0','0.05','0.1','0.15','0.2','0.25','0.3','0.35','0.4','0.45','0.5','0.55','0.6','0.65','0.7','0.75','0.8','0.85','0.9','0.95','1')
mse['0.4', '0.6']

rm(df,count1, count2, data, grid, j, i, k, N, P, temp, seeds6, shape1, shape2, threshold, est_beta)
rm(df2, df3, mse, MSE, mse_shape1, mse_shape2)
save.image("sen_analysis.RData")


