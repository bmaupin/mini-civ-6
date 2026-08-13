-- Keep these districts
CREATE TEMP TABLE IF NOT EXISTS DistrictsToKeep AS
  SELECT DistrictType FROM Districts WHERE DistrictType IN (
    -- GS only, unique placement and benefits
    'DISTRICT_CANAL',
    'DISTRICT_CITY_CENTER',
    -- Unique harbour replacement
    'DISTRICT_COTHON',
    -- GS only, unique placement and benefits
    'DISTRICT_DAM',
    -- Allows inland cities access to build boats, only built on water
    'DISTRICT_HARBOR',
    -- Unique harbour replacement
    'DISTRICT_ROYAL_NAVY_DOCKYARD',
    -- Required for science victory, shows victory progress on the map
    'DISTRICT_SPACEPORT',
    -- The only scenario-specific district (Black Death)
    'DISTRICT_WALLED_QUARTER',
    'DISTRICT_WONDER'
  );

UPDATE Buildings
SET PrereqTech = (
  SELECT PrereqTech FROM Districts
  WHERE Buildings.PrereqDistrict = Districts.DistrictType
    AND Districts.PrereqTech IS NOT NULL
)
WHERE PrereqCivic IS NULL
  AND PrereqTech IS NULL
  AND PrereqDistrict IS NOT NULL
  AND PrereqDistrict NOT IN (SELECT DistrictType FROM DistrictsToKeep);

UPDATE Buildings
SET PrereqCivic = (
  SELECT PrereqCivic FROM Districts
  WHERE Buildings.PrereqDistrict = Districts.DistrictType
    AND Districts.PrereqCivic IS NOT NULL
)
WHERE PrereqCivic IS NULL
  AND PrereqTech IS NULL
  AND PrereqDistrict IS NOT NULL
  AND PrereqDistrict NOT IN (SELECT DistrictType FROM DistrictsToKeep);

-- Buildings without a PrereqDistrict can't be built
UPDATE Buildings
SET PrereqDistrict = 'DISTRICT_CITY_CENTER'
WHERE PrereqDistrict IS NOT NULL
  AND PrereqDistrict NOT IN (SELECT DistrictType FROM DistrictsToKeep);

UPDATE Buildings
SET AdjacentDistrict = NULL
WHERE AdjacentDistrict IS NOT NULL
  AND AdjacentDistrict NOT IN (SELECT DistrictType FROM DistrictsToKeep);

UPDATE Projects
SET PrereqTech = (
  SELECT PrereqTech FROM Districts
  WHERE Projects.PrereqDistrict = Districts.DistrictType
    AND Districts.PrereqTech IS NOT NULL
)
WHERE PrereqCivic IS NULL
  AND PrereqTech IS NULL
  AND PrereqDistrict IS NOT NULL
  AND PrereqDistrict NOT IN (SELECT DistrictType FROM DistrictsToKeep);

UPDATE Projects
SET PrereqCivic = (
  SELECT PrereqCivic FROM Districts
  WHERE Projects.PrereqDistrict = Districts.DistrictType
    AND Districts.PrereqCivic IS NOT NULL
)
WHERE PrereqCivic IS NULL
  AND PrereqTech IS NULL
  AND PrereqDistrict IS NOT NULL
  AND PrereqDistrict NOT IN (SELECT DistrictType FROM DistrictsToKeep);

UPDATE Projects
SET PrereqDistrict = 'DISTRICT_CITY_CENTER'
WHERE PrereqDistrict IS NOT NULL
  AND PrereqDistrict NOT IN (SELECT DistrictType FROM DistrictsToKeep);

UPDATE Units
SET PrereqTech = (
  SELECT PrereqTech FROM Districts
  WHERE Units.PrereqDistrict = Districts.DistrictType
    AND Districts.PrereqTech IS NOT NULL
)
WHERE PrereqCivic IS NULL
  AND PrereqTech IS NULL
  AND PrereqDistrict IS NOT NULL
  AND PrereqDistrict NOT IN (SELECT DistrictType FROM DistrictsToKeep);

UPDATE Units
SET PrereqCivic = (
  SELECT PrereqCivic FROM Districts
  WHERE Units.PrereqDistrict = Districts.DistrictType
    AND Districts.PrereqCivic IS NOT NULL
)
WHERE PrereqCivic IS NULL
  AND PrereqTech IS NULL
  AND PrereqDistrict IS NOT NULL
  AND PrereqDistrict NOT IN (SELECT DistrictType FROM DistrictsToKeep);

UPDATE Units
SET PrereqDistrict = 'DISTRICT_CITY_CENTER'
WHERE PrereqDistrict IS NOT NULL
  AND PrereqDistrict NOT IN (SELECT DistrictType FROM DistrictsToKeep);

UPDATE GreatPersonClasses
SET DistrictType = 'DISTRICT_CITY_CENTER'
WHERE DistrictType IS NOT NULL
  AND DistrictType NOT IN (SELECT DistrictType FROM DistrictsToKeep);

UPDATE GreatPersonIndividuals
SET ActionRequiresCompletedDistrictType = 'DISTRICT_CITY_CENTER'
WHERE ActionRequiresCompletedDistrictType IS NOT NULL
  AND ActionRequiresCompletedDistrictType NOT IN (SELECT DistrictType FROM DistrictsToKeep);

UPDATE MajorStartingUnits
SET District = 'DISTRICT_CITY_CENTER'
WHERE District IS NOT NULL
  AND District NOT IN (SELECT DistrictType FROM DistrictsToKeep);

UPDATE StartingBuildings
SET District = 'DISTRICT_CITY_CENTER'
WHERE District IS NOT NULL
  AND District NOT IN (SELECT DistrictType FROM DistrictsToKeep);

UPDATE UnitOperations
SET TargetDistrict = 'DISTRICT_CITY_CENTER'
WHERE TargetDistrict IS NOT NULL
  AND TargetDistrict NOT IN (SELECT DistrictType FROM DistrictsToKeep);

-- Deleting districts can cause crashes because some districts are referenced in Lua
-- files, so disable them instead
UPDATE Districts
  SET MaxPerPlayer = 0,
    -- This makes it so the disabled districts don't show up in the civics/tech tree
    PrereqCivic = NULL,
    PrereqTech = NULL
  WHERE DistrictType NOT IN (SELECT DistrictType FROM DistrictsToKeep);

-- Cities can only build 1 aircraft but aerodrome can have more, so mitigate disabling of
-- the aerodrome by adding more air slots to city centre
UPDATE Districts
SET AirSlots = AirSlots + (
  SELECT AirSlots FROM Districts
  WHERE DistrictType = 'DISTRICT_AERODROME'
)
WHERE DistrictType = 'DISTRICT_CITY_CENTER';

DROP TABLE IF EXISTS DistrictsToKeep;
