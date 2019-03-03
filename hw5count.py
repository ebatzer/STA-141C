# Stream in file from bash
import csv
from sys import stdin, stdout

def main():
    reader = csv.reader(stdin)
    writer = csv.writer(stdout)

    for row in reader:
        try:
            if row[6] == 145863895:
                writer.writerow(row)
        except IndexError:
            pass


if __name__ == "__main__":
    main()
