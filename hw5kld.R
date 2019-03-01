library(tidyverse)

# Reading in digit counts
digits = read.csv("digit_counts.csv", header = TRUE)

# Transposing dataframe from long to wide
digit_wide = digits %>% 
  select(-X) %>% 
  spread(key = "digit", value = "Freq")

cont_table = digit_wide[rowSums(digit_wide[,2:10]) > 100,]

obs_freq = colSums(cont_table[-1,2:10])

colnames(digits) = c("Agency", c(1:9))

BenFord <- function(x){
  log10(1 + (1/x))
}

sum(BenFord(1:9))

Uniform <- function(){
  (1 / 9)
}

Uniform()


