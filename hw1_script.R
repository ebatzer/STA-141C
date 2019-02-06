
# 1 - Computation

#Compute the median annual spending for each agency.

library(tidyverse); library(data.table)

# Establish file path of zipped file and list of file names
zip_file_path = "./data/awards.zip"
files = unzip(zip_file_path, list = TRUE)
fnames = files$Name

# Remove the "0.csv" file
fnames = fnames[-1]

# Function to tabulate spending per year of each organization
sumSpending = function(fnames){
  
  # Initializing output list for spending and processing time
  output <- list()
  processsummary <- list()
  counter = 1
  
  # For each unique dataset
  for(fname in fnames){
    
    # Read in the unzipped file through data.table
    # Unlike the unz() approach, fread can run shell commands
    d = fread(paste('unzip -p ', zip_file_path, fname), 
              blank.lines.skip = TRUE, nThread = 4)
    
    #f = unz(zip_file_path, fname)
    #d = read.csv(f)
    
    # Converting date from factor format
    d$date = as.Date(d$period_of_performance_start_date)
    
    # Creating year column to calculate spending per annum
    d$year = year(d$date)
    
    # Sum spending per year
    total =  tapply(d$total_obligation, INDEX = d$year, FUN = sum)
    
    # Store in output list
    output[[counter]] = data.frame(agency = unique(d$funding_agency_name),
                                   total,
                                   year = names(total))
    
    # Store file information in output list
    processsummary[[counter]] = data.frame(agency = unique(d$funding_agency_name),
                                           filename = fname,
                                           nrows = nrow(d))
    
    counter = counter + 1
  }
  
  return(list(medians = do.call(rbind, output),
              process = do.call(rbind, processsummary)))
}

output = sumSpending(fnames)

# 1. Which agencies have the highest median annual spending?

median_df = output[[1]] %>%
  group_by(agency) %>%
  summarise(mspend = median(total))

median_df = na.omit(median_df)

head(median_df %>% arrange(desc(mspend)))

summary(median_df)

median_df[median_df$mspend == min(median_df$mspend),]

# 2. Qualitatively describe the distribution of median annual spending.

med_plot = median_df %>% 
  ggplot(aes(x = mspend)) +
  geom_histogram(fill = "lightblue", color = "black") +
  ggtitle("Median Spending Distribution")

med_plot

# 3. Qualitatively describe the distribution of the logarithm of the median annual spending.
# Plot the histogram.

logmed_plot = median_df %>% 
  ggplot(aes(x = log(mspend))) +
  geom_histogram(fill = "lightblue", color = "black") +
  ggtitle("Log Median Spending Distribution")

logmed_plot
# Plotting both together for writeup

twoplots = gridExtra::grid.arrange(med_plot, logmed_plot, nrow = 1)
twoplots

ggsave(plot = twoplots, "./figures/hw1plot1.jpeg", height = 5, width = 10)

# 4. Is there a clear separation between agencies that spend a large amount of money, and
# those which spend less money?
  
# 1. Qualitatively describe the distribution of the file sizes.

spendfiles = unzip(zip_file_path, list = TRUE)

filelength = spendfiles %>% ggplot(aes(x = Length)) +
  geom_histogram(fill = "lightblue", color = "black") +
  ggtitle("Distribution of File Length")  

filelength

ggsave(plot = filelength, "./figures/hw1plot2.jpeg", height = 4, width = 5)

# 2. How does the size of the file relate to the number of rows in that file?
  
rowslength = inner_join(spendfiles, output[[2]], 
                        by = c("Name" = "filename")) %>%
  ggplot(aes(x = Length,
             y = nrows)) +
  geom_point(size = 4, fill = "lightblue", color = "black", pch = 21) +
  stat_smooth(se = FALSE, method = "lm")

ggsave(plot = rowslength, "./figures/hw1plot3.jpeg", height = 4, width = 5)

# 3. How long does it take to process all the data?
  
system.time(sumSpending(fnames))

# 4. Do you think this same approach you took work for 10 times as many files? What if
# each file was 10 times larger?
  
# 5. How do you imagine you could make it faster?
  