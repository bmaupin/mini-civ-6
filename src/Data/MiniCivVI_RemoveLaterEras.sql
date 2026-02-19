CREATE TEMP TABLE ErasToRemove (
  EraType TEXT PRIMARY KEY
);

INSERT INTO ErasToRemove (EraType) VALUES
  ('ERA_RENAISSANCE'),
  ('ERA_INDUSTRIAL'),
  ('ERA_MODERN'),
  ('ERA_ATOMIC'),
  ('ERA_INFORMATION'),
  ('ERA_FUTURE');

DELETE FROM Adjacency_YieldChanges
WHERE PrereqCivic IN (
  SELECT CivicType FROM Civics
  WHERE EraType IN (SELECT EraType FROM ErasToRemove)
);

DELETE FROM Buildings
WHERE PrereqCivic IN (
  SELECT CivicType FROM Civics
  WHERE EraType IN (SELECT EraType FROM ErasToRemove)
);

DELETE FROM Districts
WHERE PrereqCivic IN (
  SELECT CivicType FROM Civics
  WHERE EraType IN (SELECT EraType FROM ErasToRemove)
);

DELETE FROM Governments
WHERE PrereqCivic IN (
  SELECT CivicType FROM Civics
  WHERE EraType IN (SELECT EraType FROM ErasToRemove)
);

DELETE FROM Improvements
WHERE PrereqCivic IN (
  SELECT CivicType FROM Civics
  WHERE EraType IN (SELECT EraType FROM ErasToRemove)
);

DELETE FROM Policies
WHERE PrereqCivic IN (
  SELECT CivicType FROM Civics
  WHERE EraType IN (SELECT EraType FROM ErasToRemove)
);

DELETE FROM Projects
WHERE PrereqCivic IN (
  SELECT CivicType FROM Civics
  WHERE EraType IN (SELECT EraType FROM ErasToRemove)
);

DELETE FROM Resources
WHERE PrereqCivic IN (
  SELECT CivicType FROM Civics
  WHERE EraType IN (SELECT EraType FROM ErasToRemove)
);

DELETE FROM Units
WHERE PrereqCivic IN (
  SELECT CivicType FROM Civics
  WHERE EraType IN (SELECT EraType FROM ErasToRemove)
);

-- Don't delete diplomatic actions obsoleted by civics that will be removed
UPDATE DiplomaticActions
SET InitiatorObsoleteCivic = NULL
WHERE InitiatorObsoleteCivic IN (
  SELECT CivicType FROM Civics
  WHERE EraType IN (SELECT EraType FROM ErasToRemove)
);

DELETE FROM Civics
-- This excludes CIVIC_FUTURE_CIVIC, which is special
WHERE Repeatable != 1
  AND EraType IN (SELECT EraType FROM ErasToRemove);

INSERT INTO CivicPrereqs (Civic, PrereqCivic)
SELECT 'CIVIC_FUTURE_CIVIC', 'CIVIC_MEDIEVAL_FAIRES'
WHERE EXISTS (
  SELECT 1 FROM Civics WHERE CivicType = 'CIVIC_FUTURE_CIVIC'
)
AND EXISTS (
  SELECT 1 FROM Civics WHERE CivicType = 'CIVIC_MEDIEVAL_FAIRES'
);

INSERT INTO CivicPrereqs (Civic, PrereqCivic)
SELECT 'CIVIC_FUTURE_CIVIC', 'CIVIC_DIVINE_RIGHT'
WHERE EXISTS (
  SELECT 1 FROM Civics WHERE CivicType = 'CIVIC_FUTURE_CIVIC'
)
AND EXISTS (
  SELECT 1 FROM Civics WHERE CivicType = 'CIVIC_DIVINE_RIGHT'
);

