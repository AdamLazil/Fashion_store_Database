import pandas as pd
from tqdm import tqdm

# aktivace progress baru pro apply
tqdm.pandas()

# načtení hlavní tabulky (už po fuzzy přiřazení)
df = pd.read_excel(
    "E:/práce/firmy/obchid/ekonomické/analýza/Databaze/data/brandMreged/finalTestPython.xlsx"
)

# alias slovník: hlavní značka : [varianty]
alias_dict = {
    "Dorking": ["dork", "dk", "dkk", "DK", "dkd", "dor", "dboty"],
    "Olivia Shoes": ["olivia", "os", "oli", "alivia", "osshoes", "ol"],
    "Ragman": ["rag", "rgm", "ragmp", "rg"],
    "Dakidaya": ["dk", "dak", "dakid", "daya"],
    "Elwesssi": ["elw", "elwessi", "elwess"],
    "La Pinta": ["lp", "lap", "lapint", "lapinta", "lpd"],
    "Guero": ["guer", "gueroo", "guerooo", "g.u.e.r.o"],
    "Callaghan": [
        "call",
        "callaghan",
        "calaghan",
        "callg",
        "calgh",
        "clgd",
        "clh",
        "clgp",
    ],
    "Bianca": ["bia", "bi", "bla", "binca", "bisnca"],
    "La Cotoniere": ["lc", "la", "l", "coton", "cotoniere", "cotto", "coto", "cot"],
    "Wonders": ["wns", "wds", "wond", "won"],
    "Fluchos": ["fluc", "flchs", "fch.", "flu", "flup"],
    "Iberius": [
        "ib",
        "ibb",
    ],
    "Karyoka": ["kary", "karyok", "kard"],
    "Kremara": ["krad"],
    "Paz torras": ["paz", "paztorras"],
    "Bigrey": ["bg"],
    "NÜ": ["nú", "n u", "nu"],
    "Hattric": ["haltric", "hattrick", "hat", "hatt", "hattrik", "hattp"],
    "Co woman": ["cowoman", "cow"],
    "Calamar": ["calam", "cal"],
    "IT": ["itshoes", "itsh", "it shoes"],
    "Dí": ["di"],
    "Brenda Zaro": ["brenda", "bz", "bzd", "brendazaro"],
    "Mago": ["ma", "magod", "m", "mg", "mgd"],
    "Membur": ["menbur"],
    "Pikolinos": ["pik" "piko", "pikd", "pikp"],
    "Yachting": ["yt", "ytp"],
    # ... můžeš přidat další
}


def normalize_brand(row):
    # pokud už je brand vyplněný a konsistentní, nech ho být
    if pd.notna(row["BRAND2"]):
        brand_value = str(row["BRAND2"]).strip().lower()
        for main_brand, aliases in alias_dict.items():
            if brand_value == main_brand.lower():
                return main_brand
            if brand_value in [a.lower() for a in aliases]:
                return main_brand
    # jinak zkus najít podle názvu produktu
    name = str(row["NAME_NORM"]).lower()
    for main_brand, aliases in alias_dict.items():
        for alias in aliases:
            if alias.lower() in name:
                return main_brand
    return row["BRAND2"]  # pokud nic nenašlo, nech původní hodnotu


# aplikace normalizace
df["BRAND2"] = df.progress_apply(normalize_brand, axis=1)

# uložení výsledku
df.to_excel(
    "E:/práce/firmy/obchid/ekonomické/analýza/Databaze/data/brandMreged/finalTestPython.xlsx",
    index=False,
    engine="openpyxl",
)
print("Normalizace aliasů dokončena.")
