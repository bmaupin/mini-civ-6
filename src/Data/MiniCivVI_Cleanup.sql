-- If the Jong is the only unlock for the mercenaries civic, set its prerequisite to match
-- the unit it replaces (frigate) so the mercenaries civic can be deleted, otherwise it
-- will show up for all civs except Indonesia as having no unlocks.
WITH Unlocks AS (
  SELECT UnitType AS UnlockType FROM Units WHERE PrereqCivic = 'CIVIC_MERCENARIES'
  UNION ALL
  SELECT BuildingType FROM Buildings WHERE PrereqCivic = 'CIVIC_MERCENARIES'
  UNION ALL
  SELECT DistrictType FROM Districts WHERE PrereqCivic = 'CIVIC_MERCENARIES'
  UNION ALL
  SELECT GovernmentType FROM Governments WHERE PrereqCivic = 'CIVIC_MERCENARIES'
  UNION ALL
  SELECT ImprovementType FROM Improvements WHERE PrereqCivic = 'CIVIC_MERCENARIES'
  UNION ALL
  SELECT ImprovementType FROM Improvement_BonusYieldChanges WHERE PrereqCivic = 'CIVIC_MERCENARIES'
  UNION ALL
  SELECT ImprovementType FROM Improvement_Tourism WHERE PrereqCivic = 'CIVIC_MERCENARIES'
  UNION ALL
  SELECT ImprovementType FROM Improvement_ValidFeatures WHERE PrereqCivic = 'CIVIC_MERCENARIES'
  UNION ALL
  SELECT ImprovementType FROM Improvement_ValidTerrains WHERE PrereqCivic = 'CIVIC_MERCENARIES'
  UNION ALL
  SELECT PolicyType FROM Policies WHERE PrereqCivic = 'CIVIC_MERCENARIES'
  UNION ALL
  SELECT ProjectType FROM Projects WHERE PrereqCivic = 'CIVIC_MERCENARIES'
  UNION ALL
  SELECT ResourceType FROM Resources WHERE PrereqCivic = 'CIVIC_MERCENARIES'
  UNION ALL
  SELECT CommandType FROM UnitCommands WHERE PrereqCivic = 'CIVIC_MERCENARIES'
  UNION ALL
  SELECT OperationType FROM UnitOperations WHERE PrereqCivic = 'CIVIC_MERCENARIES'
  UNION ALL
  SELECT ID FROM Adjacency_YieldChanges WHERE PrereqCivic = 'CIVIC_MERCENARIES'
)
UPDATE Units
SET PrereqCivic = NULL,
    PrereqTech = 'TECH_SQUARE_RIGGING'
WHERE UnitType = 'UNIT_INDONESIAN_JONG'
  AND (SELECT COUNT(*) FROM Unlocks) = 1
  AND (SELECT UnlockType FROM Unlocks LIMIT 1) = 'UNIT_INDONESIAN_JONG';

-- Do something similar for craftsmanship, except in this case it unlocks improvements
-- and one of the improvements is only installed with Rise and Fall.
WITH Unlocks AS (
  SELECT ImprovementType AS UnlockType FROM Improvements WHERE PrereqCivic = 'CIVIC_CRAFTSMANSHIP'
  UNION ALL
  SELECT ImprovementType FROM Improvement_BonusYieldChanges WHERE PrereqCivic = 'CIVIC_CRAFTSMANSHIP'
  UNION ALL
  SELECT ImprovementType FROM Improvement_Tourism WHERE PrereqCivic = 'CIVIC_CRAFTSMANSHIP'
  UNION ALL
  SELECT ImprovementType FROM Improvement_ValidFeatures WHERE PrereqCivic = 'CIVIC_CRAFTSMANSHIP'
  UNION ALL
  SELECT ImprovementType FROM Improvement_ValidTerrains WHERE PrereqCivic = 'CIVIC_CRAFTSMANSHIP'
  UNION ALL
  SELECT PolicyType FROM Policies WHERE PrereqCivic = 'CIVIC_CRAFTSMANSHIP'
  UNION ALL
  SELECT ProjectType FROM Projects WHERE PrereqCivic = 'CIVIC_CRAFTSMANSHIP'
  UNION ALL
  SELECT ResourceType FROM Resources WHERE PrereqCivic = 'CIVIC_CRAFTSMANSHIP'
  UNION ALL
  SELECT CommandType FROM UnitCommands WHERE PrereqCivic = 'CIVIC_CRAFTSMANSHIP'
  UNION ALL
  SELECT OperationType FROM UnitOperations WHERE PrereqCivic = 'CIVIC_CRAFTSMANSHIP'
  UNION ALL
  SELECT ID FROM Adjacency_YieldChanges WHERE PrereqCivic = 'CIVIC_CRAFTSMANSHIP'
)
UPDATE Improvements
SET PrereqCivic = NULL,
    PrereqTech = 'TECH_MASONRY'
