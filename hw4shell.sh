#!/bin/bash -l

# Use the staclass partition. Only applies if you are in STA141C
#SBATCH --partition staclass

# Give the job a name
#SBATCH --job-name hwsub

# Unzipping transaction file
unzip -p ../../scratch/transaction.zip > transaction_large

# For indices of column names
head -n 1 transaction_large | tr -s "," "\n" | nl > column_index.txt

# For length of largest line
wc -L transaction_large > maxchars.txt

# For number of lines where bicycle appears
# -i specifies case insels nsitive
grep -n -i bicycle transaction_large > bicycle.csv

# Finding the list of unique funding agency ID's
# First remove the first row (no column IDs)
tail -n +2 transaction_large | cut -f 18,54 -d , | sort | uniq > funding_agency_set.txt

# Find the description and amount
cut -f 8,25 -d , transaction_large | sort -k1 -r -n | head -n 3 > largest.csv


# Finding where border funding goes
# First, cut down dataset to relevant columns
# In this case: obligation, description, and recipient state ID
cut -f 8,25,36 -d , transaction_large |

# Then, search for the term "border" in the funding description (case insensitive)
grep -i border |

# Then, using awk, delimit fields by "," and sum over unique values of the array
# Source from https://stackoverflow.com/questions/10286522/group-by-sum-from-shell
awk -F '[,]' '{
    arr[$3]+=$1
   }
   END {
     for (key in arr) printf("%s\t%s\n", key, arr[key])
   }'|

# Sort over the first column and output a new text document
sort -k1,1 > borderfunding.txt
