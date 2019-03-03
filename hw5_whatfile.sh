#!/bin/bash -l

# Use the staclass partition. Only applies if you are in STA141C
#SBATCH --partition staclass

# Give the job a name
#SBATCH --job-name findrows

DATAFILE="/scratch/transaction.csv"
grep -n --ignore-case 145863895 ${DATAFILE} > rowsubset.csv
