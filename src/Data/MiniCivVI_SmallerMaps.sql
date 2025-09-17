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
    END
WHERE MapSizeType IN ('MAPSIZE_DUEL', 'MAPSIZE_TINY', 'MAPSIZE_SMALL', 'MAPSIZE_STANDARD', 'MAPSIZE_LARGE', 'MAPSIZE_HUGE');
