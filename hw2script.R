################################################################################
# HW 1
# Evan Batzer
################################################################################

library(tm); library(tidytext)

textprocess = function(fname, 
                       zipfile = zip_file_path,
                       n = 25){
  
  # Setting file location and unzipping
  rawcsv = unz(zipfile, fname)
  zipfile = zip_file_path
  
  # Reading csv
  d = read.csv(rawcsv, stringsAsFactors = FALSE)
  strings = d$description
  
  # Encode strings in UTF8 if not valid
  strings = ifelse(validUTF8(strings), strings, enc2utf8(strings))
  
  # Set to lowercase
  strings = tolower(strings)
  
  # Remove punctuation
  strings = removePunctuation(strings)
  
  # Stem strings
  strings = stemDocument(strings)
  
  # Remove stopwords
  strings = removeWords(strings, stopwords("en"))
  
  # Convert to tidy document term matrix
  dt = DocumentTermMatrix(VCorpus(VectorSource(strings)))
  tidydf = tidy(dt)
  
  # Sum counts of words in each document and attach obligation
  costdf = merge(aggregate(tidydf$count, by = list(document = tidydf$document), FUN = sum),
                 data.frame(document = c(1:nrow(d)), d$total_obligation))
  
  colnames(costdf) = c("document", "wordcount", "total_obligation")
  
  # Calculate wordweight and merge with term dataframe
  costdf$wordweight = costdf$total_obligation / costdf$wordcount
  tidydf = merge(tidydf, costdf, by = "document")
  
  # Sum list of most weighted terms
  outputdf = aggregate(tidydf$wordweight * tidydf$wordcount, by = list(term = tidydf$term), FUN = sum)
  colnames(outputdf) = c("word", "weight")
  
  # Order by weight and return the n most common terms
  outputdf = outputdf[order(outputdf$weight, decreasing = TRUE),]
  return(outputdf[1:n,])
}

zip_file_path = "./data/awards.zip"
files = unzip(zip_file_path, list = TRUE)
fnames = files$Name

# Remove files less than 1MB or greater than 50MB
fnames = files$Name[files$Length > 1048576 & 
                      files$Length < (50 * 1048576)]

zip_file_path = "./data/awards.zip"

# Tablulate spending and term frequencies for each file

lapply(fnames[1], textprocess)

o = termweights(fnames[1])

################################################################################
# Parallel Code

library(parallel)

# Creating cluster
cls = makeCluster(4L, type = "PSOCK")

# Checking cluster environment
clusterCall(cls, ls, envir = globalenv())

# Sending necessary info to cluster
clusterExport(cls, "termweights")
clusterExport(cls, "textprocess")
clusterExport(cls, "zip_file_path")
clusterEvalQ(cls, library("tm"))
clusterEvalQ(cls, library("tidytext"))

# Timing functions
system.time(parallel::parLapply(cl = cls, X = fnames, fun = textprocess))
system.time(parallel::clusterApplyLB(cl = cls, x = fnames, fun = textprocess))
system.time(lapply(fnames, textprocess))