<p align="center">
  <img src="https://img.shields.io/badge/Python-3.10+-blue.svg?style=for-the-badge&logo=python&logoColor=white"/>
  <img src="https://img.shields.io/badge/PostgreSQL-Data%20Storage-336791?style=for-the-badge&logo=postgresql&logoColor=white"/>
  <img src="https://img.shields.io/badge/Pandas-Data%20Cleaning-150458?style=for-the-badge&logo=pandas&logoColor=white"/>
  <img src="https://img.shields.io/badge/Power%20BI-Reporting-F2C811?style=for-the-badge&logo=powerbi&logoColor=black"/>
  <img src="https://img.shields.io/badge/Status-In%20Progress-orange?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge"/>
</p>

# 🧠 Data integretion & cleaning project - retail analytics

## 📜 Overview

This project focuses on unifying and cleaning data from various sources used by a women's clothing retailer.
The goal was to convert fragmented and incompatible data from formats such as **Excel, Word, emails, and legacy databases** into a single SQL database that enables more accurate and efficient data analysis and reporting.

## 📌 Project goals

- ↗️ **Data integration** from various formats (Excel sheets, word, emails, old Access databases, hand written notes)
- 🧹 **Data cleaning and consolidation** — removing duplicates, unifying names, normalizing text and data formats.
- 🧠 **Filling in missing data using Python** — fuzzy matching of brands, products, and codes.
- 📈**Preparing data for analytical purposes** — creating clear SQL tables and Power BI dashboards.

## 🔍 Tools & Technologies

| Area              | Technology                                                      |
| :---------------- | :-------------------------------------------------------------- |
| ETL/Data Cleaning | Python, Power Query                                             |
| Database          | PostgreSQL/ SQL                                                 |
| Visualization     | Power BI                                                        |
| Sources           | Excel (.xlsx), Word(.docx), Access(.accdb), CSV, e-mail exports |

## ⚙️ Proces overview

1 **Data collection**<br>
&nbsp;&nbsp; -> creation of a data warehouse for the necessary data<br>
2 - **Data check** (first filtering)<br>
&nbsp;&nbsp;-> data integrity check and sorting into usable and expendable<br>
3 - **Data transform**<br>
&nbsp;&nbsp;-> unification of data into the same format with Power Query and Python<br>
4 - **Cleaning the data**(second filtering)<br>
&nbsp;&nbsp;-> removal of duplicates and invalid data<br>
5 - **Data addition and transform**<br>
&nbsp;&nbsp;-> creating new columns and auxiliary tables<br>
6 - **Database**<br>
&nbsp;&nbsp;-> creating a database structure<br>
7 - **Data transfer**<br>
&nbsp;&nbsp;-> import data to database<br>
8 - **Analyze**<br>
&nbsp;&nbsp;-> creating a query based on selected questions<br>
9 - **Dashboard and report**<br>
&nbsp;&nbsp;-> Power Bi dashboard and

```mermaid
  graph TD;
    A-->B[.xlsx];
    A-->B[.csv];
    B[Data]-->C;

```

## 📁 Project Structure

```pgsql

E:.
├───data
│   ├───filtered
│   ├───processed
│   │   └───mergedCleanToSql
│   └───raw
├───outputs
│   ├───dashboard
│   └───report
├───scripts
│   ├───help
│   └───main
└───sql
    ├───analyze
    └───tables

```

## 🧾 Output

The result of the project is a clean and structured SQL database that allows for:

- fast trend analysis over time,

- more efficient inventory management,

- better reports for management,

- easier data updates.

## 🏁 Status

✅ Data integration completed <br>
✅ Data cleaning and enrichment done <br>
🚧 Power BI dashboard (in progress)<br>
📜 Report (in progress)

## Preview database

![Database - preview](screenShots/database.png)
