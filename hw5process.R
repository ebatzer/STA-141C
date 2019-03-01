# Reading in table and setting column name
d = read.table("digits.txt", sep = ",", header = TRUE)
colnames(d) = c("action_date", "digit", "recipient")

# Removing values that are not 1:9
d$digit = as.character(d$digit)
d_filtered = d[d$digit %in% as.character(c(1:9)),]
d_filtered = d_filtered[,c(2,3)]

# Counting values in a table
counts = table(d_filtered)
write.csv(x = as.data.frame(counts), "digit_counts.csv")
