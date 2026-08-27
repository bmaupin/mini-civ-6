-- TODO: Blocked for now; we can't remove the civics tree because governments
--       can't have PrereqTechs, only PrereqCivics
--
-- -- Remove dependencies on the civics tree so we can delete it
-- UPDATE Buildings
-- SET PrereqCivic = NULL,
--   PrereqTech = 'TECH_WRITING'
-- WHERE BuildingType = 'BUILDING_ORACLE';

-- UPDATE DiplomaticActions
-- SET InitiatorPrereqTech = NULL
-- WHERE DiplomaticActionType = 'DIPLOACTION_JOINT_WAR';

-- UPDATE Governments
-- SET PrereqCivic = NULL
-- WHERE GovernmentType = 'GOVERNMENT_AUTOCRACY';

-- UPDATE Units
-- SET PrereqCivic = NULL,
--   PrereqTech = 'TECH_CURRENCY'
-- WHERE UnitType = 'UNIT_TRADER';


UPDATE BarbarianAttackForces
SET SupportTag = 'CLASS_SIEGE'
WHERE SupportTag = 'CLASS_BATTERING_RAM';

UPDATE BarbarianTribes
SET DefenderTag = 'CLASS_MELEE'
WHERE DefenderTag = 'CLASS_ANTI_CAVALRY';

UPDATE BarbarianTribes
SET ScoutTag = 'CLASS_MELEE'
WHERE ScoutTag = 'CLASS_RECON';

UPDATE BarbarianTribes
SET SupportTag = 'CLASS_SIEGE'
WHERE SupportTag = 'CLASS_BATTERING_RAM';



-- Give barracks the same combat experience bonus for cavalry and siege units as Stable;
-- this more closely matches naval and air buildings as well as other ground unit
-- buildings and allows us to remove Stable
INSERT INTO BuildingModifiers (BuildingType, ModifierId)
VALUES ('BUILDING_BARRACKS', 'STABLE_TRAINED_UNIT_XP_MODIFIER');

-- When a cavalry/siege unit is trained in a city with a barracks, show the barracks
-- bonus, not stable
UPDATE UnitAbilities
SET Description = 'LOC_ABILITY_BARRACKS_TRAINED_UNIT_XP_DESCRIPTION'
WHERE UnitAbilityType = 'ABILITY_STABLE_TRAINED_UNIT_XP';



-- Use a whitelist for deletions to prevent DLC from adding additional items to the game
DELETE FROM Types
WHERE Type IN (
  SELECT Type FROM Types
  WHERE Kind = 'KIND_DIPLOMATIC_ACTION'
    AND Type NOT IN (
      'DIPLOACTION_DEMAND_TRIBUTE',
      'DIPLOACTION_DECLARE_SURPRISE_WAR',
      'DIPLOACTION_MAKE_PEACE',
      'DIPLOACTION_PROPOSE_TRADE',
      'DIPLOACTION_PROPOSE_PEACE_DEAL',
      'DIPLOACTION_JOINT_WAR'
    )
);

DELETE FROM Types
WHERE Type IN (
  SELECT Type FROM Types
  WHERE Kind = 'KIND_GOVERNMENT'
    AND Type NOT IN (
      -- Replacement for fundamentalism (maybe theocracy a better fit?)
      'GOVERNMENT_AUTOCRACY',
      -- Equivalent of despotism (starting government)
      'GOVERNMENT_CHIEFDOM',
      'GOVERNMENT_CLASSICAL_REPUBLIC',
      'GOVERNMENT_COMMUNISM',
      'GOVERNMENT_DEMOCRACY',
      'GOVERNMENT_MONARCHY'
    )
);

-- https://civilization.fandom.com/wiki/Terrain_(CivRev)
DELETE FROM Types
WHERE Type IN (
  SELECT Type FROM Types
  WHERE Kind = 'KIND_IMPROVEMENT'
    AND Type NOT IN (
      'IMPROVEMENT_BARBARIAN_CAMP',
      'IMPROVEMENT_FARM',
      'IMPROVEMENT_MINE',
      'IMPROVEMENT_QUARRY',
      'IMPROVEMENT_FISHING_BOATS',
      'IMPROVEMENT_PASTURE',
      'IMPROVEMENT_PLANTATION',
      'IMPROVEMENT_CAMP',
      'IMPROVEMENT_LUMBER_MILL',
      'IMPROVEMENT_GOODY_HUT',
      'IMPROVEMENT_OIL_WELL',
      'IMPROVEMENT_OFFSHORE_OIL_RIG'
    )
);

-- https://civilization.fandom.com/wiki/List_of_resources_in_CivRev
DELETE FROM Types
WHERE Type IN (
  SELECT Type FROM Types
  WHERE Kind = 'KIND_RESOURCE'
    AND Type NOT IN (
      'RESOURCE_ALUMINUM',
      'RESOURCE_CATTLE',
      'RESOURCE_COAL',
      -- Replacement for game
      'RESOURCE_DEER',
      -- Replacement for gems
      'RESOURCE_DIAMONDS',
      'RESOURCE_DYES',
      'RESOURCE_FISH',
      'RESOURCE_INCENSE',
      'RESOURCE_IRON',
      -- Replacement for oxen?
      'RESOURCE_HORSES',
      'RESOURCE_MARBLE',
      'RESOURCE_OIL',
      'RESOURCE_SILK',
      'RESOURCE_SPICES',
      'RESOURCE_URANIUM',
      'RESOURCE_WHALES',
      'RESOURCE_WHEAT',
      'RESOURCE_WINE'
    )
);

