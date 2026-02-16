--**************************************************************************************************************************
--   Zegangani's
-- CUSTOMIZATION VI
--**************************************************************************************************************************

UPDATE GlobalParameters SET Value = -40 WHERE Name = 'BARBARIAN_BOLDNESS_PER_CAMP_ATTACK';

UPDATE GlobalParameters SET Value = 5 WHERE Name = 'BARBARIAN_BOLDNESS_PER_KILL';

UPDATE GlobalParameters SET Value = 0 WHERE Name = 'BARBARIAN_BOLDNESS_PER_TURN';

UPDATE GlobalParameters SET Value = 8 WHERE Name = 'BARBARIAN_CAMP_MINIMUM_DISTANCE_ANOTHER_CAMP';

UPDATE GlobalParameters SET Value = 6 WHERE Name = 'BARBARIAN_CAMP_MINIMUM_DISTANCE_CITY';

UPDATE GlobalParameters SET Value = 25 WHERE Name = 'BARBARIAN_TECH_PERCENT';

UPDATE GlobalParameters SET Value = 4 WHERE Name = 'BARBARIAN_LOWER_THROTTLE_PER_DIFFICULTY';

UPDATE GlobalParameters SET Value = 12 WHERE Name = 'BARBARIAN_MAX_THROTTLE_PER_RAID';

UPDATE BarbarianTribeNames
SET NumMilitary = 4;

UPDATE BarbarianTribes SET PercentRangedUnits = PercentRangedUnits-5, RaidingBoldness = RaidingBoldness-5, CityAttackBoldness = CityAttackBoldness-10;
UPDATE BarbarianTribes SET TurnsToWarriorSpawn = 13 WHERE TribeType LIKE "%NAVAL%";
--UPDATE BarbarianTribes SET TurnsToWarriorSpawn = 30 WHERE TribeType LIKE "%CAVALRY%";
UPDATE BarbarianTribes SET TurnsToWarriorSpawn = 17 WHERE TribeType LIKE "%MELEE%";

UPDATE BarbarianAttackForces SET NumMeleeUnits = NumMeleeUnits - 1 WHERE NumMeleeUnits > 1;
UPDATE BarbarianAttackForces SET NumRangeUnits = NumRangeUnits - 1 WHERE NumRangeUnits > 1;
UPDATE BarbarianAttackForces SET NumSiegeUnits = NumSiegeUnits - 1 WHERE NumSiegeUnits > 1;