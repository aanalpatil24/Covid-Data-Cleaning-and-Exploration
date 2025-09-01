/*
Covid Data Cleaning
*/

SELECT *
	FROM NashvilleHousing;

--------------------------------------------------

-- Standardize Date Format

SELECT SaleDate, 
       CAST(SaleDate AS DATE)
	FROM NashvilleHousing;

-- Try updating in place
UPDATE NashvilleHousing
	SET SaleDate = CAST(SaleDate AS DATE);

-- If it doesn't update properly, create a new column
ALTER TABLE NashvilleHousing
	ADD COLUMN SaleDateConverted DATE;

UPDATE NashvilleHousing
	SET SaleDateConverted = CAST(SaleDate AS DATE);

-- Initially spelled the column name wrong (SaleDataConverted), so remove that
ALTER TABLE NashvilleHousing
	DROP COLUMN SaleDataConverted;

--------------------------------------------------

-- Standardize Acreage

SELECT Acreage,
	   CAST(Acreage AS DECIMAL(5,2))
	FROM NashvilleHousing;

-- Try updating in place
UPDATE NashvilleHousing
	SET Acreage = CAST(Acreage AS DECIMAL(5,2));

-- If it doesn't update properly, create a new column
ALTER TABLE NashvilleHousing
	ADD COLUMN AcreageConverted DECIMAL(5,2);

UPDATE NashvilleHousing
	SET AcreageConverted = CAST(Acreage AS DECIMAL(5,2));

--------------------------------------------------

-- Breaking out Address into Individual Columns (Address and City)
-- First up the Property Address, using Substrings

SELECT PropertyAddress
	FROM NashvilleHousing;

SELECT
	SUBSTRING_INDEX(PropertyAddress, ',', 1) AS Address,
	TRIM(SUBSTRING_INDEX(PropertyAddress, ',', -1)) AS City
	FROM NashvilleHousing;

ALTER TABLE NashvilleHousing
	ADD COLUMN PropertySplitAddress VARCHAR(255);

ALTER TABLE NashvilleHousing
	ADD COLUMN PropertySplitCity VARCHAR(255);

UPDATE NashvilleHousing
	SET PropertySplitAddress = SUBSTRING_INDEX(PropertyAddress, ',', 1);

UPDATE NashvilleHousing
	SET PropertySplitCity = TRIM(SUBSTRING_INDEX(PropertyAddress, ',', -1));

SELECT *
	FROM NashvilleHousing;

-- Next up the Owner Address, using substring functions instead of PARSENAME.
-- Breaking apart Address, City and State

SELECT OwnerAddress
	FROM NashvilleHousing;

SELECT 
	SUBSTRING_INDEX(OwnerAddress, ',', 1) AS Address,
	TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1)) AS City,
	TRIM(SUBSTRING_INDEX(OwnerAddress, ',', -1)) AS State
	FROM NashvilleHousing;

ALTER TABLE NashvilleHousing
	ADD COLUMN OwnerSplitAddress VARCHAR(255);

ALTER TABLE NashvilleHousing
	ADD COLUMN OwnerSplitCity VARCHAR(255);

ALTER TABLE NashvilleHousing
	ADD COLUMN OwnerSplitState VARCHAR(255);

UPDATE NashvilleHousing
	SET OwnerSplitAddress = SUBSTRING_INDEX(OwnerAddress, ',', 1);

UPDATE NashvilleHousing
	SET OwnerSplitCity = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1));

UPDATE NashvilleHousing
	SET OwnerSplitState = TRIM(SUBSTRING_INDEX(OwnerAddress, ',', -1));

SELECT *
	FROM NashvilleHousing;

--------------------------------------------------

-- Change Y and N to Yes and No in "SoldAsVacant" field

SELECT DISTINCT(SoldAsVacant), 
       COUNT(SoldAsVacant)
	FROM NashvilleHousing
	GROUP BY SoldAsVacant
	ORDER BY 2;

SELECT SoldAsVacant,
	CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
	     WHEN SoldAsVacant = 'N' THEN 'NO'
	ELSE SoldAsVacant
	END AS ConvertedValue
	FROM NashvilleHousing;

UPDATE NashvilleHousing
	SET SoldAsVacant = 
		CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
		     WHEN SoldAsVacant = 'N' THEN 'NO'
		     ELSE SoldAsVacant
	    END;

--------------------------------------------------

-- Remove Duplicates - Practicing the action of.
-- Using a CTE with ROW_NUMBER.

WITH RowNumCTE AS (
SELECT 
    id,
    ROW_NUMBER() OVER (
        PARTITION BY ParcelID,
			         PropertyAddress,
			         SalePrice,
			         SaleDate,
			         LegalReference
        ORDER BY ParcelID 
    ) AS row_num
FROM NashvilleHousing
)
DELETE nh
FROM NashvilleHousing nh
JOIN RowNumCTE cte ON nh.id = cte.id
WHERE cte.row_num > 1;

-- NOTE: Replace "id" with your table's primary key column.

--------------------------------------------------

-- Delete Unused Columns.
-- Again, just practicing doing so.

SELECT *
	FROM NashvilleHousing;

ALTER TABLE NashvilleHousing
	DROP COLUMN PropertyAddress;

ALTER TABLE NashvilleHousing
	DROP COLUMN TaxDistrict;

ALTER TABLE NashvilleHousing
	DROP COLUMN OwnerAddress;

ALTER TABLE NashvilleHousing
	DROP COLUMN SaleDate;

ALTER TABLE NashvilleHousing
	DROP COLUMN Acreage;

SELECT *
	FROM NashvilleHousing;
