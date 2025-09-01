# Covid Data Cleaning and Exploration Project

[![SQL](https://img.shields.io/badge/SQL-Skills-blue)](https://www.sql.org/)  
[![Python](https://img.shields.io/badge/Python-EDA-green)](https://www.python.org/)  
[![Data Analysis](https://img.shields.io/badge/Data-Analysis-orange)](https://www.python.org/)

---

## Project Overview

**Project Title:** Covid Data Cleaning and Exploration  

This project demonstrates SQL and Python skills for data cleaning, exploration, and analysis on Covid-19 datasets (`CovidDeaths` & `CovidVaccinations`). It involves database setup, data cleaning, exploratory data analysis (EDA), and deriving insights using SQL queries and Python scripts. SQL was primarily used for structured data operations, while Python was used to perform EDA and data summarization.

---

## Objectives

<details>
<summary>Click to expand Objectives</summary>

- **Database Setup (SQL):** Create and populate databases with Covid and related data.  
- **Data Cleaning (SQL & Python):** Standardize formats, remove duplicates, handle nulls, and convert categorical fields for consistency.  
- **Exploratory Data Analysis (EDA):** Examine total cases, deaths, population impact, and vaccination coverage.  
- **Business Insights (SQL & Python):** Identify trends, high-risk regions, and measure vaccination progress for decision-making.  

</details>

---

## Project Structure

<details>
<summary>Click to expand Project Structure</summary>

### 1. Data Cleaning

- **Standardizing Dates & Numerical Fields (SQL):** Converted date and numeric fields to consistent formats.  
- **Address Parsing (SQL):** Split `PropertyAddress` and `OwnerAddress` into separate columns for street, city, and state.  
- **Categorical Conversion (SQL):** Updated fields like `SoldAsVacant` from `Y/N` to `YES/NO`.  
- **Duplicate Removal (SQL):** Used CTEs with `ROW_NUMBER()` to remove duplicate records.  
- **Data Validation & Cleaning (Python):** Checked for nulls, inconsistent values, and outliers after SQL extraction.

### 2. Exploratory Data Analysis (EDA)

- **SQL Queries:**  
  - Total cases vs deaths  
  - Infection percentage vs population  
  - Countries/continents with highest deaths  
  - Rolling vaccination counts  

- **Python Analysis:**  
  - Summarized key metrics using Pandas  
  - Checked distributions of cases, deaths, and vaccinations  
  - Aggregated data by country and date for insights  

### 3. Views & Reporting (SQL)

- **PercentPeopleVaccinated:** Rolling vaccination percentages per location.  
- **CountryDeaths:** Maximum death counts per country.  
- **ContinentDeaths:** Maximum death counts per continent.  

### 4. Key Skills Demonstrated

- SQL: Joins, CTEs, Window Functions, Aggregates, Views  
- Python: Pandas, NumPy, EDA, Data Cleaning  
- Data Cleaning, Type Casting, and Duplicate Removal  
- Aggregation and ranking  
- Business insight derivation  

</details>

---

## Findings

<details>
<summary>Click to expand Findings</summary>

- **Population Impact:** Some countries had a significantly higher percentage of infected individuals relative to their population.  
- **Mortality Insights:** Identified countries and continents with the highest death counts.  
- **Vaccination Progress:** Tracked rolling vaccination numbers to measure population coverage.  
- **Data Quality Improvements:** Cleaned inconsistent, null, and duplicate entries for reliable analysis.  

</details>

---

## Conclusion

This project highlights the combination of SQL and Python for data analysis. SQL handled structured data cleaning and aggregation, while Python was used for exploratory analysis and data summarization. The insights provide a clear understanding of Covid-19 trends and vaccination progress, suitable for guiding health policies or business decisions.

---

## Author

**Anal Patil**  

Portfolio project showcasing SQL & Python EDA skills for data analyst roles. Questions, feedback, or collaboration requests are welcome.
