function StartAutoplay()
    Events.PlayerTurnActivated.Remove(StartAutoplay);

    -- Goes until ~1500 CE
    -- AutoplayManager.SetTurns(105);

    AutoplayManager.SetTurns(250);
    AutoplayManager.SetReturnAsPlayer(0);
    -- If the next line is commented out, auto play will be super fast but you won't see what's happening
    -- AutoplayManager.SetObserveAsPlayer(PlayerTypes.OBSERVER);

    AutoplayManager.SetActive(true);
    print("**************************************** Starting auto play");
end
Events.PlayerTurnActivated.Add(StartAutoplay);



function PrintGoldBalance()
    if Game.GetCurrentGameTurn() < 250 then
        return;
    end

    local players = PlayerManager.GetAliveMajors();
    for _, player in ipairs(players) do
        print("**************************************** Player", player:GetID(), "gold balance=", player:GetTreasury():GetGoldBalance());
    end
end
Events.LocalPlayerTurnBegin.Add(PrintGoldBalance);
