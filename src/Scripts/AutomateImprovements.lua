local NO_IMPROVEMENT = -1;
local NO_TEAM = -1;

local FEATURE_FOREST_INDEX = GameInfo.Features["FEATURE_FOREST"].Index;

local TERRAIN_GRASS_INDEX = GameInfo.Terrains["TERRAIN_GRASS"].Index;
local TERRAIN_PLAINS_INDEX = GameInfo.Terrains["TERRAIN_PLAINS"].Index;

function PlotHasImprovement(plot)
    if (plot:GetImprovementType() == NO_IMPROVEMENT) then
		return false;
    else
        return true;
	end
end

function CanImprovementBeAdded(plot, improvement, player)
    if plot == nil or improvement == nil or player == nil then
        return false;
    end

    -- None of the improvements we're concerned with have Goody, PrereqCivic, TraitType, etc.
    local prereqTech = improvement.PrereqTech;

    if (
        ImprovementBuilder.CanHaveImprovement(plot, improvement.Index, player:GetTeam()) and
        (
            prereqTech == nil or player:GetTechs():HasTech(GameInfo.Technologies[prereqTech].Index)
        )
    ) then
        return true;
    end

    return false;
end

function OnCityTileOwnershipChanged(ownerID, _cityID, plotX, plotY)
    local player = Players[ownerID];
    if (not player:IsAlive() or not player:IsMajor()) then
        return;
    end

    local plot = Map.GetPlot(plotX, plotY);

    if plot ~= nil and not PlotHasImprovement(plot) then
        local improvementType = nil;

        local featureType = plot:GetFeatureType();
        local terrainType = plot:GetTerrainType();

        print("**************************************** featureType=" .. tostring(featureType));
        print("**************************************** terrainType=" .. tostring(terrainType));
        print("**************************************** FEATURE_FOREST_INDEX=" .. tostring(FEATURE_FOREST_INDEX));
        print("**************************************** TERRAIN_GRASS_INDEX=" .. tostring(TERRAIN_GRASS_INDEX));
        print("**************************************** TERRAIN_PLAINS_INDEX=" .. tostring(TERRAIN_PLAINS_INDEX));

        if (terrainType == TERRAIN_GRASS_INDEX or
          terrainType == TERRAIN_PLAINS_INDEX) then
            improvementType = "IMPROVEMENT_FARM";
        end

        if (featureType == FEATURE_FOREST_INDEX) then
            improvementType = "IMPROVEMENT_LUMBER_MILL";
        end

        local improvement = GameInfo.Improvements[improvementType];

        print("**************************************** improvementType=" .. tostring(improvementType));

        if (CanImprovementBeAdded(plot, improvement, player)) then
            print("**************************************** CanHaveImprovement=" .. tostring(ImprovementBuilder.CanHaveImprovement(plot, improvement.Index, NO_TEAM)));
            print("**************************************** Adding improvement " .. tostring(improvement.ImprovementType) .. " to plot " .. tostring(plotX) .. "," .. tostring(plotY));
            ImprovementBuilder.SetImprovementType(plot, improvement.Index, plot:GetOwner());
            return;
        end
    end
end
Events.CityTileOwnershipChanged.Add(OnCityTileOwnershipChanged);

-- TODO: Add improvements when the game is first started? e.g. for scenarios
-- function AddImprovements()
--     print("**************************************** AddImprovements")
--     local players = PlayerManager.GetAliveMajors()
--     for _, player in ipairs(players) do
--         local playerCities = player:GetCities();
--         for _, city in playerCities:Members() do
--             AddImprovementsToCity(city, player);
--         end
--     end
-- end
-- LuaEvents.NewGameInitialized.Add(AddImprovements);