WHERE ImprovementType IN ('IMPROVEMENT_SPHINX', 'IMPROVEMENT_CHEMAMULL')
  AND (
    SELECT COUNT(*) FROM Unlocks
  ) = (
    SELECT COUNT(*) FROM Unlocks WHERE UnlockType IN ('IMPROVEMENT_SPHINX', 'IMPROVEMENT_CHEMAMULL')
  )
  AND EXISTS (
    SELECT 1 FROM Unlocks WHERE UnlockType = 'IMPROVEMENT_SPHINX'
  );

-- Delete civics that no longer grant any unlocks due to the unlocks having been deleted,
-- for example policies, governments (religious, military, etc), units, etc.
DELETE FROM Civics WHERE
  -- This excludes CIVIC_FUTURE_CIVIC, which is special
  Repeatable != 1 AND
  CivicType NOT IN (
    SELECT CivicType FROM CivicModifiers
  ) AND
  CivicType NOT IN (
    SELECT PrereqCivic FROM Adjacency_YieldChanges WHERE PrereqCivic IS NOT NULL
    UNION
    SELECT PrereqCivic FROM Buildings WHERE PrereqCivic IS NOT NULL
    UNION
    SELECT InitiatorPrereqCivic FROM DiplomaticActions WHERE InitiatorPrereqCivic IS NOT NULL
    UNION
    SELECT PrereqCivic FROM Districts WHERE PrereqCivic IS NOT NULL
    UNION
    SELECT PrereqCivic FROM Governments WHERE PrereqCivic IS NOT NULL
    UNION
    SELECT PrereqCivic FROM Improvements WHERE PrereqCivic IS NOT NULL
    UNION
    SELECT PrereqCivic FROM Improvement_BonusYieldChanges WHERE PrereqCivic IS NOT NULL
    UNION
    SELECT PrereqCivic FROM Improvement_Tourism WHERE PrereqCivic IS NOT NULL
    UNION
    SELECT PrereqCivic FROM Improvement_ValidFeatures WHERE PrereqCivic IS NOT NULL
    UNION
    SELECT PrereqCivic FROM Improvement_ValidTerrains WHERE PrereqCivic IS NOT NULL
    UNION
    SELECT PrereqCivic FROM Policies WHERE PrereqCivic IS NOT NULL
    UNION
    SELECT PrereqCivic FROM Projects WHERE PrereqCivic IS NOT NULL
    UNION
    SELECT PrereqCivic FROM Resources WHERE PrereqCivic IS NOT NULL
    UNION
    SELECT PrereqCivic FROM Units WHERE PrereqCivic IS NOT NULL
    UNION
    SELECT PrereqCivic FROM UnitCommands WHERE PrereqCivic IS NOT NULL
    UNION
    SELECT PrereqCivic FROM UnitOperations WHERE PrereqCivic IS NOT NULL
  );

-- If craftsmanship got deleted, military tradition's prerequisite gets deleted. Add a new
-- one so military tradition doesn't get orphaned
INSERT INTO CivicPrereqs (Civic, PrereqCivic)
SELECT 'CIVIC_MILITARY_TRADITION', 'CIVIC_CODE_OF_LAWS'
WHERE EXISTS (
  SELECT 1 FROM Civics WHERE CivicType = 'CIVIC_MILITARY_TRADITION'
)
AND NOT EXISTS (
  SELECT 1 FROM CivicPrereqs WHERE Civic = 'CIVIC_MILITARY_TRADITION'
);

INSERT INTO CivicPrereqs (Civic, PrereqCivic)
SELECT 'CIVIC_NATURAL_HISTORY', 'CIVIC_MERCANTILISM'
WHERE NOT EXISTS (
  SELECT 1 FROM CivicPrereqs WHERE Civic = 'CIVIC_COLONIALISM'
);

-- Store all tech prerequisites before deleting technologies. We will use this later to
-- set new prerequisites.
CREATE TEMP TABLE IF NOT EXISTS OriginalTechPrereqs AS
  SELECT Technology, PrereqTech FROM TechnologyPrereqs;

