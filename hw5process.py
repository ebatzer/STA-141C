# Stream in file from bash
import csv
from sys import stdin, stdout
# import pandas

def benford(x):
    log10(1 + 1/x)

def main():
    reader = csv.reader(stdin)
    writer = csv.writer(stdout)

    for row in reader:
        try:
            row[1] = row[1][0]
        except IndexError:
            pass
        writer.writerow(row)

if __name__ == "__main__":
    output = main()

#recipient = 2
#obligation = 1

# Tabulating
#df = read_table(output, sep = ",")
#df.groupby([(obligation,recipient)])
