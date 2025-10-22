# script should run throgh the excel column and clean the labels and exclude numbers and duplicates
# after that it should make a new column with distinct cleaned labels
# and save the file as new excel file

import pandas as pd
import re

input_file = "E:/práce/firmy/obchid/ekonomické/analýza/FashionStoreDatabse/dataSets/dataToClean/DistinctLabelsToClean.xlsx"

output_file = "E:/práce/firmy/obchid/ekonomické/analýza/FashionStoreDatabse/dataSets/cleanData/CleanedLabels.xlsx"

df = pd.read_excel(input_file)

col = "Labels"

df_exploded = df[col].astype(str).str.split(r"[/\,\.]").explode().str.strip().dropna()

df_exploded = df_exploded[~df_exploded.str.match(r"^\d+$")]

unique_names = sorted(df_exploded.unique())

pd.Series(unique_names).to_excel(output_file, index=False, header=["CleanedLabels"])

print("Cleaning completed. Cleaned labels saved to", output_file)
