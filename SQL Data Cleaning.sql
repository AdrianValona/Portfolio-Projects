/* 

Cleaning Data in SQL Queries

*/

Select*
From PortfolioProject.dbo.NashvilleHousing

------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

Select SaleDateConverted, CONVERT(Date, SaleDate)
From PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate = Convert(Date,SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date; 

Update NashvilleHousing
SET SaleDateConverted = Convert(Date,SaleDate)

----------------------------------------------------------------------------------------------------------

-- Populate Property Address Data

Select *
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null 
Order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null




------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null 
--Order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1,LEN(PropertyAddress)) as Address

From PortfolioProject.dbo.NashvilleHousing



ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar(255); 

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255); 

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1,LEN(PropertyAddress))




Select*
From PortfolioProject.dbo.NashvilleHousing




Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing
-- Where OwnerAddress is not null


Select
PARSeNAME(REPLACE(OwnerAddress, ',', '.') ,3)
,PARSeNAME(REPLACE(OwnerAddress, ',', '.') ,2)
,PARSeNAME(REPLACE(OwnerAddress, ',', '.') ,1)
From PortfolioProject.dbo.NashvilleHousing
Where OwnerAddress is not null







ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255); 

Update NashvilleHousing
SET OwnerSplitAddress = PARSeNAME(REPLACE(OwnerAddress, ',', '.') ,3)


ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255); 

Update NashvilleHousing
SET OwnerSplitCity = PARSeNAME(REPLACE(OwnerAddress, ',', '.') ,2)



ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar(255); 

Update NashvilleHousing
SET OwnerSplitState = PARSeNAME(REPLACE(OwnerAddress, ',', '.') ,1)




Select*
From PortfolioProject.dbo.NashvilleHousing

---------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2



Select SoldAsVacant
, Case When SoldAsVacant = 'Y' Then 'Yes'
	   When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   END
From PortfolioProject.dbo.NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
	   When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   END





----------------------------------------------------------------------------------------------------------------

-- Remove Duplicates
WITH RowNumCTE AS(
Select*,
	ROW_NUMBER()Over(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
--Order by ParcelID
)
Delete
From RowNumCTE
Where row_num >1
--Order by PropertyAddress


---------------------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


Select*
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP Column OwnerAddress, TaxDistrict, PropertyAddress


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP Column SaleDate