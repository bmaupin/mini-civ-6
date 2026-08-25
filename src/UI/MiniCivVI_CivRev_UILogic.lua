-- When the game is first started/loaded, zoom way in to approximate CivRev zoom level
--
-- The default map zoom seems to always be 50%. Camera.artdef has a DefaultZoom property
-- but changing it had no effect. What did have an effect was modifying HeightCurve1 and
-- HeightCurve2; the default zoom seems to be based on a percentage of those. However, the
-- only way to get a very close zoom is to drastically reduce HeightCurve2, which has the
-- side effect of drastically reducing the max zoom out limit. Thankfully there is a Lua
-- method we can use to modify default zoom without modifying max zoom out.
function IncreaseMapZoom()
  -- Actual zoom level appears to be the first value squared, e.g. 0.5 is 25% zoom
  UI.SetMapZoom(0.5, 0.0, 0.0);
end
Events.LoadGameViewStateDone.Add(IncreaseMapZoom);
