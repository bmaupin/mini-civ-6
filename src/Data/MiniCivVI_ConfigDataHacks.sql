INSERT OR REPLACE INTO Types (Type, Kind)
SELECT 'GAMESPEED_STANDARD_CUSTOM', Kind
FROM Types WHERE Type = 'GAMESPEED_STANDARD';

INSERT OR REPLACE INTO GameSpeeds (
    GameSpeedType, Name, Description,
    CostMultiplier, CivicUnlockMaxCost,
    CivicUnlockPerTurnDrop, CivicUnlockMinCost
)
SELECT
    'GAMESPEED_STANDARD_CUSTOM', Name, Description,
    CostMultiplier, CivicUnlockMaxCost,
    CivicUnlockPerTurnDrop, CivicUnlockMinCost
FROM GameSpeeds
WHERE GameSpeedType = 'GAMESPEED_STANDARD';

INSERT OR REPLACE INTO GameSpeed_Turns (GameSpeedType, MonthIncrement, TurnsPerIncrement)
SELECT 'GAMESPEED_STANDARD_CUSTOM', MonthIncrement, TurnsPerIncrement
FROM GameSpeed_Turns
WHERE GameSpeedType = 'GAMESPEED_STANDARD';


INSERT OR REPLACE INTO Types (Type, Kind)
SELECT 'MAPSIZE_SMALL_CUSTOM', Kind
FROM Types WHERE Type = 'MAPSIZE_SMALL';

INSERT OR REPLACE INTO Maps (
    MapSizeType, Name, Description,
    DefaultPlayers, GridWidth, GridHeight,
    NumNaturalWonders, PlateValue, Continents
)
SELECT
    'MAPSIZE_SMALL_CUSTOM', Name, Description,
    DefaultPlayers, GridWidth, GridHeight,
    NumNaturalWonders, PlateValue, Continents
FROM Maps
WHERE MapSizeType = 'MAPSIZE_SMALL';

INSERT OR REPLACE INTO Map_GreatPersonClasses (
    MapSizeType, GreatPersonClassType, MaxWorldInstances
)
SELECT
    'MAPSIZE_SMALL_CUSTOM', GreatPersonClassType, MaxWorldInstances
FROM Map_GreatPersonClasses
WHERE MapSizeType = 'MAPSIZE_SMALL';
