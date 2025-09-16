# join values from idsdial.xlsx to pohyb_united_backUp.xlsx based on ids_2 column
# only values where label from main table is ST, C, STM

import pandas as pd
import re

output_file = (
    "E:/práce/firmy/obchid/ekonomické/analýza/Databaze/data/pohyb_united_with_dial.xlsx"
)
main_file = (
    "E:/práce/firmy/obchid/ekonomické/analýza/Databaze/data/pohyb_united_backUp.xlsx"
)
main_df = pd.read_excel(main_file, sheet_name="final")
main_df["ids_2"] = main_df["ids_2"].astype(str)
# print("Columns in main_df:", main_df.columns.tolist())


dial_file = "E:/práce/firmy/obchid/ekonomické/analýza/Databaze/data/idsdial.xlsx"
ids_dial_df = pd.read_excel(dial_file)
# cast both columns to string to avoid potential issues
ids_dial_df["ids"] = ids_dial_df["ids"].astype(str)


# add label ST_C to final table where ids_2 length is 6 and column is not equal values "ST", "C", "STM"
mask = (main_df["ids_2"].str.len() == 6) & (~main_df["label"].isin(["ST", "C", "STM"]))
main_df.loc[mask, "label"] = "ST_C"


id_map = ids_dial_df.set_index("ids")["label"].to_dict()

main_df["Type"] = main_df.apply(
    lambda row: id_map.get(
        row["ids_2"] if row["label"] in ["ST", "C", "STM", "ST_C"] else None, None
    ),
    axis=1,
)


main_df.to_excel(output_file, index=False)
print("Merging completed. Merged data saved to", output_file)
print("➡️ Počet nově označených ST_C:", mask.sum())
