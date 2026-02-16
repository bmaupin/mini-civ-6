-- NOTE: It seems the default game speed (standard) is hard-coded into the game,
--       so the only way to override it is to exclude it from the query that
--       populates the game speeds in the game options. Then we copy the standard
--       game speed parameter to a new custom parameter and similarly (in another
--       file since we can't modify GameData here) also copy the actual game speed
--       data so that our new custom standard game speed will still work if
--       selected.
UPDATE Parameters
SET DefaultValue = 'GAMESPEED_ONLINE'
WHERE ParameterId = 'GameSpeeds'
  AND SupportsSinglePlayer = 1;

-- Copy the standard game speed (from Configuration database, not Gameplay)
INSERT OR REPLACE INTO GameSpeeds (GameSpeedType, Name, Description, SortIndex)
SELECT 'GAMESPEED_STANDARD_CUSTOM', Name, Description, SortIndex
FROM GameSpeeds WHERE GameSpeedType = 'GAMESPEED_STANDARD';

-- Update the query that gets game speeds to exclude the built-in standard game speed
UPDATE Queries
SET SQL = 'SELECT Domain, Name, Description, GameSpeedType AS Value, SortIndex FROM GameSpeeds WHERE GameSpeedType != ''GAMESPEED_STANDARD'''
WHERE QueryId = 'GameSpeeds';


UPDATE Parameters
SET DefaultValue = 'MAPSIZE_TINY'
WHERE ParameterId = 'MapSize';

INSERT OR REPLACE INTO MapSizes (MapSizeType, Name, Description, MinPlayers, MaxPlayers, DefaultPlayers, MinCityStates, MaxCityStates, DefaultCityStates, SortIndex)
SELECT 'MAPSIZE_SMALL_CUSTOM', Name, Description, MinPlayers, MaxPlayers, DefaultPlayers, MinCityStates, MaxCityStates, DefaultCityStates, SortIndex
FROM MapSizes WHERE MapSizeType = 'MAPSIZE_SMALL';

UPDATE Queries
SET SQL = 'SELECT Domain, Name, Description, MapSizeType AS Value, SortIndex FROM MapSizes WHERE MapSizeType != ''MAPSIZE_SMALL'''
WHERE QueryId = 'MapSizes';
