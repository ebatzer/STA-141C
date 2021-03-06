library(tidyverse)

# Benford distribution function
Benford <- function(x){
  log10(1 + (1/x))
}

# Should sum to 1 
sum(Benford(1:9))

# Uniform distribution function
Uniform <- function(x){
  (1 / length(x))
}

# KLD function
KLD = function(x, Qx = Benford(c(1:9))){
  
  pq = log(x / Qx)
  pq[pq %in% c(Inf, -Inf)] = 0
  k = sum(x * pq)
  
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
round(obs_prop, 3)

# Creating proportional frequency table
cont_prop = cont_table / rowSums(cont_table)
write.csv("contingencytable.csv", x = cont_table)

# How many rows in contingency table?
nrow(cont_table) #40781

# Comparing with Benford's theoretical distribution
KLD(obs_prop)

bf_comparison = data.frame(x = c(1:9),
           obs = obs_prop,
           benford = Benford(c(1:9)))

ggplot(bf_comparison,
       aes(x = x)) +
  theme_bw() +
  geom_line(aes(y = benford, color = "Benford"), size = 1.5) +
  geom_line(aes(y = obs, color = "Observed"), size = 1.5) +
  ylab("Probability") +
  xlab("Digit") +
  scale_x_continuous(breaks = seq(1, 9, by = 1)) +
  ggtitle("Observed vs. Benford Distribution")

# KLD of a uniform distribution
KLD(Uniform(c(1:9))) # 0.1912054

# Calculating KLD of all funding recipients 
kld_scores = apply(cont_prop, FUN = KLD, MARGIN = 1, Qx = obs_prop)

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

# Bootstrap analysis
boot_output <- read.csv(file = "bootstrap_output.csv", header = TRUE)

# Distribution of confidence intervals
boot_output %>%
  ggplot(aes(x = X0.975 - X0.25)) +
  geom_histogram(bins = 50) +
  xlab("CI Width (alpha = .05)") +
  ylab("Frequency") +
  theme_bw()

# Plotting relationship with n
boot_output %>%
  ggplot(aes(y = X0.975 - X0.25,
             x = log10(n))) + 
  geom_point(alpha = .05) + 
  stat_smooth(se = FALSE) +
  xlab("n transactions (Log10 scale)") +
  ylab("CI Width (alpha = .05)") +
  theme_bw()

