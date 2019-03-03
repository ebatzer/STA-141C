#!/bin/bash -l

# Use the staclass partition. Only applies if you are in STA141C
#SBATCH --partition staclass

# Give the job a name
#SBATCH --job-name findrows

DATAFILE="/scratch/transaction.csv"
ACDATE=3 # Action date
TOTOBL=8 # Total obligation
PARREC=52 # Parent recipient ID

cut --fields ${ACDATE},${TOTOBL},${PARREC} --delimiter , ${DATAFILE} |
  awk '$3=="145863895"' |
  cat > foundrows.txt
