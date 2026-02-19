DELETE FROM Types
WHERE Type = 'BUILDING_ORACLE'
  OR Type = 'CAPABILITY_GREAT_PEOPLE';

DELETE FROM Building_GreatPersonPoints;
DELETE FROM Building_GreatWorks;
DELETE FROM District_CitizenGreatPersonPoints;
DELETE FROM District_GreatPersonPoints;
DELETE FROM Project_GreatPersonPoints;

INSERT INTO CivilopediaSectionExcludes
VALUES ('GREATPEOPLE');
