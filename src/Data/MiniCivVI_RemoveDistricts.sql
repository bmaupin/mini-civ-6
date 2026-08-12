UPDATE Buildings
SET PrereqTech = (
  SELECT PrereqTech FROM Districts
  WHERE Buildings.PrereqDistrict = Districts.DistrictType
    AND Districts.PrereqTech IS NOT NULL
)
WHERE PrereqCivic IS NULL
  AND PrereqTech IS NULL
  AND PrereqDistrict IS NOT NULL
  AND PrereqDistrict != 'DISTRICT_CITY_CENTER';

UPDATE Buildings
SET PrereqCivic = (
  SELECT PrereqCivic FROM Districts
  WHERE Buildings.PrereqDistrict = Districts.DistrictType
    AND Districts.PrereqCivic IS NOT NULL
)
WHERE PrereqCivic IS NULL
  AND PrereqTech IS NULL
  AND PrereqDistrict IS NOT NULL
  AND PrereqDistrict != 'DISTRICT_CITY_CENTER';

UPDATE Buildings
SET PrereqDistrict = 'DISTRICT_CITY_CENTER'
WHERE PrereqDistrict IS NOT NULL;

UPDATE Projects
SET PrereqTech = (
  SELECT PrereqTech FROM Districts
  WHERE Projects.PrereqDistrict = Districts.DistrictType
    AND Districts.PrereqTech IS NOT NULL
)
WHERE PrereqCivic IS NULL
  AND PrereqTech IS NULL
  AND PrereqDistrict IS NOT NULL
  AND PrereqDistrict != 'DISTRICT_CITY_CENTER';

UPDATE Projects
SET PrereqCivic = (
  SELECT PrereqCivic FROM Districts
  WHERE Projects.PrereqDistrict = Districts.DistrictType
    AND Districts.PrereqCivic IS NOT NULL
)
WHERE PrereqCivic IS NULL
  AND PrereqTech IS NULL
  AND PrereqDistrict IS NOT NULL
  AND PrereqDistrict != 'DISTRICT_CITY_CENTER';

UPDATE Projects
SET PrereqDistrict = 'DISTRICT_CITY_CENTER'
WHERE PrereqDistrict IS NOT NULL;

UPDATE Units
SET PrereqTech = (
  SELECT PrereqTech FROM Districts
  WHERE Units.PrereqDistrict = Districts.DistrictType
    AND Districts.PrereqTech IS NOT NULL
)
WHERE PrereqCivic IS NULL
  AND PrereqTech IS NULL
  AND PrereqDistrict IS NOT NULL
  AND PrereqDistrict != 'DISTRICT_CITY_CENTER';

UPDATE Units
SET PrereqCivic = (
  SELECT PrereqCivic FROM Districts
  WHERE Units.PrereqDistrict = Districts.DistrictType
    AND Districts.PrereqCivic IS NOT NULL
)
WHERE PrereqCivic IS NULL
  AND PrereqTech IS NULL
  AND PrereqDistrict IS NOT NULL
  AND PrereqDistrict != 'DISTRICT_CITY_CENTER';

UPDATE Units
SET PrereqDistrict = 'DISTRICT_CITY_CENTER'
WHERE PrereqDistrict IS NOT NULL;

UPDATE GreatPersonClasses
SET DistrictType = 'DISTRICT_CITY_CENTER'
WHERE DistrictType IS NOT NULL;

UPDATE GreatPersonIndividuals
SET ActionRequiresCompletedDistrictType = 'DISTRICT_CITY_CENTER'
WHERE ActionRequiresCompletedDistrictType IS NOT NULL;

UPDATE MajorStartingUnits
SET District = 'DISTRICT_CITY_CENTER'
WHERE District IS NOT NULL;

UPDATE StartingBuildings
SET District = 'DISTRICT_CITY_CENTER'
WHERE District IS NOT NULL;

UPDATE UnitOperations
SET TargetDistrict = 'DISTRICT_CITY_CENTER'
WHERE TargetDistrict IS NOT NULL;

-- Deleting districts can cause crashes because some districts are referenced in Lua
-- files, so disable them instead
UPDATE Districts
  SET MaxPerPlayer = 0,
    -- This makes it so the districts don't show up in the civics/tech tree
    PrereqCivic = NULL,
    PrereqTech = NULL
  WHERE DistrictType != 'DISTRICT_CITY_CENTER';
