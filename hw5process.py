# Stream in file from bash
import csv
from sys import stdin, stdout
import numpy

def benford(x):
    log10(1 + 1/x)

def main():
    reader = csv.reader(stdin)
    writer = csv.writer(stdout)

    for row in reader:
        try:
            row[-1] = row[-1][0]
        except IndexError:
            pass
        writer.writerow(row)


if __name__ == "__main__":
    main()

# df['first_digit'] = df['TOTAL OBLIGATION'].astype(str).str[0]

# df.groupby(["PARENT RECIPIENT ID", "first_digit"]).count()
