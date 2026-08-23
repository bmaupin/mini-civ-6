-- Scale down map sizes for faster gameplay
UPDATE Maps
SET
    GridWidth = CASE
        -- NOTE: If this error is thrown in Lua.log, the map is too small:
        --       Runtime Error: C:\Emu\AppAssets\Base\Assets\maps\utility\assignstartingplots.lua:143: attempt to index a nil value
        --       Duel map size was originally 16x10 but caused the error so it's been
        --       gradually increased (16x12, 18x12, 20x12, 20x14)
        -- Calculate new size, round to nearest INT, then subtract 1 if odd to make sure it's even
        -- Use MAX to set minimum map size; smaller sizes might cause crashes
        WHEN ROUND(GridWidth * 0.45) % 2 = 1
            THEN MAX(20, ROUND(GridWidth * 0.45) - 1)
        ELSE MAX(20, ROUND(GridWidth * 0.45))
    END,
    GridHeight = CASE
        WHEN ROUND(GridHeight * 0.45) % 2 = 1
            THEN MAX(14, ROUND(GridHeight * 0.45) - 1)
        ELSE MAX(14, ROUND(GridHeight * 0.45))
    END;

-- Scale down natural wonders too. Technically this should be
-- NumNaturalWonders * 0.45 * 0.45 (map size is width and height) but that seems too
-- extreme. Adjust as needed.
UPDATE Maps
SET NumNaturalWonders = CAST((NumNaturalWonders * 0.45) + 0.5 AS INTEGER);

-- Remove the warning from AI players that we settled too close
DELETE FROM TraitModifiers
  WHERE TraitType = 'TRAIT_LEADER_MAJOR_CIV'
    AND ModifierId = 'STANDARD_DIPLOMACY_SETTLED_CITIES';
