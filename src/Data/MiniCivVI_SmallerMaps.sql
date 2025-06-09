UPDATE Maps
SET
    GridWidth = CASE
        -- Calculate 40%, floor by casting to INT, then subtract 1 if odd
        WHEN CAST(GridWidth * 0.4 AS INTEGER) % 2 = 1
            THEN CAST(GridWidth * 0.4 AS INTEGER) - 1
        ELSE CAST(GridWidth * 0.4 AS INTEGER)
    END,
    GridHeight = CASE
        WHEN CAST(GridHeight * 0.4 AS INTEGER) % 2 = 1
            THEN CAST(GridHeight * 0.4 AS INTEGER) - 1
        ELSE CAST(GridHeight * 0.4 AS INTEGER)
    END
WHERE MapSizeType IN ('MAPSIZE_DUEL', 'MAPSIZE_TINY', 'MAPSIZE_SMALL', 'MAPSIZE_STANDARD', 'MAPSIZE_LARGE', 'MAPSIZE_HUGE');
