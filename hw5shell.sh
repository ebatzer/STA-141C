DATAFILE="/scratch/transaction.csv"
ACDATE=3 # Action date
TOTOBL=8 # Total obligation
PARREC=52 # Parent recipient ID

load module python3

# For indices of column names
# cut --fields ${ACDATE},${TOTOBL},${PARREC} --delimiter , ${DATAFILE}|
#	uniq |
#	python3 ./STA-141C/hw5count.py |
#	cat > digits.txt

python3 ./STA-141C/hw5process.py
