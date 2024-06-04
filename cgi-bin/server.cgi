#!/usr/bin/env python3
import sys
import json
import csv

print("Content-Type: text/html")
print("Status: 200 OK")
print()
# Read data from standard input
args = sys.stdin.readlines()
print(args)
if args:
    data = json.loads(args[0])
data_file = open('data_file.csv', 'a')
csv_writer = csv.writer(data_file)
csv_writer.writerow(data.keys())
csv_writer.writerow(data.values())
data_file.close()