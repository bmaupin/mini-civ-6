-- Scale down map sizes for faster gameplay
UPDATE Maps
SET
    GridWidth = CASE
        -- Calculate 40%, floor by casting to INT, then subtract 1 if odd
        -- Use MAX to set minimum map size; smaller sizes caused crashes
        WHEN CAST(GridWidth * 0.4 AS INTEGER) % 2 = 1
            THEN MAX(20, CAST(GridWidth * 0.4 AS INTEGER) - 1)
        ELSE MAX(20, CAST(GridWidth * 0.4 AS INTEGER))
    END,
    GridHeight = CASE
        WHEN CAST(GridHeight * 0.4 AS INTEGER) % 2 = 1
            THEN MAX(12, CAST(GridHeight * 0.4 AS INTEGER) - 1)
        ELSE MAX(12, CAST(GridHeight * 0.4 AS INTEGER))
    END;

-- Scale down natural wonders too. Technically this should be
-- NumNaturalWonders * 0.4 * 0.4 (map size is width and height) but that seems too
-- extreme. Adjust as needed.
UPDATE Maps
SET NumNaturalWonders = CAST((NumNaturalWonders * 0.4) + 0.5 AS INTEGER);
