# Covid Data Cleaning and Exploration Project

[![SQL](https://img.shields.io/badge/SQL-Skills-blue)](https://www.sql.org/)  
[![Python](https://img.shields.io/badge/Python-EDA-green)](https://www.python.org/)

---

## Project Overview
A SQL-based project demonstrating data cleaning, exploration, and analysis on Covid-19 datasets (`CovidDeaths` & `CovidVaccinations`). The goal is to clean data, perform EDA, and derive actionable insights.

---

## Objectives
- **Database Setup**: Create and populate tables.  
- **Data Cleaning**: Handle nulls, duplicates, and standardize formats.  
- **EDA**: Analyze cases, deaths, population impact, and vaccination coverage.  
- **Insights**: Identify high-risk regions and track vaccination trends.

---

## Project Structure

<details>
<summary><strong>1. Data Cleaning</strong></summary>

```sql
-- Standardize Dates
UPDATE NashvilleHousing
SET SaleDate = CAST(SaleDate AS DATE);

-- Standardize Numerical Fields
UPDATE NashvilleHousing
SET Acreage = CAST(Acreage AS DECIMAL(5,2));

-- Split Addresses
UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING_INDEX(PropertyAddress, ',', 1),
    PropertySplitCity = TRIM(SUBSTRING_INDEX(PropertyAddress, ',', -1));

-- Convert Categorical Fields
UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant='Y' THEN 'YES'
                        WHEN SoldAsVacant='N' THEN 'NO'
                   END;

-- Remove Duplicates
WITH RowNumCTE AS (
    SELECT id, ROW_NUMBER() OVER(PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference ORDER BY ParcelID) AS row_num
    FROM NashvilleHousing
)
DELETE nh
FROM NashvilleHousing nh
JOIN RowNumCTE cte ON nh.id = cte.id
WHERE cte.row_num > 1;
