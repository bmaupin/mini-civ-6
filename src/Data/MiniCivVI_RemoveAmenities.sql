DELETE FROM Types WHERE Type = 'CAPABILITY_AMENITIES';
DELETE FROM Types WHERE Type = 'CIVIC_GAMES_RECREATION';

-- TODO:
-- 1. [x] test that city amenity HUD is empty or removed (see screenshot)
--    - Still showing up in UI: amenities from luxury resources, entertainment
-- 1. [x] does this disable entertainment complex district? no
-- 1. [x] does this disable games and recreation civic? no
-- 1. [ ] Hide amenities panel altogether? Should be easy
--    👉 Do this later; for now leave it as-is to see if amenities have an impact
--    - Override OnSelectHealthTab, call it then call Controls.PanelAmenities:SetHide(true) ??

-- <Row Type="DISTRICT_ENTERTAINMENT_COMPLEX" Kind="KIND_DISTRICT"/>