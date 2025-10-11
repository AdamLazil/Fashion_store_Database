import pandas as pd
import re
from thefuzz import fuzz, process
from tqdm import tqdm
import unicodedata

# ---------- 1. Načtení dat ----------
df = pd.read_excel(
    "E:/práce/firmy/obchid/ekonomické/analýza/Databaze/data/brandMreged/finalTestPython.xlsx"
)  # sloupec: NAME
ref = pd.read_excel(
    "E:/práce/firmy/obchid/ekonomické/analýza/Databaze/data/brandMreged/brandHelpPython.xlsx"
)  # sloupce: ZNACKA, PRODUKT, KOD


# ---------- 2. Normalizace ----------
def normalize(text: str) -> str:
    if not isinstance(text, str):
        text = str(text)
    text = text.lower()
    text = unicodedata.normalize("NFKD", text)
    text = "".join([c for c in text if not unicodedata.combining(c)])
    text = re.sub(r"[^\w\s]", " ", text)  # odstraníme znaky .,/-
    text = re.sub(r"\s+", " ", text).strip()
    return text


tqdm.pandas(desc="Normalizing names")
df["NAME_NORM"] = df["nazev_produktu"].progress_apply(normalize)


# ---------- 3. Najít značku ----------
tqdm.pandas(desc="Normalizing brands")
ref["ZNACKA_NORM"] = ref["ZNACKA"].progress_apply(normalize)

brands = ref["ZNACKA_NORM"].dropna().unique().tolist()

"""
# ---------- testovací alias slovník ----------
test_text = "flu p boty oceano"
candidates = process.extract(
    test_text, brands, scorer=fuzz.partial_token_set_ratio, limit=2
)

print("test print:", test_text)
for cand, score in candidates:
    print(f"  Candidate: {cand:20s}, Score: {score}")
"""


# function for finding brand if empty
def find_brand_if_empty(row):
    if pd.notna(row["brand"]) and row["brand"].strip() != "":
        return row["brand"]
    text = row["NAME_NORM"]

    candidates = process.extract(
        text, brands, scorer=fuzz.partial_token_set_ratio, limit=2
    )

    best_match = None
    best_score = 0

    for candidate, score in candidates:
        if len(candidate) <= 2:
            score -= 1  # penalizuj krátké značky
        if len(candidate) >= 3:
            score += 5  # přidej body za delší značky
        if score > best_score:
            best_score = score
            best_match = candidate

    if best_score > 80:
        return best_match
    return None


df["BRAND"] = df.progress_apply(find_brand_if_empty, axis=1)


tqdm.pandas(desc="Matching brands")
# df["BRAND"] = df["NAME_NORM"].apply(find_brand_if_empty)
df["BRAND"] = df.progress_apply(find_brand_if_empty, axis=1)


# ---------- 4. Najít produkt ----------
tqdm.pandas(desc="Normalizing products")
ref["PRODUKT_NORM"] = ref["PRODUKT"].progress_apply(normalize)

products = ref["PRODUKT_NORM"].dropna().unique().tolist()


def find_product(text):
    match, score = process.extractOne(text, products, scorer=fuzz.partial_ratio)
    if score > 60:
        return match
    return None


tqdm.pandas(desc="Matching products")
df["PRODUCT"] = df["NAME_NORM"].apply(find_product)

# ---------- 5. Přidat kód produktu ----------
ref_unique = ref.drop_duplicates(subset=["PRODUKT"])
df = df.merge(
    ref_unique[["PRODUKT_NORM", "KOD"]],
    how="left",
    left_on="PRODUCT",
    right_on="PRODUKT_NORM",
)

# ---------- 6. Výsledek ----------
# print(df[["NAME", "BRAND", "PRODUCT", "KOD"]])

# print("numbers of rows:", len(df))


df.to_excel(
    "E:/práce/firmy/obchid/ekonomické/analýza/Databaze/data/brandMreged/finalTestPython.xlsx",
    index=False,
    engine="openpyxl",
)
""""
df.to_excel(
    "E:/práce/firmy/obchid/ekonomické/analýza/Databaze/data/brandMreged/TEST2CODEPython.xlsx",
    index=False,
)
"""
print("Hotovo ✅ Výsledky jsou uložené do TEST2CODEPython.xlsx")
