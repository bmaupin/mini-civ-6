-- Disable these districts
CREATE TEMP TABLE IF NOT EXISTS DistrictsToDisable AS
  SELECT DistrictType FROM Districts WHERE DistrictType IN (
    -- Theatre Square replacement
    'DISTRICT_ACROPOLIS',
    -- Housing
    'DISTRICT_AQUEDUCT',
    -- Aqueduct replacement
    'DISTRICT_BATH',
    -- Culture, city states, espionage
    'DISTRICT_DIPLOMATIC_QUARTER',
    -- Neighbourhood replacement
    'DISTRICT_MBANZA',
    -- Housing
    'DISTRICT_NEIGHBORHOOD',
    -- Housing, appeal, culture bomb
    'DISTRICT_PRESERVE',
    -- Culture, great person points
    'DISTRICT_THEATER'
  );

DELETE FROM Buildings
WHERE PrereqDistrict IN (SELECT DistrictType FROM DistrictsToDisable);

DELETE FROM Projects
WHERE PrereqDistrict IN (SELECT DistrictType FROM DistrictsToDisable);

DELETE FROM Units
WHERE PrereqDistrict IN (SELECT DistrictType FROM DistrictsToDisable);

-- Deleting districts can cause crashes because some districts are referenced in Lua
-- files, so disable them instead
UPDATE Districts
SET MaxPerPlayer = 0,
  -- This makes it so the districts don't show up in the civics/tech tree
  PrereqCivic = NULL,
  PrereqTech = NULL
WHERE DistrictType IN (SELECT DistrictType FROM DistrictsToDisable);

DROP TABLE IF EXISTS DistrictsToDisable;


-- Remove hidden agendas; can only be discovered with espionage and they're annoyingly random
DELETE FROM RandomAgendas;



-- Misc removals
DELETE FROM Types
WHERE Type IN (
  --
  -- Wonders
  --
  -- Superfluous
  'BUILDING_ALHAMBRA',
  -- One less civic
  'BUILDING_BOLSHOI_THEATRE',
  -- One less civic
  'BUILDING_BROADWAY',
  -- One less civic
  'BUILDING_CHICHEN_ITZA',
  -- Superfluous
  'BUILDING_ETEMENANKI',
  -- Policies
  'BUILDING_FORBIDDEN_CITY',
  -- Superfluous
  'BUILDING_GREAT_ZIMBABWE',
  -- One less civic
  'BUILDING_HALICARNASSUS_MAUSOLEUM',
  -- One less civic
  'BUILDING_HERMITAGE',
  -- Amenities
  'BUILDING_HUEY_TEOCALLI',
  -- Policies
  'BUILDING_POTALA_PALACE',
  -- Grants spearman, battering ram, anti-cavalry bonuses
  'BUILDING_STATUE_OF_ZEUS',
  -- One less civic
  'BUILDING_TORRE_DE_BELEM',
  -- Superfluous
  'BUILDING_VENETIAN_ARSENAL'
);
