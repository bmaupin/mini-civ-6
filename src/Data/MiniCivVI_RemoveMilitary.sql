DELETE FROM Types WHERE Type = 'CAPABILITY_CITY_HUD_AMENITIES_WAR_WEARINESS';
DELETE FROM Types WHERE Type = 'CAPABILITY_GOVERNMENT_SCREEN_MILITARY_FILTER';
DELETE FROM Types WHERE Type = 'CAPABILITY_MILITARY';

-- Delete military beliefs
DELETE FROM Types WHERE Type IN (
  'BELIEF_DEFENDER_OF_FAITH',
  'BELIEF_JUST_WAR'
);
-- Delete military pantheons; pantheons are just a specific class of beliefs
DELETE FROM Types WHERE Type IN (
  'BELIEF_GOD_OF_THE_FORGE',
  'BELIEF_GOD_OF_WAR',
  'BELIEF_INITIATION_RITES'
);
-- This is the only government that appears to have purely military effects
DELETE FROM Types WHERE Type = 'GOVERNMENT_OLIGARCHY';
DELETE FROM Types WHERE Type = 'GREAT_PERSON_CLASS_ADMIRAL';
DELETE FROM Types WHERE Type = 'GREAT_PERSON_CLASS_GENERAL';
-- This should delete all military policies
DELETE FROM Types WHERE Type = 'SLOT_MILITARY';
DELETE FROM Types WHERE Type = 'UNIT_GREAT_ADMIRAL';
DELETE FROM Types WHERE Type = 'UNIT_GREAT_GENERAL';

DELETE FROM Agendas WHERE AgendaType IN (
    'AGENDA_AIRPOWER',
    'AGENDA_BARBARIAN_LOVER',
    -- 'AGENDA_CITY_STATE_PROTECTOR'?
    'AGENDA_CIVILIZED',
    'AGENDA_DARWINIST',
    'AGENDA_GREAT_WHITE_FLEET', -- Gathering Storm
    'AGENDA_NUKE_LOVER',
    'AGENDA_STANDING_ARMY'
);

-- This removes military buildings and wonders
DELETE FROM Buildings WHERE AdvisorType = 'ADVISOR_CONQUEST';

-- NOTE: This works but is not reflected in the UI of the civics tree
DELETE FROM CivicModifiers WHERE ModifierId = 'CIVIC_GRANT_COMBAT_ADJACENCY_BONUS';

DELETE FROM DiplomaticActions WHERE DiplomaticActionType = 'DIPLOACTION_DECLARE_SURPRISE_WAR';
DELETE FROM DiplomaticActions WHERE DiplomaticActionType = 'DIPLOACTION_DECLARE_WAR_MINOR_CIV';
DELETE FROM DiplomaticActions WHERE UIGroup = 'FORMALWAR';

-- Instead of deleting districts, disable them. This is because deleting the aerodrome
-- district caused a bug in the spy "choose escape route" dialogue because it expects
-- the aerodome district (among others) to exist.
UPDATE Districts
  SET MaxPerPlayer = 0
  WHERE AdvisorType = 'ADVISOR_CONQUEST';

-- For every military slot a government has, divide that by two and increment the number
-- of wildcard slots by that amount. This is because the game lists governments in tiers
-- ordered solely by number of slots. If we simply delete military slots, governments are
-- no longer in the proper tier. We divide by two because otherwise the governments with
-- more military slots become better than those without.
WITH MilitarySlots AS (
    SELECT GovernmentType, NumSlots AS MilitaryNumSlots
    FROM Government_SlotCounts
    WHERE GovernmentSlotType = 'SLOT_MILITARY'
)
UPDATE Government_SlotCounts
SET NumSlots = NumSlots + IFNULL((
    SELECT MilitaryNumSlots / 2
    FROM MilitarySlots
    WHERE MilitarySlots.GovernmentType = Government_SlotCounts.GovernmentType
), 0)
WHERE GovernmentSlotType = 'SLOT_WILDCARD';

-- TODO: validate this
-- UPDATE Government_SlotCounts SET NumSlots = 0 WHERE GovernmentSlotType = 'SLOT_MILITARY';
DELETE FROM Government_SlotCounts WHERE GovernmentSlotType = 'SLOT_MILITARY';

-- These can only be built by the military engineer, but they only serve military purposes
-- so by deleting them we may be able to delete more technologies
-- Airstrip
DELETE FROM Improvements WHERE AirSlots > 0;
-- Missile silo
DELETE FROM Improvements WHERE WeaponSlots > 0;
-- Forts
DELETE FROM Improvements WHERE DefenseModifier > 0 AND PlunderType= 'NO_PLUNDER';

DELETE FROM Policies WHERE GovernmentSlotType = 'SLOT_MILITARY';

-- When all military units are deleted, the game crashes when ending the first turn. It's
-- not clear why; maybe the game has hard-coded logic for unit movement that expects at
-- least on unit? It only seems to happen in the ancient era, which is the only starting
-- era with no units (after military units are deleted).
INSERT INTO MajorStartingUnits (Era, Unit, NotStartTile)
  VALUES ('ERA_ANCIENT', 'UNIT_SCOUT', 1);

-- Remove policies that give great general/admiral points
-- Get all ModifierIds from ModifierArguments where Value = 'GREAT_PERSON_CLASS_GENERAL'
WITH MilitaryModifierIds AS (
    SELECT ModifierId
    FROM ModifierArguments
    WHERE Value = 'GREAT_PERSON_CLASS_GENERAL' OR Value = 'GREAT_PERSON_CLASS_ADMIRAL'
),
-- Get PolicyTypes from PolicyModifiers where ModifierId is in the previous query
MilitaryPolicyTypes AS (
    SELECT PolicyType
    FROM PolicyModifiers
    WHERE ModifierId IN (SELECT ModifierId FROM MilitaryModifierIds)
)
-- Delete all policies from Policies where PolicyType matches the previous query
DELETE FROM Policies
WHERE PolicyType IN (SELECT PolicyType FROM MilitaryPolicyTypes);

-- This primarily disables nukes, among other things
DELETE FROM Projects WHERE AdvisorType = 'ADVISOR_CONQUEST';

-- TODO: Should we exclude military engineer from deletion? It's the only unit that can build roads.
DELETE FROM Units WHERE AdvisorType = 'ADVISOR_CONQUEST';
UPDATE Units SET Combat = 0 WHERE UnitType = 'UNIT_SCOUT';
