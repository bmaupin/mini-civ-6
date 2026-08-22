DELETE FROM Types
WHERE Type IN (
  SELECT Type FROM Types
  WHERE Type LIKE 'DIPLOACTION\_%' ESCAPE '\'
    AND Type NOT IN (
      'DIPLOACTION_DEMAND_TRIBUTE',
      'DIPLOACTION_DECLARE_SURPRISE_WAR',
      'DIPLOACTION_MAKE_PEACE',
      'DIPLOACTION_PROPOSE_TRADE',
      'DIPLOACTION_PROPOSE_PEACE_DEAL',
      'DIPLOACTION_JOINT_WAR'
    )
);

-- https://civilization.fandom.com/wiki/Terrain_(CivRev)
DELETE FROM Types
WHERE Type IN (
  SELECT Type FROM Types
  WHERE Type LIKE 'IMPROVEMENT\_%' ESCAPE '\'
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
  WHERE Type LIKE 'RESOURCE\_%' ESCAPE '\'
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
  WHERE Type LIKE 'UNIT\_%' ESCAPE '\'
    AND Type NOT IN (
      SELECT UnitType FROM UnitsToKeep
    )
);

DROP TABLE IF EXISTS UnitsToKeep;
