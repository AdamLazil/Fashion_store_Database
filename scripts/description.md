![Python](https://img.shields.io/badge/python-3.10%2B-blue)
![pandas](https://img.shields.io/badge/pandas-2.2.0-green)
![Build Status](https://img.shields.io/badge/build-passing-brightgreen)

# 🧠 Brand & Product Matcher (Python, Fuzzy)

This script automatically **identifies the brand and type of a product** from a text string (name) in the product database. It uses **fuzzy matching** to find a match even when the name contains typos or is inaccurate.

## 🅿️ Problem to solve

the product in the database does not have a separately specified brand, size or type and everything is written in a text string

script is suitable for:

- 🛍️ E-shopa and retail data
- 📊 Product sales analyses
- 🧹 Automatic data cleaning in databases

### 🔍 Hlavní kroky

1. **Uploading data** from Excel

   - `finalTestPython.xlsx` – main table with products
   - `brandHelpPython.xlsx` – reference table with codes

2. **Text Normalization**
   - Removes accents, special characters and converts text to lowercase
   - E.g.
   ```
   "Pikolinos d.boty/38/655-0732C6/marfil/" → "Pikolinos d boty 38 655-0732C6 marfil"
   "C/L/tričko/313492/31715/" → "C L tričko 313492 31715"
   ```
3. **Fuzzy Tag Matching**

   - Uses `thefuzz` (formerly `fuzzywuzzy`) library to find the closest match
   - Penalizes short tags, favors longer ones or on the contrary
   - Assigns a tag if the score exceeds 80% (according set up)

4. **Fuzzy Product Matching**

   - Similar principle – searches for the closest product type
   - E.g. "shoes", "t-shirt", "coat", "skirt", etc.

5. **Adding a product code**

   - Each product from the reference table is assigned an internal code

6. **Save the file to excel**

## ⚙️ Used Libraries

```bash
pip install pandas thefuzz tqdm openpyxl
```

## 🧠 Preview

**Input** (finalTestPython.xlsx)

|  ids   | ..... |                     product_name                      | ...... | name_norm | control_type | ...... | Brand | product_norm | clothes_code |
| :----: | :---: | :---------------------------------------------------: | :----: | :-------: | :----------: | :----: | :---: | :----------: | :----------: |
|        | ..... |              tričko/105330/1026/40/so/\*              | ...... |           |              | ...... |       |              |              |
| 100073 | ..... | Carla Tencel trench / vel. 38 / STREETONE/BUNDA 10109 | ...... |           |              | ...... |       |    Bunda     |      10      |

**Reference table** (brandHelpPython.xlsx)

| ZNACKA  | PRODUKT | KOD   |
| :------ | :------ | :---- |
| la      | kalhoty | 37    |
| osshoes | top     | 32    |
| .....   | ....    | ....  |
| brenda  | boty    | 987   |
| fbsd    | ....    | ..... |
| cal     | tričko  | 11    |
| so      | bunda   | 10    |

**Output**

|  ids   | ..... |                     product_name                      | ...... |                     name_norm                     | control_type | ...... |   Brand    | product_norm | clothes_code |
| :----: | :---: | :---------------------------------------------------: | :----: | :-----------------------------------------------: | :----------: | :----: | :--------: | :----------: | :----------: |
|        | ..... |              tričko/105330/1026/40/so/\*              | ...... |            tričko 105330 1026 40 so \*            |    tričko    | ...... |     so     |    tricko    |      11      |
| 100073 | ..... | Carla Tencel trench / vel. 38 / STREETONE/BUNDA 10109 | ...... | Carla Tencel trench vel. 38 STREETONE BUNDA 10109 |    bunda     | ...... | Street One |    Bunda     |      10      |

## 🚀 Launch

```bash
python brandMergerCodeVer2.py
```

After successful completion:

```arduino
Hotovo ✅ Výsledky jsou uložené do finalTestPython.xlsx
```

## 🧑‍💻 Autor

**Bc. Adam Lízal**
📍 Data analysis & automation in Python
