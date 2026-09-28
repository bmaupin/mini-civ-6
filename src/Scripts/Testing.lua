-- Test auto repair of pillaged tiles; can be added to AddImprovementToPlot for testing
-- ImprovementBuilder.SetImprovementPillaged(plot, true);

-- Test auto removal of fallout; can be added to AddImprovementToPlot for testing
-- Game.GetFalloutManager():AddFallout(plot:GetIndex(), 100);

function AddBananas()
    print("**************************************** AddBananas()");
    local plot = Map.GetPlot(5, 4)
    if plot == nil then
        return
    end

    local bananaResource = GameInfo.Resources["RESOURCE_BANANAS"]
    -- local plantation = GameInfo.Improvements["IMPROVEMENT_PLANTATION"]
    if bananaResource == nil then
        return
    end

    print("**************************************** adding bananas");
    ResourceBuilder.SetResourceType(plot, bananaResource.Index, 1)
    -- ImprovementBuilder.SetImprovementType(plot, plantation.Index, plot:GetOwner())
end
Events.LoadGameViewStateDone.Add(AddBananas)

function ResetGreatPersonPoints()
    local player = Players[0];
    if player == nil or not player:IsAlive() then
        return;
    end

    local greatArtistClass = GameInfo.GreatPersonClasses["GREAT_PERSON_CLASS_SCIENTIST"];
    if greatArtistClass == nil then
        return;
    end

    player:GetGreatPeoplePoints():SetPointsTotal(greatArtistClass.Index, 0);

    local greatArtistClass = GameInfo.GreatPersonClasses["GREAT_PERSON_CLASS_ARTIST"];
    if greatArtistClass == nil then
        return;
    end

    player:GetGreatPeoplePoints():SetPointsTotal(greatArtistClass.Index, 0);
end
Events.LoadGameViewStateDone.Add(ResetGreatPersonPoints);

-- Add great points every turn
function AddGreatArtistPointsEveryTurn(playerID)
    if playerID ~= 0 then
        return;
    end
    local player = Players[playerID];

    local greatArtistClass = GameInfo.GreatPersonClasses["GREAT_PERSON_CLASS_ARTIST"];
    if greatArtistClass == nil then
        return;
    end

    player:GetGreatPeoplePoints():ChangePointsTotal(greatArtistClass.Index, 50);
    print("**************************************** Added great artist points to player 0");
end
Events.PlayerTurnActivated.Add(AddGreatArtistPointsEveryTurn);




function TriggerEconomicVictory(playerID)
    -- Set to playerID 1 to test AI victory
    if playerID ~= 0 then
        return;
    end

    if Game.GetCurrentGameTurn() < 2 then
        return;
    end

    Players[playerID]:GetTreasury():SetGoldBalance(40000);
end
-- Give gold at end of turn to ensure player can't spend it before victory is triggered at beginning of next turn
Events.PlayerTurnDeactivated.Add(TriggerEconomicVictory);
