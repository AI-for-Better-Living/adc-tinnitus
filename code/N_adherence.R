# Estimation of the final number of samples by the Binomial model for adherence

N_adherence = function(dates, 
                       hoped_x_day,length_exp_in_days) {
  
  hoped_final=hoped_x_day*length_exp_in_days;
  
  total_range=seq(as.Date(min(dates)),to=as.Date(max(dates)),by='days')
  A=0;
  for (j in 1:length(total_range)) {
    if (any(total_range[j]==dates)) {
      A = A+length(which(total_range[j]==dates))
    }
  }
  a=A/(length(total_range)*hoped_x_day);
  N_t=a*hoped_final
  
  return(N_t)
}

### Description of the function ------------------------------------------------

# Input
#   dates              = dates ("dd/mm/yyyy");
#   hoped_x_day        = samples of data hoped to be collected daily;
#   length_exp_in_days = length of the experiment in days.

# Output
#   N_t = Estimation of the final number of samples by the
#         Binomial model for adherence
