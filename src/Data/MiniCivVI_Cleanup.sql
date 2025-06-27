-- Delete civics that no longer grant any unlocks due to the unlocks having been deleted,
-- for example policies, governments (religious, military, etc), units, etc.
DELETE FROM Civics WHERE
  -- This excludes CIVIC_FUTURE_CIVIC, which is special
  Repeatable != 1 AND
  CivicType NOT IN (
    SELECT CivicType FROM CivicModifiers
  ) AND
  CivicType NOT IN (
    SELECT PrereqCivic FROM Policies WHERE PrereqCivic IS NOT NULL
    UNION
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