INSERT INTO CivicPrereqs (Civic, PrereqCivic)
SELECT 'CIVIC_FUTURE_CIVIC', 'CIVIC_GUILDS'
WHERE EXISTS (
  SELECT 1 FROM Civics WHERE CivicType = 'CIVIC_FUTURE_CIVIC'
)
AND EXISTS (
  SELECT 1 FROM Civics WHERE CivicType = 'CIVIC_GUILDS'
);


DELETE FROM Adjacency_YieldChanges
WHERE PrereqTech IN (
  SELECT TechnologyType FROM Technologies
  WHERE EraType IN (SELECT EraType FROM ErasToRemove)
);

DELETE FROM Buildings
WHERE PrereqTech IN (
  SELECT TechnologyType FROM Technologies
  WHERE EraType IN (SELECT EraType FROM ErasToRemove)
);

DELETE FROM Districts
WHERE PrereqTech IN (
  SELECT TechnologyType FROM Technologies
  WHERE EraType IN (SELECT EraType FROM ErasToRemove)
);

DELETE FROM Improvements
WHERE PrereqTech IN (
  SELECT TechnologyType FROM Technologies
  WHERE EraType IN (SELECT EraType FROM ErasToRemove)
);

DELETE FROM Projects
WHERE PrereqTech IN (
  SELECT TechnologyType FROM Technologies
  WHERE EraType IN (SELECT EraType FROM ErasToRemove)
);

DELETE FROM Resources
WHERE PrereqTech IN (
  SELECT TechnologyType FROM Technologies
  WHERE EraType IN (SELECT EraType FROM ErasToRemove)
);

DELETE FROM Resource_Harvests
WHERE PrereqTech IN (
  SELECT TechnologyType FROM Technologies
  WHERE EraType IN (SELECT EraType FROM ErasToRemove)
);

DELETE FROM Units
WHERE PrereqTech IN (
  SELECT TechnologyType FROM Technologies
  WHERE EraType IN (SELECT EraType FROM ErasToRemove)
);

DELETE FROM Technologies
-- This excludes TECH_FUTURE_TECH, which is special
WHERE Repeatable != 1
  AND EraType IN (SELECT EraType FROM ErasToRemove);

INSERT INTO TechnologyPrereqs (Technology, PrereqTech)
SELECT 'TECH_FUTURE_TECH', 'TECH_EDUCATION'
-- Validate that both techs exist
WHERE EXISTS (
  SELECT 1 FROM Technologies WHERE TechnologyType = 'TECH_FUTURE_TECH'
)
AND EXISTS (
  SELECT 1 FROM Technologies WHERE TechnologyType = 'TECH_EDUCATION'
);

INSERT INTO TechnologyPrereqs (Technology, PrereqTech)
SELECT 'TECH_FUTURE_TECH', 'TECH_STIRRUPS'
-- Validate that both techs exist
WHERE EXISTS (
  SELECT 1 FROM Technologies WHERE TechnologyType = 'TECH_FUTURE_TECH'
)
AND EXISTS (
  SELECT 1 FROM Technologies WHERE TechnologyType = 'TECH_STIRRUPS'
);

INSERT INTO TechnologyPrereqs (Technology, PrereqTech)
SELECT 'TECH_FUTURE_TECH', 'TECH_MILITARY_ENGINEERING'
-- Validate that both techs exist
WHERE EXISTS (
  SELECT 1 FROM Technologies WHERE TechnologyType = 'TECH_FUTURE_TECH'
)
AND EXISTS (
  SELECT 1 FROM Technologies WHERE TechnologyType = 'TECH_MILITARY_ENGINEERING'
);

INSERT INTO TechnologyPrereqs (Technology, PrereqTech)
SELECT 'TECH_FUTURE_TECH', 'TECH_CASTLES'
-- Validate that both techs exist
WHERE EXISTS (
  SELECT 1 FROM Technologies WHERE TechnologyType = 'TECH_FUTURE_TECH'
)
AND EXISTS (
  SELECT 1 FROM Technologies WHERE TechnologyType = 'TECH_CASTLES'
);
