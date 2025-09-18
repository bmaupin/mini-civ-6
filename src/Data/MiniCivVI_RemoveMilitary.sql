-- TODO: Domination victory not disabled in rankings

DELETE FROM Types WHERE Type = 'CAPABILITY_CITY_HUD_AMENITIES_WAR_WEARINESS';
DELETE FROM Types WHERE Type = 'CAPABILITY_GOVERNMENT_SCREEN_MILITARY_FILTER';
DELETE FROM Types WHERE Type = 'CAPABILITY_MILITARY';

DELETE FROM Types WHERE Type = 'GOVERNMENT_OLIGARCHY';
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

-- These can only be built by the military engineer, but they only serve military purposes
-- so by deleting them we may be able to delete more technologies
-- Airstrip
DELETE FROM Improvements WHERE AirSlots > 0;
-- Missile silo
DELETE FROM Improvements WHERE WeaponSlots > 0;
-- Forts
DELETE FROM Improvements WHERE DefenseModifier > 0 AND PlunderType= 'NO_PLUNDER';

DELETE FROM Policies WHERE GovernmentSlotType = 'SLOT_MILITARY';

DELETE FROM RandomAgendas WHERE AgendaType = 'AGENDA_AIRPOWER';
DELETE FROM RandomAgendas WHERE AgendaType = 'AGENDA_CITY_STATE_PROTECTOR';
DELETE FROM RandomAgendas WHERE AgendaType = 'AGENDA_NUKE_LOVER';
DELETE FROM RandomAgendas WHERE AgendaType = 'AGENDA_STANDING_ARMY';
