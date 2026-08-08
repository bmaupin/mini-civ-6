local NO_IMPROVEMENT = -1;
local NO_TEAM = -1;

local FEATURE_FOREST_INDEX = GameInfo.Features["FEATURE_FOREST"].Index;

local IMPROVEMENT_FARM_INDEX = GameInfo.Improvements["IMPROVEMENT_FARM"].Index;
local IMPROVEMENT_LUMBER_MILL_INDEX = GameInfo.Improvements["IMPROVEMENT_LUMBER_MILL"].Index;

local TERRAIN_GRASS_INDEX = GameInfo.Terrains["TERRAIN_GRASS"].Index;
local TERRAIN_PLAINS_INDEX = GameInfo.Terrains["TERRAIN_PLAINS"].Index;

function PlotHasImprovement(plot)
    if (plot:GetImprovementType() == NO_IMPROVEMENT) then
		return false;
    else
        return true;
	end
end

function OnCityTileOwnershipChanged(ownerID, _cityID, plotX, plotY)
    local player = Players[ownerID];
    if (not player:IsAlive() or not player:IsMajor()) then
        return;
    end

    local plot = Map.GetPlot(plotX, plotY);

    if plot ~= nil and not PlotHasImprovement(plot) then
        local improvementIndex = nil;
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
            improvementIndex = IMPROVEMENT_FARM_INDEX;
            improvementType = "IMPROVEMENT_FARM";
        end

        if (featureType == FEATURE_FOREST_INDEX) then
            improvementIndex = IMPROVEMENT_LUMBER_MILL_INDEX;
            improvementType = "IMPROVEMENT_LUMBER_MILL";
        end

        print("**************************************** improvementIndex=" .. tostring(improvementIndex));

        if (improvementIndex ~= nil and ImprovementBuilder.CanHaveImprovement(plot, improvementIndex, NO_TEAM)) then
            print("**************************************** CanHaveImprovement=" .. tostring(ImprovementBuilder.CanHaveImprovement(plot, improvementIndex, NO_TEAM)));
            print("**************************************** Adding improvement " .. tostring(improvementType) .. " to plot " .. tostring(plotX) .. "," .. tostring(plotY));
            ImprovementBuilder.SetImprovementType(plot, improvementIndex, plot:GetOwner());
            return;
        end
    end
end
Events.CityTileOwnershipChanged.Add(OnCityTileOwnershipChanged);