CREATE TEMP TABLE IF NOT EXISTS UnitsToKeep AS
  SELECT UnitType FROM Units WHERE UnitType IN (
    --
    -- Barbarians
    --
    'UNIT_BARBARIAN_HORSEMAN',
    'UNIT_BARBARIAN_HORSE_ARCHER',
    --
    -- Great people
    --
    'UNIT_GREAT_GENERAL',
    'UNIT_GREAT_ADMIRAL',
    'UNIT_GREAT_ENGINEER',
    'UNIT_GREAT_MERCHANT',
    'UNIT_GREAT_SCIENTIST',
    'UNIT_GREAT_WRITER',
    'UNIT_GREAT_ARTIST',
    'UNIT_GREAT_MUSICIAN',
    --
    -- CivRev units
    --
    'UNIT_ARCHER',
    'UNIT_ARTILLERY',
    'UNIT_BATTLESHIP',
    'UNIT_BOMBER',
    'UNIT_CATAPULT',
    -- Equivalent of CivRev cannon
    'UNIT_FIELD_CANNON',
    'UNIT_FIGHTER',
    -- Equivalent of CivRev galleon
    'UNIT_FRIGATE',
    'UNIT_GALLEY',
    'UNIT_HORSEMAN',
    'UNIT_KNIGHT',
    -- Equivalent of CivRev modern infantry
    'UNIT_INFANTRY',
    'UNIT_IRONCLAD',
    -- Equivalent of CivRev riflemen
    'UNIT_MUSKETMAN',
    'UNIT_PIKEMAN',
    'UNIT_SETTLER',
    'UNIT_SPY',
    'UNIT_SUBMARINE',
    -- Equivalent of CivRev legion
    'UNIT_SWORDSMAN',
    'UNIT_TANK',
    'UNIT_TRADER',
    'UNIT_WARRIOR'
  );

-- Keep unique units that match units in UnitsToKeep
INSERT INTO UnitsToKeep (UnitType)
  SELECT CivUniqueUnitType FROM UnitReplaces
  WHERE ReplacesUnitType IN (
    SELECT UnitType FROM UnitsToKeep
  );

-- https://civilization.fandom.com/wiki/List_of_units_in_CivRev
DELETE FROM Types
WHERE Type IN (
  SELECT Type FROM Types
  WHERE Kind = 'KIND_UNIT'
    AND Type NOT IN (
      SELECT UnitType FROM UnitsToKeep
    )
);

DROP TABLE IF EXISTS UnitsToKeep;



-- Misc removals
DELETE FROM Adjacency_YieldChanges
-- This civic doesn't do anything else in CivRev mode and it shows up empty in the tree
WHERE PrereqCivic = 'CIVIC_EXPLORATION';

DELETE FROM CivicModifiers
-- This civic doesn't do anything else in CivRev mode and it shows up empty in the tree
WHERE CivicType = 'CIVIC_NATURAL_HISTORY';

-- CivRev doesn't ever allow open borders so set this as early as possible; simply
-- removing the modifier makes it so that borders are never enforced
UPDATE CivicModifiers
SET CivicType = 'CIVIC_CODE_OF_LAWS'
WHERE ModifierId = 'CIVIC_ENFORCE_BORDERS';

-- Make corps/armies available right away to match CivRev mechanics
-- NOTE: Corps cannot be removed; unlike CivRev two units must first be combined before
--       they can be combined with a third
UPDATE UnitCommands
SET PrereqCivic = NULL
WHERE CommandType = 'UNITCOMMAND_FORM_ARMY'
  OR CommandType = 'UNITCOMMAND_FORM_CORPS';

-- CivRev doesn't have strategic resource requirements for units
UPDATE Units
SET StrategicResource = NULL;

DELETE FROM Types
WHERE Type IN (
  -- TODO: Remove if we change the functionality of great artists
	-- 'CAPABILITY_GREAT_WORKS',
  -- TODO: Remove if we automate great people acquisition
	-- 'CAPABILITY_GREAT_PEOPLE_CAN_RECRUIT',
  -- Prevent buying great people
	'CAPABILITY_GREAT_PEOPLE_RECRUIT_WITH_GOLD',
	'CAPABILITY_GREAT_PEOPLE_RECRUIT_WITH_FAITH',
  -- Disable reject button in the Great People UI
	'CAPABILITY_GREAT_PEOPLE_CAN_REJECT'
  -- TODO: Remove if we automate great people acquisition
	-- 'CAPABILITY_GREAT_PEOPLE_VIEW'
);

DELETE FROM Types
WHERE Type IN (
  --
  -- Buildings
  --
  -- Keep barracks as unique building for improving land units
  'BUILDING_ARMORY',
  -- Keep airport as unique building for improving air units
  'BUILDING_HANGAR',
  -- Keep barracks as unique building for improving land units
  'BUILDING_MILITARY_ACADEMY',
  'BUILDING_POWER_PLANT',
  'BUILDING_RESEARCH_LAB',
  -- Keep lighthouse as unique building for improving sea units
  'BUILDING_SEAPORT',
  -- Housing
  'BUILDING_SEWER',
  -- Keep lighthouse as unique building for improving sea units
  'BUILDING_SHIPYARD',
  -- Keep barracks as unique building for improving land units
  'BUILDING_STABLE',
  --
  -- Civics
  --
  -- One less civic; benefits for city-states, faith, builders, appeal
  'CIVIC_CONSERVATION',
  -- We removed the corps prereq, so all it does is grant an additional spy
  'CIVIC_NATIONALISM',
  --
  -- Techs
  --
  'TECH_FLIGHT'
);
