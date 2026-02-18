-- TODO: This seems to mess up the UI; the civics tree doesn't seem to work when auto play
--       is done. Could we instead start auto play at the first turn? e.g. and then call
--       LuaEvents.NewGameInitialized.Remove(StartAutoplay) from within StartAutoplay?
function StartAutoplay()
    -- Goes until ~1500 CE
    AutoplayManager.SetTurns(105);
    AutoplayManager.SetReturnAsPlayer(0);
    -- If the next line is commented out, auto play will be super fast but you won't see what's happening
    -- AutoplayManager.SetObserveAsPlayer(PlayerTypes.OBSERVER);

    AutoplayManager.SetActive(true);
    print("**************************************** Starting auto play");
end
LuaEvents.NewGameInitialized.Add(StartAutoplay);
