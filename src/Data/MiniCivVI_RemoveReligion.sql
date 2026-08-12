DELETE FROM Buildings
-- Removes religious wonders
WHERE AdvisorType = 'ADVISOR_RELIGIOUS'
  -- Removes religious buildings
  OR PrereqDistrict = 'DISTRICT_HOLY_SITE';

--Replace Madrasa's prereq (theology) with that civic's prereq since theology is deleted
-- below
UPDATE Buildings
SET PrereqCivic = 'CIVIC_DRAMA_POETRY'
WHERE BuildingType = 'BUILDING_MADRASA';

DELETE FROM Policies
WHERE PrereqCivic = 'CIVIC_REFORMED_CHURCH'
  OR PrereqCivic = 'CIVIC_THEOLOGY';

DELETE FROM Projects
WHERE PrereqDistrict = 'DISTRICT_HOLY_SITE';

-- Much of this is from alexanderscenario_removedata.xml
DELETE FROM Types
-- Delete the actual religions themselves
WHERE Kind = 'KIND_RELIGION'
  OR Type = 'CAPABILITY_CITY_HUD_AMENITIES_RELIGION'
  OR Type = 'CAPABILITY_FAITH'
  OR Type = 'CAPABILITY_FOUND_PANTHEONS'
  OR Type = 'CAPABILITY_FOUND_RELIGIONS'
  OR Type = 'CAPABILITY_LENS_RELIGION'
  OR Type = 'CAPABILITY_RELIGION'
  OR Type = 'CAPABILITY_RELIGION_VIEW'
  OR Type = 'CIVIC_REFORMED_CHURCH'
  OR Type = 'CIVIC_THEOLOGY'
  OR Type = 'DIPLOACTION_DECLARE_HOLY_WAR'
  OR Type = 'GOVERNMENT_THEOCRACY'
  OR Type = 'IMPROVEMENT_MONASTERY'
  OR Type = 'SCORING_RELIGION'
  OR Type = 'UNIT_GREAT_PROPHET'
  OR Type = 'VICTORY_RELIGIOUS';

DELETE FROM Adjacency_YieldChanges
WHERE YieldType = 'YIELD_FAITH';

DELETE FROM BuildingModifiers
WHERE ModifierId = 'ORACLE_GREATPROPHETPOINTS';

DELETE FROM Building_YieldChanges
WHERE YieldType = 'YIELD_FAITH';

INSERT INTO CivilopediaSectionExcludes (SectionId)
VALUES ('RELIGIONS');

DELETE FROM ExcludedAdjacencies
WHERE YieldChangeId = 'District_Faith';

DELETE FROM GovernmentModifiers
WHERE GovernmentType = 'GOVERNMENT_THEOCRACY'
  AND ModifierId = 'THEOCRACY_RELIGIOUS';

DELETE FROM RandomAgendas
WHERE AgendaType = 'TRAIT_AGENDA_PREFER_FAITH';

DELETE FROM Resource_YieldChanges
WHERE YieldType = 'YIELD_FAITH';

DELETE FROM ScoringCategories
WHERE CategoryType = 'CATEGORY_RELIGION';

DELETE FROM ScoringLineItems
WHERE LineItemType = 'LINE_ITEM_RELIGION';

-- Deleting districts can cause crashes because some districts are referenced in Lua
-- files, so disable them instead
UPDATE Districts
SET MaxPerPlayer = 0,
  -- This makes it so the disabled districts don't show up in the civics/tech tree
  PrereqCivic = NULL,
  PrereqTech = NULL
WHERE DistrictType IN (
  'DISTRICT_HOLY_SITE',
  'DISTRICT_LAVRA'
);
