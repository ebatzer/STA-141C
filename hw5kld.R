library(tidyverse)

# BenFord distribution function
BenFord <- function(x){
  log10(1 + (1/x))
}

# Should sum to 1 
sum(BenFord(1:9))

# Uniform distribution function
Uniform <- function(x){
  (1 / length(x))
}

# KLD function
KLD = function(x, Qx = "BenFord"){
  
  if(Qx == "BenFord"){
    pq = log(x / BenFord(c(1:9)))
    pq[pq %in% c(Inf, -Inf)] = 0
    k = sum(x * pq)
    
  }else if(Qx == "Uniform"){
    
    pq = log(x / Uniform(x))
    pq[pq %in% c(Inf, -Inf)] = 0
    k = sum(x * pq)
    
  }
  
  return(k)
  
}                             

# Reading in digit counts
digits = read.csv("digit_counts.csv", header = TRUE)

# Transposing dataframe from long to wide
digit_wide = digits %>% 
  select(-X) %>% 
  spread(key = "digit", value = "Freq")

# Filtering dataset to >100 observations
cont_table = digit_wide[rowSums(digit_wide[,2:10]) > 100,]

# Setting first column as rownames and adding column names
rownames(cont_table) = cont_table[,1]
cont_table = cont_table[-1,-1]
colnames(cont_table) = c(c(1:9))

# Calculating overall observed frequency
obs_freq = colSums(cont_table[,])
obs_prop = obs_freq / sum(obs_freq)

# Creating proportional frequency table
cont_prop = cont_table / rowSums(cont_table)

# How many rows in contingency table?
nrow(cont_table) #39479

# KLD of a uniform distribution
KLD(Uniform(9))

# Calculating KLD of all funding recipients 
kld_scores = apply(cont_prop, FUN = KLD, MARGIN = 1)

# Histogram of scores
data.frame(kld_scores) %>% 
  ggplot(aes(x = kld_scores)) +
  geom_histogram(bins = 50) +
  xlab("KLD") +
  ylab("Frequency") +
  ggtitle("KLD Distribution") +
  geom_vline(xintercept = mean(kld_scores), color = "red") +
  geom_text(aes(x = 2, y = 5000),
            label = paste("Mean =", round(mean(kld_scores),2))) +
  theme_bw()

# Max
max(kld_scores)
# Min
min(kld_scores)
# SD
sd(kld_scores)

# How many KLD scores were above 2.5?
sum(kld_scores > 2.5)

# Bootstrapping

KLDboot = function(x){
  n = sum(x)
  randomsamp = tabulate(sample(x = c(1:9), size = n, prob = x / n, replace = TRUE))
  KLD_boot = KLD(randomsamp / n)
  return(KLD_boot)
}

boots = replicate(1000, KLDboot(cont_table[4,]))
quantile(boots, c(.05, .50, .95)) 
mean(boots)
