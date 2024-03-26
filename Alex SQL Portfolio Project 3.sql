
select * from [dbo].[Nashville Housing csv];

select SaleDate from [dbo].[Nashville Housing csv];

-- Populate Property Address data

select PropertyAddress from [dbo].[Nashville Housing csv];

select * from [dbo].[Nashville Housing csv]
--where PropertyAddress is null
order by ParcelID;

select NH1.ParcelID, NH1.PropertyAddress, NH2.ParcelID, NH2.PropertyAddress, isnull (NH1.PropertyAddress, NH2.PropertyAddress) PopulatedPropertyAddress
from [dbo].[Nashville Housing csv] NH1 join [dbo].[Nashville Housing csv] NH2 on
NH1.ParcelID = NH2.ParcelID
and NH1.UniqueID <> NH2.UniqueID
where NH1.PropertyAddress is null;

update NH1
set PropertyAddress = isnull (NH1.PropertyAddress, NH2.PropertyAddress)
from [dbo].[Nashville Housing csv] NH1 join [dbo].[Nashville Housing csv] NH2 on
NH1.ParcelID = NH2.ParcelID
and NH1.UniqueID <> NH2.UniqueID
where NH1.PropertyAddress is null;

select * from [dbo].[Nashville Housing csv]
order by ParcelID;

-- Breaking out Address into individual columns (Address, City, State)

select PropertyAddress from [dbo].[Nashville Housing csv];

select substring (PropertyAddress, 1, CHARINDEX (',', PropertyAddress) -1) Address,
substring (PropertyAddress, CHARINDEX (',', PropertyAddress) +1, len (PropertyAddress)) Address
from [dbo].[Nashville Housing csv];

alter table [dbo].[Nashville Housing csv]
add PropertySplitAddress varchar (50);

update [dbo].[Nashville Housing csv]
set PropertySplitAddress = substring (PropertyAddress, 1, CHARINDEX (',', PropertyAddress) -1);

alter table [dbo].[Nashville Housing csv]
add PropertySplitCity varchar (50);

update [dbo].[Nashville Housing csv]
set PropertySplitCity = substring (PropertyAddress, CHARINDEX (',', PropertyAddress) +1, len (PropertyAddress));

select PropertyAddress, PropertySplitAddress, PropertySplitCity from [dbo].[Nashville Housing csv];

select OwnerAddress from [dbo].[Nashville Housing csv];

select parsename (replace (OwnerAddress, ',', '.'), 3) Address,
parsename (replace (OwnerAddress, ',', '.'), 2) City,
parsename (replace (OwnerAddress, ',', '.'), 1) State
from [dbo].[Nashville Housing csv];

alter table [dbo].[Nashville Housing csv]
add OwnerSplitAddress varchar (50);

update [dbo].[Nashville Housing csv]
set OwnerSplitAddress = parsename (replace (OwnerAddress, ',', '.'), 3);

alter table [dbo].[Nashville Housing csv]
add OwnerSplitCity varchar (50);

update [dbo].[Nashville Housing csv]
set OwnerSplitCity = parsename (replace (OwnerAddress, ',', '.'), 2);

alter table [dbo].[Nashville Housing csv]
add OwnerSplitState varchar (50);

update [dbo].[Nashville Housing csv]
set OwnerSplitState = parsename (replace (OwnerAddress, ',', '.'), 1);

select OwnerSplitAddress, OwnerSplitCity, OwnerSplitState from [dbo].[Nashville Housing csv];

-- Change '0' and '1' to 'No' and 'Yes' repectively in 'SoldAsVacant' column

alter table [dbo].[Nashville Housing csv]
alter column SoldAsVacant varchar (50);

select * from [dbo].[Nashville Housing csv];

select distinct (SoldAsVacant), count (SoldAsVacant) SoldByVacantCount from [dbo].[Nashville Housing csv]
group by SoldAsVacant
order by 2;

update [dbo].[Nashville Housing csv]
set SoldAsVacant = case when SoldAsVacant = '0' then 'No'
                        when SoldAsVacant = '1' then 'Yes'
						end;

select * from [dbo].[Nashville Housing csv]

-- To remove duplicates

with RowNumCTE as
(
select *, ROW_NUMBER () over (partition by ParcelID,
										   PropertyAddress,
										   SalePrice,
										   SaleDate,
										   LegalReference
										   order by UniqueID) RowNumber

from [dbo].[Nashville Housing csv]
--order by ParcelID
)
select * from RowNumCTE
where RowNumber > 1
order by PropertyAddress;

with RowNumCTE as
(
select *, ROW_NUMBER () over (partition by ParcelID,
										   PropertyAddress,
										   SalePrice,
										   SaleDate,
										   LegalReference
										   order by UniqueID) RowNumber

from [dbo].[Nashville Housing csv]
--order by ParcelID
)
delete from RowNumCTE
where RowNumber > 1
--order by PropertyAddress;

-- To delete unused columns

alter table [dbo].[Nashville Housing csv]
drop column OwnerAddress, TaxDistrict, PropertyAddress;

select * from [dbo].[Nashville Housing csv];

