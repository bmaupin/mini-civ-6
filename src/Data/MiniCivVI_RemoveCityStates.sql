DELETE FROM Types
WHERE Type IN (
  -- City HUD
  'CAPABILITY_CITY_HUD_AMENITIES_CITY_STATES',
  -- Can the user open city states panel
  'CAPABILITY_CITY_STATES_VIEW',
  -- Do envoys show up on the Top Panel
  'CAPABILITY_TOP_PANEL_ENVOYS',
  'DIPLOACTION_GRANT_INFLUENCE_TOKEN'
);

INSERT INTO CivilopediaSectionExcludes (SectionId)
VALUES ('CITYSTATES');

UPDATE Governments
-- How many points per turn toward earning an envoy
SET InfluencePointsPerTurn = 0,
  -- How many envoys granted once the number of points accumulated equals InfluencePointsThreshold
  InfluenceTokensPerThreshold = 0;

DELETE FROM Modifiers
WHERE ModifierId IN (
  'CIVIC_AWARD_ONE_INFLUENCE_TOKEN',
  'CIVIC_AWARD_TWO_INFLUENCE_TOKENS',
  'CIVIC_AWARD_THREE_INFLUENCE_TOKENS'
);

DELETE FROM RandomAgendas
WHERE AgendaType IN (
  'TRAIT_AGENDA_CITY_STATE_ALLY',
  'TRAIT_AGENDA_PREFER_CITY_STATE_PROTECTOR'
);
