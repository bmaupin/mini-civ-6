DELETE FROM Types
WHERE Type IN (
  'BUILDING_ORACLE',
  'CAPABILITY_GREAT_PEOPLE',
  -- This only provides gold and great general points, but commercial hub project is a
  -- better fit for just gold
  'PROJECT_ENHANCE_DISTRICT_ENCAMPMENT',
  -- Similarly, this only provides gold and great engineer points
  'PROJECT_ENHANCE_DISTRICT_INDUSTRIAL_ZONE'
);

DELETE FROM Building_GreatPersonPoints;
DELETE FROM Building_GreatWorks;
DELETE FROM District_CitizenGreatPersonPoints;
DELETE FROM District_GreatPersonPoints;
DELETE FROM Project_GreatPersonPoints;

INSERT INTO CivilopediaSectionExcludes
VALUES ('GREATPEOPLE');
