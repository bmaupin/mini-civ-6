local NO_IMPROVEMENT = -1;
local NO_TEAM = -1;

local m_eFarmImprovement = GameInfo.Improvements["IMPROVEMENT_FARM"].Index;

function PlotHasImprovement(plot)
    if (plot:GetImprovementType() == NO_IMPROVEMENT) then
		return false;
    else
        return true;
	end
end

function AddImprovementsToCity(city, player)
    if (player:IsBarbarian()) then
        return;
    end

    local cityPlots = city:GetOwnedPlots();
    for _, plot in ipairs(cityPlots) do
        if not PlotHasImprovement(plot) then
            if (ImprovementBuilder.CanHaveImprovement(plot, m_eFarmImprovement, NO_TEAM)) then
                ImprovementBuilder.SetImprovementType(plot, m_eFarmImprovement, plot:GetOwner());
            end
        end
    end
end

function AddImprovements()
    local players = PlayerManager.GetAliveMajors()
    for _, player in ipairs(players) do
        local playerCities = player:GetCities();
        for _, city in playerCities:Members() do
            AddImprovementsToCity(city, player);
        end
    end
end
LuaEvents.NewGameInitialized.Add(AddImprovements);

function OnCityBuilt(playerID, cityID, _cityX, _cityY)
    local city = CityManager.GetCity(playerID, cityID);
    AddImprovementsToCity(city, Players[playerID]);
end
GameEvents.CityBuilt.Add(OnCityBuilt);
