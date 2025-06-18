-- NOTE: Index is a reserved keyword so it has to be escaped with double quotes
--       (single quotes won't work)
INSERT OR REPLACE INTO IconDefinitions (Name, Atlas, "Index")
SELECT 'ICON_GAMESPEED_STANDARD_CUSTOM', Atlas, "Index"
FROM IconDefinitions WHERE Name = 'ICON_GAMESPEED_STANDARD';
