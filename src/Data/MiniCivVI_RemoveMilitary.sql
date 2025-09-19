-- TODO: Domination victory not disabled in rankings

DELETE FROM Types WHERE Type = 'CAPABILITY_CITY_HUD_AMENITIES_WAR_WEARINESS';
DELETE FROM Types WHERE Type = 'CAPABILITY_GOVERNMENT_SCREEN_MILITARY_FILTER';
DELETE FROM Types WHERE Type = 'CAPABILITY_MILITARY';

-- This is the only government that appears to have purely military effects
DELETE FROM Types WHERE Type = 'GOVERNMENT_OLIGARCHY';
DELETE FROM Types WHERE Type = 'GREAT_PERSON_CLASS_ADMIRAL';
DELETE FROM Types WHERE Type = 'GREAT_PERSON_CLASS_GENERAL';
-- This should delete all military policies
DELETE FROM Types WHERE Type = 'SLOT_MILITARY';
DELETE FROM Types WHERE Type = 'UNIT_GREAT_ADMIRAL';
DELETE FROM Types WHERE Type = 'UNIT_GREAT_GENERAL';

DELETE FROM DiplomaticActions WHERE DiplomaticActionType = 'DIPLOACTION_DECLARE_SURPRISE_WAR';
DELETE FROM DiplomaticActions WHERE DiplomaticActionType = 'DIPLOACTION_DECLARE_WAR_MINOR_CIV';
DELETE FROM DiplomaticActions WHERE UIGroup = 'FORMALWAR';

DELETE FROM Buildings WHERE AdvisorType = 'ADVISOR_CONQUEST';
DELETE FROM Districts WHERE AdvisorType = 'ADVISOR_CONQUEST';
-- This primarily disables nukes, among other things
DELETE FROM Projects WHERE AdvisorType = 'ADVISOR_CONQUEST';
-- TODO: Should we exclude military engineer from deletion? It's the only unit that can build roads.
DELETE FROM Units WHERE AdvisorType = 'ADVISOR_CONQUEST';

UPDATE Units SET Combat = 0 WHERE UnitType = 'UNIT_SCOUT';

-- For every military slot a government has, increment the number of wildcard slots by
-- that amount. This is because the game lists governments in tiers ordered solely by
-- number of slots. If we simply delete military slots, governments are no longer in the
-- proper tier. It also makes the changes slightly more balanced.
WITH MilitarySlots AS (
    SELECT GovernmentType, NumSlots AS MilitaryNumSlots
    FROM Government_SlotCounts
    WHERE GovernmentSlotType = 'SLOT_MILITARY'
)
UPDATE Government_SlotCounts
SET NumSlots = NumSlots + IFNULL((
    SELECT MilitaryNumSlots
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

-- NOTE: This works but is not reflected in the UI of the civics tree
DELETE FROM CivicModifiers WHERE ModifierId = 'CIVIC_GRANT_COMBAT_ADJACENCY_BONUS';

DELETE FROM Policies WHERE GovernmentSlotType = 'SLOT_MILITARY';

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

DELETE FROM RandomAgendas WHERE AgendaType = 'AGENDA_AIRPOWER';
DELETE FROM RandomAgendas WHERE AgendaType = 'AGENDA_CITY_STATE_PROTECTOR';
DELETE FROM RandomAgendas WHERE AgendaType = 'AGENDA_NUKE_LOVER';
DELETE FROM RandomAgendas WHERE AgendaType = 'AGENDA_STANDING_ARMY';
