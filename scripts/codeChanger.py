# take value from ids_2 when brand is equal brand 2
import pandas as pd
import re
from tqdm import tqdm

df = pd.read_excel(
    "E:/práce/firmy/obchid/ekonomické/analýza/Databaze/data/brandMreged/finalTestPythonBrandCode.xlsx"
)

mask = (
    ((df["brand"] == "ST") & (df["BRAND2"] == "Street One"))
    | ((df["brand"] == "ST_C") & (df["BRAND2"] == "Street/Cecil"))
    | ((df["brand"] == "C") & (df["BRAND2"] == "Cecil"))
    | ((df["brand"] == "ST MEN") & (df["BRAND2"] == "Street One Men"))
)

tqdm.pandas(desc="Filling KOD for ST")
df.loc[mask, "KOD"] = df.loc[mask, "ids_2"]

df.to_excel(
    "E:/práce/firmy/obchid/ekonomické/analýza/Databaze/data/brandMreged/finalTestPythonBrandCode.xlsx",
    index=False,
    engine="openpyxl",
)
print("Filling completed. Merged data saved to finalTestPythonBrandCode.xlsx")
print("➡️ Počet nově označených ST_C:", mask.sum())
