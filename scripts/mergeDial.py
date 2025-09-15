# join values from idsdial.xlsx to pohyb_united_backUp.xlsx based on ids_2 column
# only values where label from main table is ST, C, STM

import pandas as pd
import re


main_file = (
    "E:/práce/firmy/obchid/ekonomické/analýza/Databaze/data/pohyb_united_backUp.xlsx"
)
main_df = pd.read_excel(main_file, sheet_name="final")

# print("Columns in main_df:", main_df.columns.tolist())


dial_file = "E:/práce/firmy/obchid/ekonomické/analýza/Databaze/data/idsdial.xlsx"
ids_dial_df = pd.read_excel(dial_file)


ids_dial_df["ids"] = ids_dial_df["ids"].astype(str)

filtered_main_df = main_df[main_df["label"].isin(["ST", "C", "STM"])]
filtered_main_df["ids_2"] = filtered_main_df["ids_2"].astype(str)


merged_df = filtered_main_df.merge(
    ids_dial_df, how="left", left_on="ids_2", right_on="ids"
)

output_file = (
    "E:/práce/firmy/obchid/ekonomické/analýza/Databaze/data/pohyb_united_with_dial.xlsx"
)
merged_df.to_excel(output_file, index=False)
print("Merging completed. Merged data saved to", output_file)
