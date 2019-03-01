
digits = read.csv("digit_counts.csv", header = TRUE)
head(digits)

BenFord <- function(x){
  log10(1 + (1/x))
}

sum(BenFord(1:9))

Uniform <- function(){
  (1 / 9)
}

Uniform()


