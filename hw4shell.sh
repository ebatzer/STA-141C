#!/bin/bash -l

# Use the staclass partition. Only applies if you are in STA141C
#SBATCH --partition staclass

# Give the job a name
#SBATCH --job-name hwsub

# Global Variables
DATAFILE = "../../scratch/transaction.zip"
AMT = 8 # Funding amount
FUNDID = 18 # Funding agency ID
DESC = 25 # Payment description
STATEID = 36 # Recipient state ID
FUNDDESC = 54 # Funding agency description (text)

# For indices of column names
unzip -p ${DATAFILE} |
	head --lines 1 |
	tr --squeeze-repeats "," "\n" |
	nl > column_index.txt

# For length of largest line
unzip -p ${DATAFILE} |
	wc --max-line-length > maxchars.txt

# For number of lines where bicycle appears
unzip -p ${DATAFILE} |
	grep -n --ignore-case bicycle > bicycle.csv

# Finding the list of unique funding agency ID's and funding agency descriptions
# First remove the first row (no column IDs)
unzip -p ${DATAFILE} |
	tail --lines +2 |
	cut --fields ${FUNDID},${FUNDDESC} --delimiter , |
	sort |
	uniq > funding_agency_set.txt

# Find the description and amount
unzip -p ${DATAFILE} |
	cut --fields ${AMT},${DESC} -d , |
	sort -k1 --reverse --numeric-sort |
	head -n 3 > largest.csv

# Finding where border funding goes
# First, cut down dataset to relevant columns
# In this case: obligation, description, and recipient state ID
unzip -p ${DATAFILE} |
	cut --fields ${AMT},${DESC},${STATEID} --delimiter , |

# Then, search for the term "border" in the funding description (case insensitive)
	grep -i border |

	# Then, using awk, delimit fields by "," and sum over unique values of the array
	# Unique values of the third column have summed values in the first column
	# Source from https://stackoverflow.com/questions/10286522/group-by-sum-from-shell
	awk -F '[,]' '{
	    arr[$3]+=$1
	   }
	   END {
	     for (key in arr) printf("%s\t%s\n", key, arr[key])
	   }'|

	# Sort over the first column and output a new text document
	sort -k1,1 > borderfunding.txt
