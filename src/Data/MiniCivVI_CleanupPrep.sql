-- Store all tech prerequisites before deleting civics. We will use this later to
-- set new prerequisites.
CREATE TEMP TABLE IF NOT EXISTS OriginalCivicPrereqs AS
  SELECT Civic, PrereqCivic FROM CivicPrereqs;

-- Store all tech prerequisites before deleting technologies. We will use this later to
-- set new prerequisites.
CREATE TEMP TABLE IF NOT EXISTS OriginalTechPrereqs AS
  SELECT Technology, PrereqTech FROM TechnologyPrereqs;