DELETE FROM Technologies WHERE
  -- This excludes TECH_FUTURE_TECH, which is special
  Repeatable != 1 AND
  TechnologyType NOT IN (
    SELECT TechnologyType FROM TechnologyModifiers
  ) AND
  TechnologyType NOT IN (
    SELECT PrereqTech FROM Adjacency_YieldChanges WHERE PrereqTech IS NOT NULL
    UNION
    SELECT PrereqTech FROM Buildings WHERE PrereqTech IS NOT NULL
    UNION
    SELECT InitiatorPrereqTech FROM DiplomaticActions WHERE InitiatorPrereqTech IS NOT NULL
    UNION
    SELECT PrereqTech FROM DiplomaticVisibilitySources WHERE PrereqTech IS NOT NULL
    UNION
    SELECT PrereqTech FROM Districts WHERE PrereqTech IS NOT NULL
    UNION
    SELECT PrereqTech FROM Improvements WHERE PrereqTech IS NOT NULL
    UNION
    SELECT PrereqTech FROM Improvement_BonusYieldChanges WHERE PrereqTech IS NOT NULL
    UNION
    SELECT PrereqTech FROM Improvement_Tourism WHERE PrereqTech IS NOT NULL
    UNION
    SELECT PrereqTech FROM Improvement_ValidFeatures WHERE PrereqTech IS NOT NULL
    UNION
    SELECT PrereqTech FROM Improvement_ValidTerrains WHERE PrereqTech IS NOT NULL
    UNION
    SELECT PrereqTech FROM Policies WHERE PrereqTech IS NOT NULL
    UNION
    SELECT PrereqTech FROM Projects WHERE PrereqTech IS NOT NULL
    UNION
    SELECT PrereqTech FROM Resources WHERE PrereqTech IS NOT NULL
    UNION
    SELECT PrereqTech FROM Resource_Harvests WHERE PrereqTech IS NOT NULL
    UNION
    SELECT PrereqTech FROM Units WHERE PrereqTech IS NOT NULL
    UNION
    SELECT PrereqTech FROM UnitCommands WHERE PrereqTech IS NOT NULL
    UNION
    SELECT PrereqTech FROM UnitOperations WHERE PrereqTech IS NOT NULL
  );

-- Add new prerequisites for orphaned techs (whose prerequisites got deleted)
--
-- For each orphaned tech, we manually add a prerequisite from the immediate previous era
-- (ideally one that makes sense as best as possible) so that the prerequisite doesn't
-- cross more than one era
INSERT INTO TechnologyPrereqs (Technology, PrereqTech)
SELECT 'TECH_STIRRUPS', 'TECH_APPRENTICESHIP'
-- Validate that both techs exist
WHERE EXISTS (
  SELECT 1 FROM Technologies WHERE TechnologyType = 'TECH_STIRRUPS'
)
AND EXISTS (
  SELECT 1 FROM Technologies WHERE TechnologyType = 'TECH_APPRENTICESHIP'
)
-- Only do this if this tech has no prereqs
AND NOT EXISTS (
  SELECT 1 FROM TechnologyPrereqs WHERE Technology = 'TECH_STIRRUPS'
);

INSERT INTO TechnologyPrereqs (Technology, PrereqTech)
SELECT 'TECH_MILITARY_ENGINEERING', 'TECH_APPRENTICESHIP'
WHERE EXISTS (
  SELECT 1 FROM Technologies WHERE TechnologyType = 'TECH_MILITARY_ENGINEERING'
)
AND EXISTS (
  SELECT 1 FROM Technologies WHERE TechnologyType = 'TECH_APPRENTICESHIP'
)
AND NOT EXISTS (
  SELECT 1 FROM TechnologyPrereqs WHERE Technology = 'TECH_MILITARY_ENGINEERING'
);

INSERT INTO TechnologyPrereqs (Technology, PrereqTech)
SELECT 'TECH_CASTLES', 'TECH_APPRENTICESHIP'
WHERE EXISTS (
  SELECT 1 FROM Technologies WHERE TechnologyType = 'TECH_CASTLES'
)
AND EXISTS (
  SELECT 1 FROM Technologies WHERE TechnologyType = 'TECH_APPRENTICESHIP'
)
AND NOT EXISTS (
  SELECT 1 FROM TechnologyPrereqs WHERE Technology = 'TECH_CASTLES'
);

INSERT INTO TechnologyPrereqs (Technology, PrereqTech)
SELECT 'TECH_STEEL', 'TECH_ECONOMICS'
WHERE EXISTS (
  SELECT 1 FROM Technologies WHERE TechnologyType = 'TECH_STEEL'
)
AND EXISTS (
  SELECT 1 FROM Technologies WHERE TechnologyType = 'TECH_ECONOMICS'
)
AND NOT EXISTS (
  SELECT 1 FROM TechnologyPrereqs WHERE Technology = 'TECH_STEEL'
);

