DATAFILE="/scratch/transaction.csv"
ACDATE=3 # Action date
TOTOBL=8 # Total obligation
PARREC=52 # Parent recipient ID

module load python3

# For indices of column names
cut --fields ${ACDATE},${TOTOBL},${PARREC} --delimiter , ${DATAFILE}|
uniq |
awk '${TOTOBL}>0' |
python3 ./STA-141C/hw5count.py |
cat > digits.txt

Rscript ./STA-141C/hw5process.R
