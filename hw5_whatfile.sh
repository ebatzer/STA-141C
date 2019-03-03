#!/bin/bash -l

# Use the staclass partition. Only applies if you are in STA141C
#SBATCH --partition staclass

# Give the job a name
#SBATCH --job-name findrows

DATAFILE="/scratch/transaction.csv"
ACDATE=3 # Action date
TOTOBL=8 # Total obligation
PARREC=52 # Parent recipient ID
NAICS=42
TRANSDESC=25
RECIPNAME=51


cut --fields ${ACDATE},${TOTOBL},${NAICS}, ${TRANSDESC}, ${RECIPNAME},${PARREC} --delimiter , ${DATAFILE} |
  awk '$6==145863895' |
  cat > foundrows.txt