INSERT INTO TechnologyPrereqs (Technology, PrereqTech)
SELECT 'TECH_STEEL', 'TECH_ECONOMICS'
WHERE EXISTS (
  SELECT 1 FROM Technologies WHERE TechnologyType = 'TECH_STEEL'
)
AND EXISTS (
  SELECT 1 FROM Technologies WHERE TechnologyType = 'TECH_ECONOMICS'
)
AND NOT EXISTS (
  SELECT 1 FROM TechnologyPrereqs WHERE Technology = 'TECH_STEEL'
);

INSERT INTO TechnologyPrereqs (Technology, PrereqTech)
SELECT 'TECH_NUCLEAR_FUSION', 'TECH_SATELLITES'
WHERE EXISTS (
  SELECT 1 FROM Technologies WHERE TechnologyType = 'TECH_NUCLEAR_FUSION'
)
AND EXISTS (
  SELECT 1 FROM Technologies WHERE TechnologyType = 'TECH_SATELLITES'
)
AND NOT EXISTS (
  SELECT 1 FROM TechnologyPrereqs WHERE Technology = 'TECH_NUCLEAR_FUSION'
);

INSERT INTO TechnologyPrereqs (Technology, PrereqTech)
SELECT 'TECH_NANOTECHNOLOGY', 'TECH_SATELLITES'
WHERE EXISTS (
  SELECT 1 FROM Technologies WHERE TechnologyType = 'TECH_NANOTECHNOLOGY'
)
AND EXISTS (
  SELECT 1 FROM Technologies WHERE TechnologyType = 'TECH_SATELLITES'
)
AND NOT EXISTS (
  SELECT 1 FROM TechnologyPrereqs WHERE Technology = 'TECH_NANOTECHNOLOGY'
);

-- Add new prereqs to fix dead-ends (techs that were a prereq for a deleted tech)
--
-- For orphaned techs, we manually added prereqs to make sure that they didn't cross more
-- than one era. But for dead-end techs we can do this in a more automated fashion, by
-- re-creating the tech dependencies minus the deleted techs. In many cases the prereqs
-- will cross multiple eras but in this case it's not an issues as the techs with the new
-- prereqs will always have at least one prereq that doesn't cross more than one era. This
-- should also serve as a best effort to fix both orphaned and dead-end techs in case this
-- mod is used with other mods that add new techs.
--
-- Identify all dead-end technoloogies
WITH DeadEndTechnologies AS (
  SELECT TechnologyType
  FROM Technologies
  WHERE TechnologyType NOT IN (
    SELECT PrereqTech
    FROM TechnologyPrereqs
  )
  AND TechnologyType IN (
    SELECT PrereqTech
    FROM OriginalTechPrereqs
  )
),
ResolvedPrereqs AS (
  -- Start by getting deleted technologies for which the dead-end technologies were a
  -- prerequisite
  SELECT otp.PrereqTech, otp.Technology
  FROM OriginalTechPrereqs otp
  WHERE otp.PrereqTech IN (SELECT TechnologyType FROM DeadEndTechnologies)
    AND otp.Technology NOT IN (SELECT TechnologyType FROM Technologies)

  UNION ALL

  -- For each of those technologies, figure out what they were a prerequisite of. This
  -- query will run recursively until we get to a technology that hasn't been deleted.
  SELECT rp.PrereqTech, otp.Technology
  FROM ResolvedPrereqs rp
  JOIN OriginalTechPrereqs otp ON rp.Technology = otp.PrereqTech
  WHERE otp.PrereqTech NOT IN (SELECT TechnologyType FROM Technologies)
    AND otp.Technology NOT IN (SELECT Technology FROM TechnologyPrereqs)
)
INSERT INTO TechnologyPrereqs (Technology, PrereqTech)
SELECT DISTINCT
  Technology,
  PrereqTech
FROM
(
  SELECT *, MIN(Technology) FROM ResolvedPrereqs
  -- Sanity checks to make sure tech and prereq haven't been deleted
  WHERE PrereqTech IN (SELECT TechnologyType FROM Technologies)
  AND Technology IN (SELECT TechnologyType FROM Technologies)
  -- Sanity check to make sure we don't insert a duplicate prereq
  AND NOT EXISTS (
    SELECT 1
    FROM TechnologyPrereqs tp
    WHERE tp.Technology = ResolvedPrereqs.Technology
      AND tp.PrereqTech = ResolvedPrereqs.PrereqTech
  )
  GROUP BY PrereqTech
);

DROP TABLE IF EXISTS OriginalTechPrereqs;
