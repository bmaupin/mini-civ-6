function PlotHasImprovement(plot)
    local NO_IMPROVEMENT = -1;
    if (plot:GetImprovementType() == NO_IMPROVEMENT) then
		return false;
    else
        return true;
	end
end

function AddImprovements()
    print("**************************************** AddImprovements()");
    -- Plot.GetImprovementType
    -- ImprovementBuilder.CanHaveImprovement
    -- ImprovementBuilder.SetImprovementType

    local NO_TEAM = -1;

    local m_eFarmImprovement = GameInfo.Improvements["IMPROVEMENT_FARM"].Index;

    local players = PlayerManager.GetAliveMajors()
    for _, player in ipairs(players) do
        if player:IsHuman() then
            local playerCities = player:GetCities();
            for _, city in playerCities:Members() do
                local cityPlots = city:GetOwnedPlots();
                for _, plot in ipairs(cityPlots) do
                    if not PlotHasImprovement(plot) then
                        if (ImprovementBuilder.CanHaveImprovement(plot, m_eFarmImprovement, NO_TEAM)) then
                            ImprovementBuilder.SetImprovementType(plot, m_eFarmImprovement, plot:GetOwner());
                        end

                    end
                end
            end
        end
    end
end
LuaEvents.NewGameInitialized.Add(AddImprovements);
