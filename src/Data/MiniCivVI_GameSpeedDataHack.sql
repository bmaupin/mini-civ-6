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