select * 
from PortfolioProject..NashVilleHousing

---------------------------------------------------
--Standardize Date Format

select SaleDateConverted, CONVERT(Date,SaleDate) 
from PortfolioProject..NashVilleHousing

Update NashVilleHousing
set SaleDate = CONVERT(Date, Saledate)

Alter table NashVilleHousing
Add SaleDateConverted Date;

Update NashVilleHousing
Set	SaleDateConverted = CONVERT(Date,SaleDate)

----------------------------------------------------
--Updating Property Address

select *
from PortfolioProject..NashVilleHousing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashVilleHousing a
JOIN PortfolioProject..NashVilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashVilleHousing a
JOIN PortfolioProject..NashVilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]

-----------------------------------------------------

select PropertyAddress
from PortfolioProject..NashVilleHousing
--where PropertyAddress is null
--order by ParcelID

select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
,SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress) +1,Len(PropertyAddress)) as Address
from PortfolioProject..NashVilleHousing

Alter table NashVilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashVilleHousing
Set	PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

Alter table NashVilleHousing
Add propertySplitCity Nvarchar(255);

Update NashVilleHousing
Set	propertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress) +1,Len(PropertyAddress))

select PropertySplitAddress, propertySplitCity
from PortfolioProject..NashVilleHousing


select OwnerAddress
from PortfolioProject..NashVilleHousing

select
PARSENAME(Replace(OwnerAddress,',','.'),3)
,PARSENAME(Replace(OwnerAddress,',','.'),2)
,PARSENAME(Replace(OwnerAddress,',','.'),1)
from PortfolioProject..NashVilleHousing

Alter table NashVilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashVilleHousing
Set	OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'),3)

Alter table NashVilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashVilleHousing
Set	OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2)

Alter table NashVilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashVilleHousing
Set	OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'),1)

select OwnerSplitAddress 'Owner Address', OwnerSplitCity 'Owner City', OwnerSplitState 'Owner State'
from PortfolioProject..NashVilleHousing

------------------------------------------------------
--Yes or No in 'Sold as Vacant'

select * 
from PortfolioProject..NashVilleHousing

select Distinct(SoldAsVacant), Count(SoldAsVacant)
from PortfolioProject..NashVilleHousing
Group by SoldAsVacant
Order by 2

select SoldAsVacant,
	Case when SoldAsVacant = 'Y' then 'Yes'
		 when SoldAsVacant = 'N' then 'No'
		 Else SoldAsVacant
	End
from PortfolioProject..NashVilleHousing

UPDATE NashVilleHousing
SET SoldAsVacant = Case when SoldAsVacant = 'Y' then 'Yes'
		 when SoldAsVacant = 'N' then 'No'
		 Else SoldAsVacant
	End
from PortfolioProject..NashVilleHousing

------------------------------------------------------
--Removing Duplicates using CTE

with RowNumCTE as(
select *,
	ROW_NUMBER() over (
	partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
from PortfolioProject..NashVilleHousing
)

Select *
from RowNumCTE
Where row_num > 1
Order by PropertyAddress

select *
from PortfolioProject..NashVilleHousing

-------------------------------------------------------
--Delete Unused Column
select *
from PortfolioProject..NashVilleHousing

Alter table PortfolioProject..NashVilleHousing
DROP Column SaleDate