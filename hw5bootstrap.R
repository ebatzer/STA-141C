library(parallel)

cont_table = read.csv("contingencytable.csv", header = TRUE)
rownames(cont_table) = cont_table[,1]
cont_table = cont_table[-1,-1]
colnames(cont_table) = c(c(1:9))
obs_prop = colSums(cont_table) / sum(cont_table)

# KLD function
KLD = function(x, Qx = Benford(c(1:9))){
  
  pq = log(x / Qx)
  pq[pq %in% c(Inf, -Inf)] = 0
  k = sum(x * pq)
  
  return(k)
  
}                             

# Bootstrapping
KLDboot = function(cont_vec){
  n = sum(cont_vec)
  randomsamp = tabulate(sample(x = c(1:9), size = n, prob = cont_vec / n, replace = TRUE), nbins = 9)
  KLD_boot = KLD(randomsamp / n, Qx = obs_prop)
  
  return(KLD_boot)
}

boot_replicate = function(cont_vec, p = 1000){
  boots = replicate(p, KLDboot(cont_vec))
  output = data.frame(t(quantile(boots, c(.025, .50, .975))),
                      mean = mean(boots),
                      sd = sd(boots),
                      n = sum(cont_vec))
  return(output)
}

cont.list <- split(cont_table, seq(nrow(cont_table)))

output = parallel::mclapply(cont.list, boot_replicate, mc.cores = 2L)

outputdf = data.frame(matrix(unlist(output), ncol= length(output[[1]]), byrow = TRUE))
colnames(outputdf) = c("0.025", "0.5", "0.975", "mean", "sd", "n")

write.csv(x = outputdf, "bootstrap_output.csv")
