local NO_IMPROVEMENT = -1;
local NO_RESOURCE = -1;
local NO_TEAM = -1;

local FEATURE_FLOODPLAINS_INDEX = GameInfo.Features["FEATURE_FLOODPLAINS"].Index;
local FEATURE_FOREST_INDEX = GameInfo.Features["FEATURE_FOREST"].Index;
-- TODO: Gathering Storm only
-- local FEATURE_RAINFOREST_INDEX = GameInfo.Features["FEATURE_RAINFOREST"].Index;

local TERRAIN_DESERT_HILLS_INDEX = GameInfo.Terrains["TERRAIN_DESERT_HILLS"].Index;
local TERRAIN_GRASS_INDEX = GameInfo.Terrains["TERRAIN_GRASS"].Index;
local TERRAIN_GRASS_HILLS_INDEX = GameInfo.Terrains["TERRAIN_GRASS_HILLS"].Index;
local TERRAIN_PLAINS_INDEX = GameInfo.Terrains["TERRAIN_PLAINS"].Index;
local TERRAIN_PLAINS_HILLS_INDEX = GameInfo.Terrains["TERRAIN_PLAINS_HILLS"].Index;
local TERRAIN_SNOW_HILLS_INDEX = GameInfo.Terrains["TERRAIN_SNOW_HILLS"].Index;
local TERRAIN_TUNDRA_HILLS_INDEX = GameInfo.Terrains["TERRAIN_TUNDRA_HILLS"].Index;

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

function AddImprovementsToPlot(plot, player)
    if plot ~= nil and not PlotHasImprovement(plot) then
        local improvementType = nil;
        local mustRemoveFeature = false;

        local featureIndex = plot:GetFeatureType();
        local resourceIndex = plot:GetResourceType();
        local terrainIndex = plot:GetTerrainType();

        print("**************************************** plot x,y=" .. tostring(plot:GetX()) .. "," .. tostring(plot:GetY()));
        print("**************************************** featureType=" .. tostring(featureIndex));
        print("**************************************** resourceType=" .. tostring(resourceIndex));
        print("**************************************** terrainType=" .. tostring(terrainIndex));

        if (resourceIndex ~= NO_RESOURCE) then
            for row in GameInfo.Improvement_ValidResources() do
                local resource = GameInfo.Resources[row.ResourceType];
                if (resource.Index == resourceIndex) then
                    -- TODO: What if a resource requires the terrain feature to be removed? (MustRemoveFeature)
                    improvementType = row.ImprovementType;
                    mustRemoveFeature = row.MustRemoveFeature;
                    break;
                end
            end

        elseif (featureIndex == FEATURE_FOREST_INDEX) then
          -- TODO: Gathering Storm only
          -- featureType == FEATURE_RAINFOREST_INDEX) then
            improvementType = "IMPROVEMENT_LUMBER_MILL";

        elseif (terrainIndex == TERRAIN_DESERT_HILLS_INDEX or
          terrainIndex == TERRAIN_GRASS_HILLS_INDEX or
          terrainIndex == TERRAIN_PLAINS_HILLS_INDEX or
          terrainIndex == TERRAIN_SNOW_HILLS_INDEX or
          terrainIndex == TERRAIN_TUNDRA_HILLS_INDEX) then
            improvementType = "IMPROVEMENT_MINE";

        elseif (featureIndex == FEATURE_FLOODPLAINS_INDEX or
          terrainIndex == TERRAIN_GRASS_INDEX or
          terrainIndex == TERRAIN_PLAINS_INDEX) then
            improvementType = "IMPROVEMENT_FARM";
        end

        local improvement = GameInfo.Improvements[improvementType];

        print("**************************************** improvementType=" .. tostring(improvementType));
        print("**************************************** mustRemoveFeature=" .. tostring(mustRemoveFeature));

        if (CanImprovementBeAdded(plot, improvement, player)) then
            print("**************************************** CanHaveImprovement=" .. tostring(ImprovementBuilder.CanHaveImprovement(plot, improvement.Index, NO_TEAM)));
            print("**************************************** Adding improvement " .. tostring(improvement.ImprovementType) .. " to plot " .. tostring(plot:GetX()) .. "," .. tostring(plot:GetY()));
            ImprovementBuilder.SetImprovementType(plot, improvement.Index, plot:GetOwner());
            return;
        end
    end
end

function OnCityTileOwnershipChanged(ownerID, _cityID, plotX, plotY)
    local player = Players[ownerID];
    if (not player:IsAlive() or not player:IsMajor()) then
        return;
    end

    local plot = Map.GetPlot(plotX, plotY);
    AddImprovementsToPlot(plot, player);
end
Events.CityTileOwnershipChanged.Add(OnCityTileOwnershipChanged);

-- city:GetOwnedPlots() doesn't seem to return all of the tiles owned by a city, but this
-- works. Source:
-- https://forums.civfanatics.com/threads/improvement-owner-not-updating-with-plot-owner-lua.621776/
--
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--	GRAB TABLE OF ALL PLOTS OWNED AND WORKABLE BY A SPECIFIED CITY
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--GlobalParameters.CITY_MAX_BUY_PLOT_RANGE is not used because the game ignores the setting as per civ5
function GetCityPlots(pCity)
	local iCityRadius = 3;
	local tTempTable = {};
	if pCity ~= nil then
		local iCityOwner = pCity:GetOwner();
		local iCityX, iCityY = pCity:GetX(), pCity:GetY();
		for dx = (iCityRadius * -1), iCityRadius do
			for dy = (iCityRadius * -1), iCityRadius do
				local pPlotNearCity = Map.GetPlotXYWithRangeCheck(iCityX, iCityY, dx, dy, iCityRadius);
				if pPlotNearCity and (pPlotNearCity:GetOwner() == iCityOwner) and (pCity == Cities.GetPlotPurchaseCity(pPlotNearCity:GetIndex())) then
					table.insert(tTempTable, pPlotNearCity);
				end
			end
		end
	end
	return tTempTable;
end

function OnResearchCompleted(playerID, _techID)
    local player = Players[playerID];
    if (not player:IsAlive() or not player:IsMajor()) then
        return;
    end

    local playerCities = player:GetCities();
    for _, city in playerCities:Members() do
        for _, plot in pairs(GetCityPlots(city)) do
            AddImprovementsToPlot(plot, player);
        end
    end
end
Events.ResearchCompleted.Add(OnResearchCompleted);

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
