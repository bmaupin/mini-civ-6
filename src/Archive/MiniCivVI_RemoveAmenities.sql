DELETE FROM Types WHERE Type = 'CAPABILITY_AMENITIES';
DELETE FROM Types WHERE Type = 'CIVIC_GAMES_RECREATION';

-- Entertainment complex and its replacements (street carnival and hippodrome) will be
-- made inaccessible when the Games and Recreation civic is deleted. However, if districts
-- are deleted, district prerequisites get removed. So instead we should delete anything
-- that has those districts as a prerequisite.
--
-- Water park and Copacabana are unlocked with the Natural History civic, which unlocks
-- other items so we may not want to remove that civic. Instead delete the districts and
-- anything which won't get deleted when they do.
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

-- Deleting districts can cause crashes because some districts are referenced in Lua
-- files, so disable them instead
UPDATE Districts
  SET MaxPerPlayer = 0
  WHERE DistrictType IN (
    -- Water park
    'DISTRICT_WATER_ENTERTAINMENT_COMPLEX',
    -- Copacabana
    'DISTRICT_WATER_STREET_CARNIVAL'
  );

-- TODO:
-- 1. [x] test that city amenity HUD is empty or removed (see screenshot)
--    - Still showing up in UI: amenities from luxury resources, entertainment
-- 1. [x] does this disable entertainment complex district? no
-- 1. [x] does this disable games and recreation civic? no
-- 1. [ ] Hide amenities panel altogether? Should be easy
--    👉 Do this later; for now leave it as-is to see if amenities have an impact
--    - Override OnSelectHealthTab, call it then call Controls.PanelAmenities:SetHide(true) ??
