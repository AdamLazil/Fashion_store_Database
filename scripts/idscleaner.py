# i need trimm first two numbers from ids number and make distinct ids
# and save it to new excel file

import pandas as pd

input_file = "E:/práce/firmy/obchid/ekonomické/analýza/FashionStoreDatabse/dataSets/dataToClean/DistinctLabelsToClean.xlsx"
output_file = "E:/práce/firmy/obchid/ekonomické/analýza/FashionStoreDatabse/dataSets/cleanData/CleanedIDs.xlsx"


df = pd.read_excel(input_file)

col = "ids"

filtered_ids = df[col].astype(str)
filtered_ids = filtered_ids[filtered_ids.str.len() == 6]

def_cleaned_ids = filtered_ids.str[:2]

distinct_ids = sorted(def_cleaned_ids.unique())

pd.Series(distinct_ids).to_excel(output_file, index=False, header=["CleanedIDs"])

print("Cleaning completed. Cleaned IDs saved to", output_file)
