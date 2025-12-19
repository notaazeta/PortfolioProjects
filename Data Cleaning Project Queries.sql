use [Portfolio Project]


select *
from [dbo].[NashvilleHousing]

-- standardize date formate

select SaleDateConverted, convert(date,SaleDate)
from [dbo].[NashvilleHousing]

--update NashvilleHousing
--set SaleDate = Convert(Date,SaleDate)

alter table NashvilleHousing
add SaleDateConverted Date;

update NashvilleHousing
set SaleDateConverted = Convert(Date,SaleDate)



--Populate property address data

select a.ParcelID, a.propertyAddress, b.ParcelID, b.propertyAddress, isnull(a.propertyAddress, b.propertyAddress)
from [dbo].[NashvilleHousing] a
join [dbo].[NashvilleHousing] b
on a.parcelID = b.parcelID
and a.UniqueID <> b.uniqueID
where a.propertyAddress is null

UPDATE a
set propertyAddress = isnull(a.propertyAddress, b.propertyAddress)
from [dbo].[NashvilleHousing] a
join [dbo].[NashvilleHousing] b
on a.parcelID = b.parcelID
and a.UniqueID <> b.uniqueID
where a.PropertyAddress is null

--Breaking out address into individual columns
select propertyaddress
from [dbo].[NashvilleHousing]

select 
substring(propertyaddress, 1, charindex(',',propertyaddress) -1) as address
, substring(propertyaddress, charindex(',',propertyaddress) +1, len(propertyaddress)) as address
from [dbo].[NashvilleHousing]

alter table NashvilleHousing
add Propertysplitaddress nvarchar(255);

update NashvilleHousing
set Propertysplitaddress = substring(propertyaddress, 1, charindex(',',propertyaddress) -1) 

alter table NashvilleHousing
add propertysplitcity nvarchar(255);

update NashvilleHousing
set Propertysplitcity= substring(propertyaddress, charindex(',',propertyaddress) +1, len(propertyaddress))

select *
from [dbo].[NashvilleHousing]






select OwnerAddress
from [dbo].[NashvilleHousing]

select 
parsename(REPLACE(OwnerAddress, ',','.'),3)
, parsename(REPLACE(OwnerAddress, ',','.'),2)
, parsename(REPLACE(OwnerAddress, ',','.'),1)
from [dbo].[NashvilleHousing]


alter table NashvilleHousing
add OwnerSplitAddress nvarchar(255);

update NashvilleHousing
set Ownersplitaddress = parsename(REPLACE(OwnerAddress, ',','.'),3)

alter table NashvilleHousing
add OwnerSplitCity nvarchar(255);

update NashvilleHousing
set OwnerSplitCity = parsename(REPLACE(OwnerAddress, ',','.'),2)

alter table NashvilleHousing
add OwnerSplitState nvarchar(255);

update NashvilleHousing
set OwnerSplitState = parsename(REPLACE(OwnerAddress, ',','.'),1)

select *
from [dbo].[NashvilleHousing]





--change Y and N to Yes and No in Sold as Vacant field

select Distinct(Soldasvacant), count(Soldasvacant)
from [dbo].[NashvilleHousing]
group by Soldasvacant
order by 2 


select soldasvacant
, case when soldasvacant = 'Y' then 'Yes'
when SoldAsVacant ='N' then 'No'
else SoldAsVacant
end
from [dbo].[NashvilleHousing]

update nashvilleHousing
set SoldAsVacant = case when soldasvacant = 'Y' then 'Yes'
when SoldAsVacant ='N' then 'No'
else SoldAsVacant
end



--Remove duplicates

with RowNumCTE as(
select *,
ROW_NUMBER() over(
partition by ParcelID,
propertyAddress,
SalePrice,
SaleDate,
LegalReference
order by 
UniqueID
) row_num

from [dbo].[NashvilleHousing]
--order by ParcelID
)


select *
from RowNumCTE
where row_num > 1



--Delete Unused Columns

select *
from [dbo].[NashvilleHousing]

alter table [dbo].[NashvilleHousing]
drop column OwnerAddress, TaxDistrict, PropertyAddress

alter table [dbo].[NashvilleHousing]
drop column SaleDate
