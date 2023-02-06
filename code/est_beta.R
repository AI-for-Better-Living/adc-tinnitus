# estimation of the parameters of a Beta distribution through the 
# Newton-Raphson method (and/or moment's method)

est_beta=function(data, art_data= c(0.4,0.6), sd_lb = 0.1) {
  
  N=length(data); 
  iter=0; update_diff=100;
  
  # Methods of the moment
  shape1_hat=NaN; shape2_hat=NaN;
  
  # manual adjustment to include almost constant time series
  if (sd(data)<sd_lb | sd(data)^2>=mean(data)*(1-mean(data))) {
    data = c(data, art_data)
    N=length(data)
  }
  # all(data*(1-data) ==rep(0,length(data)))
  
  if (sd(data)^2<mean(data)*(1-mean(data))) {
    # initial values through the method of moments
    nu=mean(data)*(1-mean(data))/sd(data)^2-1;
    shape1_hat=mean(data)*nu;
    shape2_hat=(1-mean(data))*nu;
    
  } else {
    print("The condition on the mean and the variance is not satisfied, indeed:")
    print(paste0("sd(data)^2 = ",sd(data)^2))
    print(paste0("mean(data)*(1-mean(data)) = ",mean(data)*(1-mean(data))))
  }


  # param=c(shape1_hat,shape2_hat,update_diff,iter)   if using Newton-Raphson
  param=c(shape1_hat,shape2_hat)
  return(param)
}


# Description of the function

# input:  data = vector of observations;
#         max_iter = maximum number of iterations for the Newton-Raphson method;
#         epsilon  = stopping criteria based on the difference between 
#                    the old and the new estimated parameters;
#         art_data = vector to be added to the data if the standard deviation of  
#                    the original data is smaller than sd_lb;
#         sd_lb    = lower threshold of the standard deviation under which 
#                    art_data is added to the original data;

# output: param = list of variables of interest, i.e.
#                   1) alpha - estimated shape 1 of the Beta dist.;
#                   2) beta - estimated shape 2 of the Beta dist.;

# Note: The inputs art_data and sd_lb are used to avoid problems with the 
#       estimation of the parameters using the method of moments which does not 
#       work if the standard deviation is zero (it is the denominator). 

# For a mathematical description of the Newton-Raphson method,
# see Minka, T.P., 2000. Estimating a Dirichlet distribution.
# https://tminka.github.io/papers/dirichlet/minka-dirichlet.pdf
# The starting point for the method is given by the method of moments,
# see https://en.wikipedia.org/wiki/Beta_distribution


