# I would like to pick the distinct values from column "Name" and save to new column in the same document


import pandas as pd

input_file = (
    "E:/práce/firmy/obchid/ekonomické/analýza/Databaze/data/Cleaner/nameToclean.xlsx"
)
# output_file = "E:/práce/firmy/obchid/ekonomické/analýza/FashionStoreDatabse/dataSets/cleanData/CleanedIDs.xlsx"


df = pd.read_excel(input_file)

col = "name"

filtered_name = df[col].astype(str)
# filtered_ids = filtered_ids[filtered_ids.str.len() == 6]
# trim the list and take first value for "/" and save to new column
filtered_name = filtered_name.str.split("/").str[0]
filtered_name = filtered_name.str.split(r"[' ',.-]").str[0]
filtered_name = filtered_name.str.strip()


distinct_name = sorted(filtered_name.unique())


pd.Series(distinct_name).to_excel(
    input_file,
    index=False,
)

print("Cleaning completed. Cleaned name saved to", input_file)
