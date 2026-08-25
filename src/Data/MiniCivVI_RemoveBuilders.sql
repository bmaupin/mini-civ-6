-- When improvements are deleted, the entry in ImprovementModifiers is deleted but not
-- the modifier itself
DELETE FROM Modifiers
WHERE ModifierId IN (
  SELECT ModifierId
  FROM ImprovementModifiers
  WHERE ImprovementType NOT IN (
    'IMPROVEMENT_BARBARIAN_CAMP',
    'IMPROVEMENT_FARM',
    'IMPROVEMENT_GOODY_HUT'
    'IMPROVEMENT_LUMBER_MILL',
    'IMPROVEMENT_MINE'
  ) AND ImprovementType NOT IN (
    SELECT ImprovementType FROM Improvement_ValidResources
  )
);

-- Delete all improvements besides the ones we're automating
DELETE FROM Improvements
WHERE ImprovementType NOT IN (
  'IMPROVEMENT_LUMBER_MILL',
  'IMPROVEMENT_MINE',
  'IMPROVEMENT_FARM'
) AND ImprovementType NOT IN (
  SELECT ImprovementType FROM Improvement_ValidResources
);

DELETE FROM Types
WHERE Type = 'UNIT_BUILDER';
