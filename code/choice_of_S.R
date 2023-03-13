# About the choice of the starting point S

png(file="results/choice_of_S.png",width=1778, height=696)

N=5000

# seeds5 = sample(c(1:1000000), N, replace = FALSE)
load("data/seeds5.RData")

iteration=30
shape1 = rep(NaN, N); shape2 = rep(NaN, N);
df= matrix(NaN,N,iteration)
threshold_1 = 0.1
threshold_2 = 0.05
threshold_3 = 0.01


for (i in 1:N) {
  set.seed(seeds5[i])
  shape1[i]=runif(1,0.5,10)
  shape2[i]=runif(1,0.5,10)
  df[i,] = rbeta(iteration,shape1=shape1[i], shape2=shape2[i])
  data = df[i,] 
}

source("est_beta.R"); 

param_alpha= matrix(NaN,N,iteration)
param_beta= matrix(NaN,N,iteration)

for (j in 2:iteration) {
  for (i in 1:N) {
    param_alpha[i,j] = est_beta(data=df[i,1:j])[1]
    param_beta[i,j] = est_beta(data=df[i,1:j])[2]

  }
}

mse_alpha = matrix(NaN, 1, iteration)
mse_beta = matrix(NaN, 1, iteration)


for (j in 2:iteration) {
  mse_alpha[j] = mean((param_alpha[,j] - shape1)^2)
  mse_beta[j] = mean((param_beta[,j] - shape2)^2)
}

#-------------------------------------------------------------------------------

condi_1 = matrix(0,N,iteration) 
condi_2 = matrix(0,N,iteration) 
condi_3 = matrix(0,N,iteration) 

for (j in 2:iteration) {
  for (i in 1:N) {
    if (sd(df[i,1:j])<threshold_1 | sd(df[i,1:j])^2>=mean(df[i,1:j]*(1-mean(df[i,1:j])))) {
      condi_1[i,j] = 1
      if (sd(df[i,1:j])<threshold_2 | sd(df[i,1:j])^2>=mean(df[i,1:j]*(1-mean(df[i,1:j])))) {
        condi_2[i,j] = 1
        if (sd(df[i,1:j])<threshold_3 | sd(df[i,1:j])^2>=mean(df[i,1:j]*(1-mean(df[i,1:j])))) {
          condi_3[i,j] = 1
        }
      }
    }
  }
}


condi_sum_1 = matrix(NaN, 1, iteration)
condi_sum_2 = matrix(NaN, 1, iteration)
condi_sum_3 = matrix(NaN, 1, iteration)

for (j in 2:iteration) {
  condi_sum_1[j] = sum(condi_1[,j])/N
  condi_sum_2[j] = sum(condi_2[,j])/N
  condi_sum_3[j] = sum(condi_3[,j])/N
}

#-------------------------------------------------------------------------------
# plots

par(mfrow=c(1,2))

plot(mse_alpha[2:iteration], col = "5", ylab = "MSE", xlab = "s")
points(mse_beta[2:iteration], col = "6")
legend("topright", legend = expression(paste(hat(delta)[s]), paste(hat(xi)[s])), col = c(5,6), fill = c(5,6))

plot(condi_sum_1[2:iteration], col = "7", xlab = "s", ylab = expression(paste(rho)), ylim = c(0,0.7))
points(condi_sum_2[2:iteration], col= "8")
points(condi_sum_3[2:iteration], col = "9")
legend("topright", legend = expression(paste(tau, " = ", 0.1), paste(tau, " = ", 0.05), paste(tau, " = ", 0.01)), col = c(7,8,9), fill = c(7,8,9))

dev.off()
