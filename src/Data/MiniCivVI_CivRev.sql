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

-- Modifiers have to be deleted directly because deleting the Type doesn't cascade the
-- delete to the Modifiers table
-- CivRev doesn't ever allow open borders
DELETE FROM Modifiers
WHERE ModifierType = 'MODIFIER_PLAYER_ADJUST_ENFORCE_BORDERS';

DELETE FROM Types
WHERE Type IN (
  --
  -- Buildings
  --
  -- Superfluous
  'BUILDING_POWER_PLANT',
  'BUILDING_SEAPORT',
  --
  -- Civics
  --
  -- One less civic; benefits for city-states, faith, builders, appeal
  'CIVIC_CONSERVATION',
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
  -- Superfluous
  'BUILDING_GREAT_ZIMBABWE',
  -- One less civic
  'BUILDING_HALICARNASSUS_MAUSOLEUM',
  -- One less civic
  'BUILDING_HERMITAGE',
  -- Grants spearman, battering ram, anti-cavalry bonuses
  'BUILDING_STATUE_OF_ZEUS',
  -- One less civic
  'BUILDING_TORRE_DE_BELEM',
  -- Superfluous
  'BUILDING_VENETIAN_ARSENAL'
);
