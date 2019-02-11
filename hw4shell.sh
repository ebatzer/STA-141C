#!/bin/bash -l

# Use the staclass partition. Only applies if you are in STA141C
SBATCH --partition = staclass

# Give the job a name
SBATCH --job-name = bashtest

# Setting DATAFILE
unzip -p ../../group/staclassgrp/transaction.zip | cat > transaction_large

# For length of largest line
wc -L transaction_large > maxchars.txt

# For number of lines where bicycle appears
grep -n -i bicycle transaction_large > bicycle.csv

# Finding the list of unique funding agency ID's
cut -f 18 -d , transaction_large | sort | uniq > funding_agency_set.txt
