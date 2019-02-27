DATAFILE="/scratch/transaction.csv"
ACDATE=3 # Action date
TOTOBL=8 # Total obligation
PARREC=52 # Parent recipient ID

# For indices of column names
head ${DATAFILE} |
	cut --fields ${ACDATE},${TOTOBL},${PARREC} --delimiter , |
	uniq |
	python3 ./STA141c/hw5process.py |
	cat > test.txt
