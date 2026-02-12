DELETE FROM Adjacency_YieldChanges WHERE
  PrereqCivic IN (
    SELECT CivicType FROM Civics WHERE
      EraType NOT IN (
        'ERA_ANCIENT',
        'ERA_CLASSICAL',
        'ERA_MEDIEVAL'
      )
  );

DELETE FROM Buildings WHERE
  PrereqCivic IN (
    SELECT CivicType FROM Civics WHERE
      EraType NOT IN (
        'ERA_ANCIENT',
        'ERA_CLASSICAL',
        'ERA_MEDIEVAL'
      )
  );

DELETE FROM Districts WHERE
  PrereqCivic IN (
    SELECT CivicType FROM Civics WHERE
      EraType NOT IN (
        'ERA_ANCIENT',
        'ERA_CLASSICAL',
        'ERA_MEDIEVAL'
      )
  );

DELETE FROM Governments WHERE
  PrereqCivic IN (
    SELECT CivicType FROM Civics WHERE
      EraType NOT IN (
        'ERA_ANCIENT',
        'ERA_CLASSICAL',
        'ERA_MEDIEVAL'
      )
  );

DELETE FROM Improvements WHERE
  PrereqCivic IN (
    SELECT CivicType FROM Civics WHERE
      EraType NOT IN (
        'ERA_ANCIENT',
        'ERA_CLASSICAL',
        'ERA_MEDIEVAL'
      )
  );

DELETE FROM Policies WHERE
  PrereqCivic IN (
    SELECT CivicType FROM Civics WHERE
      EraType NOT IN (
        'ERA_ANCIENT',
        'ERA_CLASSICAL',
        'ERA_MEDIEVAL'
      )
  );

DELETE FROM Projects WHERE
  PrereqCivic IN (
    SELECT CivicType FROM Civics WHERE
      EraType NOT IN (
        'ERA_ANCIENT',
        'ERA_CLASSICAL',
        'ERA_MEDIEVAL'
      )
  );

DELETE FROM Resources WHERE
  PrereqCivic IN (
    SELECT CivicType FROM Civics WHERE
      EraType NOT IN (
        'ERA_ANCIENT',
        'ERA_CLASSICAL',
        'ERA_MEDIEVAL'
      )
  );

DELETE FROM Units WHERE
  PrereqCivic IN (
    SELECT CivicType FROM Civics WHERE
      EraType NOT IN (
        'ERA_ANCIENT',
        'ERA_CLASSICAL',
        'ERA_MEDIEVAL'
      )
  );

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


DELETE FROM Adjacency_YieldChanges WHERE
  PrereqTech IN (
    SELECT TechnologyType FROM Technologies WHERE
      EraType NOT IN (
        'ERA_ANCIENT',
        'ERA_CLASSICAL',
        'ERA_MEDIEVAL'
      )
  );

DELETE FROM Buildings WHERE
  PrereqTech IN (
    SELECT TechnologyType FROM Technologies WHERE
      EraType NOT IN (
        'ERA_ANCIENT',
        'ERA_CLASSICAL',
        'ERA_MEDIEVAL'
      )
  );

DELETE FROM Districts WHERE
  PrereqTech IN (
    SELECT TechnologyType FROM Technologies WHERE
      EraType NOT IN (
        'ERA_ANCIENT',
        'ERA_CLASSICAL',
        'ERA_MEDIEVAL'
      )
  );

DELETE FROM Improvements WHERE
  PrereqTech IN (
    SELECT TechnologyType FROM Technologies WHERE
      EraType NOT IN (
        'ERA_ANCIENT',
        'ERA_CLASSICAL',
        'ERA_MEDIEVAL'
      )
  );

DELETE FROM Projects WHERE
  PrereqTech IN (
    SELECT TechnologyType FROM Technologies WHERE
      EraType NOT IN (
        'ERA_ANCIENT',
        'ERA_CLASSICAL',
        'ERA_MEDIEVAL'
      )
  );

DELETE FROM Resources WHERE
  PrereqTech IN (
    SELECT TechnologyType FROM Technologies WHERE
      EraType NOT IN (
        'ERA_ANCIENT',
        'ERA_CLASSICAL',
        'ERA_MEDIEVAL'
      )
  );

DELETE FROM Resource_Harvests WHERE
  PrereqTech IN (
    SELECT TechnologyType FROM Technologies WHERE
      EraType NOT IN (
        'ERA_ANCIENT',
        'ERA_CLASSICAL',
        'ERA_MEDIEVAL'
      )
  );

DELETE FROM Units WHERE
  PrereqTech IN (
    SELECT TechnologyType FROM Technologies WHERE
      EraType NOT IN (
        'ERA_ANCIENT',
        'ERA_CLASSICAL',
        'ERA_MEDIEVAL'
      )
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
