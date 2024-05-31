import sys
import csv
import os
from os import walk
import fnmatch
import ast

expt_name = 'Color_motion_experiment/'
myPath = './data/'

# Append the path variable to existing search path
sys.path.append(myPath)
# Get the file information in the directory
file_list = []
ignore_list = ['pilot']
for root, dirs, files in os.walk(myPath):
    if 'pilot' in dirs:
        dirs[:]=[]
    for filename in files:
        if fnmatch.fnmatch(filename.lower(), "*txt"):
            file_list.append(os.path.join(root, filename))
data = []
for file in file_list:
    print(file)
    with open(file) as f:
        data = ast.literal_eval(f.read())

    toCSV = data
    keys = toCSV[0].keys()
    with open(file[:-4]+'.csv','wb')  as output_file:
        dict_writer = csv.DictWriter(output_file, keys)
        dict_writer.writeheader()
        dict_writer.writerows(toCSV)