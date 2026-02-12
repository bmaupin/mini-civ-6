DELETE FROM Civics WHERE
  -- This excludes CIVIC_FUTURE_CIVIC, which is special
  Repeatable != 1 AND
  EraType NOT IN (
    'ERA_ANCIENT',
    'ERA_CLASSICAL',
    'ERA_MEDIEVAL'
  );

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

DELETE FROM Technologies WHERE
  -- This excludes TECH_FUTURE_TECH, which is special
  Repeatable != 1 AND
  EraType NOT IN (
    'ERA_ANCIENT',
    'ERA_CLASSICAL',
    'ERA_MEDIEVAL'
  );

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