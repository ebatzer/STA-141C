#!/bin/bash -l

# Use the staclass partition. Only applies if you are in STA141C
#SBATCH --partition staclass

# Give the job a name
#SBATCH --job-name hw4

# Setting DATAFILE
unzip -p ../../group/staclassgrp/transaction.zip | cat > transaction_large

# For indices of column names
head -n 1 transaction_large | tr -s "," "\n" | nl > column_index.txt

# For length of largest line
wc -L transaction_large > maxchars.txt

# For number of lines where bicycle appears
# -i specifies case insensitive
grep -n -i bicycle transaction_large > bicycle.csv

# Finding the list of unique funding agency ID's
# First remove the first row (no column IDs)
tail -n+2 transaction_large | cut -f 18 -d , | sort | uniq > funding_agency_set.txt

# Find the description and amount
cut -f 8,25 -d , transaction_large | sort -k1 -r -n | head -n 3 > largest.csv
