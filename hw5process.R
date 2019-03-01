d = read.table("digits.txt", sep = ",", header = TRUE)
colnames(d) = c("action_date", "digit", "recipient")
d$digit = as.numeric(d$digit)

d_filtered = d[d$digit %in% c(1:9),]
d_filtered = d_filtered[,c(2,3)]
counts = table(d_filtered)

write.csv(x = t(as.data.frame.matrix(counts)), "digit_counts.csv")