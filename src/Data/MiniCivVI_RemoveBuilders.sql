-- Delete all improvement adjacencies; if builders are removed, improvements are totally
-- out of our control. This allows us to more or less ignore them.
--
-- Deleting Adjacency_YieldChanges will propagate deletions to Improvement_Adjacencies
DELETE FROM Adjacency_YieldChanges;

-- When improvements are deleted, the entry in ImprovementModifiers is deleted but not
-- the modifier itself
DELETE FROM Modifiers
WHERE ModifierId IN (
  SELECT ModifierId
  FROM ImprovementModifiers
  WHERE ImprovementType NOT IN (
    'IMPROVEMENT_BARBARIAN_CAMP',
    'IMPROVEMENT_FARM',
    'IMPROVEMENT_GOODY_HUT',
    'IMPROVEMENT_LUMBER_MILL',
    'IMPROVEMENT_MINE'
  ) AND ImprovementType NOT IN (
    SELECT ImprovementType FROM Improvement_ValidResources
  )
);

-- Delete all improvements besides the ones we're automating
DELETE FROM Improvements
WHERE ImprovementType NOT IN (
  'IMPROVEMENT_BARBARIAN_CAMP',
  'IMPROVEMENT_FARM',
  'IMPROVEMENT_GOODY_HUT',
  'IMPROVEMENT_LUMBER_MILL',
  'IMPROVEMENT_MINE'
) AND ImprovementType NOT IN (
  SELECT ImprovementType FROM Improvement_ValidResources
);

DELETE FROM Types
WHERE Type = 'UNIT_BUILDER';

-- Delete tech descriptions that are no longer inaccurate. Techs don't need a description
-- and many techs don't have one; without it they just show what they unlock
UPDATE Technologies
SET Description = NULL
WHERE TechnologyType IN (
  -- Farms get adjacency bonus ("mechanised agriculture")
  'TECH_REPLACEABLE_PARTS',
  -- "Allows Builders to embark."
  'TECH_SAILING'
);
