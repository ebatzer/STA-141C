# Stream in file from bash
import csv
import pandas as pd

def benford(x):
    log10(1 + 1/x)

recipient = 2
obligation = 1

# Tabulating
df = pd.read_csv('digits.txt', sep=",", header=1)
df.columns = ["date", "digit", "recipient"]
digit_table = df[["digit", "recipient"]].groupby(["digit","recipient"]).count()
digit_table.to_csv("digit_table.csv")
