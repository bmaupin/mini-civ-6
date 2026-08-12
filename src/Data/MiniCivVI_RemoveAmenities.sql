-- Removing CAPABILITY_AMENITIES sets amenities the number of required amenities for a
-- city to 0, which can be seen in the city UI. It will still show amenities from certain
-- sources (e.g. "Amenities from Entertainment: 1") but the overall city amenities will be
-- 0 ("0 Amenities of 0 Required") and the city status will be "Content."
--
-- NOTE: The amentities section will still show in the City Details panel. At the moment
--       this is intentional since its out of the way and clearly shows in the UI that
--       amenities are disabled.
DELETE FROM Types WHERE Type = 'CAPABILITY_AMENITIES';
DELETE FROM Types WHERE Type = 'CIVIC_GAMES_RECREATION';

-- Entertainment complex and its replacements (street carnival and hippodrome) will be
-- made inaccessible when the Games and Recreation civic is deleted. However, if districts
-- are deleted, district prerequisites get removed. So instead we should delete anything
-- that has those districts as a prerequisite.
DELETE FROM Buildings
WHERE PrereqDistrict IN (
  'DISTRICT_ENTERTAINMENT_COMPLEX',
  'DISTRICT_HIPPODROME',
  'DISTRICT_STREET_CARNIVAL',
  'DISTRICT_WATER_ENTERTAINMENT_COMPLEX',
  'DISTRICT_WATER_STREET_CARNIVAL'
);

DELETE FROM Projects
WHERE PrereqDistrict IN (
  'DISTRICT_ENTERTAINMENT_COMPLEX',
  'DISTRICT_HIPPODROME',
  'DISTRICT_STREET_CARNIVAL',
  'DISTRICT_WATER_ENTERTAINMENT_COMPLEX',
  'DISTRICT_WATER_STREET_CARNIVAL'
);

DELETE FROM Units
WHERE PrereqDistrict IN (
  'DISTRICT_ENTERTAINMENT_COMPLEX',
  'DISTRICT_HIPPODROME',
  'DISTRICT_STREET_CARNIVAL',
  'DISTRICT_WATER_ENTERTAINMENT_COMPLEX',
  'DISTRICT_WATER_STREET_CARNIVAL'
);

-- Water park and Copacabana are unlocked with the Natural History civic, which unlocks
-- other items so we may not want to remove that civic.
--
-- Deleting districts can cause crashes because some districts are referenced in Lua
-- files, so disable them instead
UPDATE Districts
SET MaxPerPlayer = 0,
  -- This makes it so the districts don't show up in the civics/tech tree
  PrereqCivic = NULL,
  PrereqTech = NULL
WHERE DistrictType IN (
  -- Water park
  'DISTRICT_WATER_ENTERTAINMENT_COMPLEX',
  -- Copacabana
  'DISTRICT_WATER_STREET_CARNIVAL'
);
