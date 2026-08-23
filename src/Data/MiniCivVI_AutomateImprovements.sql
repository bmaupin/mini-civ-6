-- Remove improvements from builders that we're automating for features and terrains
DELETE FROM Improvement_ValidBuildUnits
WHERE ImprovementType IN (
  'IMPROVEMENT_LUMBER_MILL',
  'IMPROVEMENT_MINE',
  'IMPROVEMENT_FARM'
);

-- Remove improvements from builders that we're automating for resources
DELETE FROM Improvement_ValidBuildUnits
WHERE ImprovementType IN (
  SELECT DISTINCT ImprovementType FROM Improvement_ValidResources
);

-- Allows farms to be built on grass/plains hills, but we're not automating this
DELETE FROM Improvement_ValidTerrains
WHERE PrereqCivic = 'CIVIC_CIVIL_ENGINEERING';
