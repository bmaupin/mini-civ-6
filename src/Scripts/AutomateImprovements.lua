-- Automatically repair a pillaged tile after this many turns
local REPAIR_PILLAGED_TILES_TURNS = 20;

local NO_FEATURE = -1;
local NO_IMPROVEMENT = -1;
local NO_RESOURCE = -1;
local NO_TERRAIN = -1;

-- Aside from resource improvements (which are all automated), only automate these
-- improvements for features and terrain
local IMPROVEMENTS_TO_AUTOMATE = {
    "IMPROVEMENT_LUMBER_MILL",
    "IMPROVEMENT_MINE",
    "IMPROVEMENT_FARM",
};

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

    print("**************************************** ImprovementBuilder.CanHaveImprovement=" .. tostring(ImprovementBuilder.CanHaveImprovement(plot, improvement.Index, player:GetTeam())));

    -- ImprovementBuilder.CanHaveImprovement seems to return false if
    -- - There's a wonder on the tile
    -- - There's a district on the tile
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

-- Cache feature/resource/terrain to improvement lookups; inspired by warmachinescenario.lua
local FeatureToImprovements = {};
local ResourceToImprovements = {};
local TerrainToImprovements = {};

function GetImprovementForPlot(plot)
    if plot == nil or PlotHasImprovement(plot) then
        return;
    end

    local featureIndex = plot:GetFeatureType();
    local resourceIndex = plot:GetResourceType();
    local terrainIndex = plot:GetTerrainType();

    print("**************************************** plot x,y=" .. tostring(plot:GetX()) .. "," .. tostring(plot:GetY()));
    print("**************************************** featureType=" .. tostring(featureIndex));
    print("**************************************** resourceType=" .. tostring(resourceIndex));
    print("**************************************** terrainType=" .. tostring(terrainIndex));

    -- Since there is no fallback logic, prioritise resource improvements, then
    -- features, then terrain
    if (resourceIndex ~= NO_RESOURCE) then
		if (ResourceToImprovements[resourceIndex] ~= nil) then
			return ResourceToImprovements[resourceIndex];
		else
            for row in GameInfo.Improvement_ValidResources() do
                local resource = GameInfo.Resources[row.ResourceType];
                if (resource.Index == resourceIndex) then
                    print("**************************************** mustRemoveFeature=" .. tostring(row.MustRemoveFeature));
                    ResourceToImprovements[resourceIndex] = row.ImprovementType;
                    return row.ImprovementType;
                end
            end
        end

    elseif (featureIndex ~= NO_FEATURE) then
		if (FeatureToImprovements[featureIndex] ~= nil) then
			return FeatureToImprovements[featureIndex];
		else
            for row in GameInfo.Improvement_ValidFeatures() do
                local feature = GameInfo.Features[row.FeatureType];
                if (feature.Index == featureIndex) then
                    for _, improvementType in ipairs(IMPROVEMENTS_TO_AUTOMATE) do
                        if row.ImprovementType == improvementType then
                            FeatureToImprovements[featureIndex] = improvementType;
                            return improvementType;
                        end
                    end
                end
            end
        end

    elseif (terrainIndex ~= NO_TERRAIN) then
		if (TerrainToImprovements[terrainIndex] ~= nil) then
			return TerrainToImprovements[terrainIndex];
		else
            for row in GameInfo.Improvement_ValidTerrains() do
                local terrain = GameInfo.Terrains[row.TerrainType];
                if (terrain.Index == terrainIndex) then
                    for _, improvementType in ipairs(IMPROVEMENTS_TO_AUTOMATE) do
                        -- Filtering out PrereqCivic ensures hils on plains/grassland get
                        -- mines, not farms
                        if row.PrereqCivic == nil and row.ImprovementType == improvementType then
                            TerrainToImprovements[terrainIndex] = improvementType;
                            return improvementType;
                        end
                    end
                end
            end
        end
    end
end

function AddImprovementToPlot(plot, player)
    local improvementType = GetImprovementForPlot(plot);
    if (improvementType == nil) then
        return;
    end

    local improvement = GameInfo.Improvements[improvementType];

    print("**************************************** improvementType=" .. tostring(improvementType));

    if (CanImprovementBeAdded(plot, improvement, player)) then
        print("**************************************** Adding improvement " .. tostring(improvementType) .. " to plot " .. tostring(plot:GetX()) .. "," .. tostring(plot:GetY()));
        ImprovementBuilder.SetImprovementType(plot, improvement.Index, plot:GetOwner());
        return;
    end
end

function OnCityTileOwnershipChanged(ownerID, _cityID, plotX, plotY)
    local player = Players[ownerID];
    if (not player:IsAlive() or not player:IsMajor()) then
        return;
    end

    local plot = Map.GetPlot(plotX, plotY);
    AddImprovementToPlot(plot, player);
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

function AddImprovementsToPlayerCities(player)
    local playerCities = player:GetCities();
    for _, city in playerCities:Members() do
        for _, plot in pairs(GetCityPlots(city)) do
            AddImprovementToPlot(plot, player);
        end
    end
end

function OnResearchCompleted(playerID, _techID)
    local player = Players[playerID];
    if (not player:IsAlive() or not player:IsMajor()) then
        return;
    end

    AddImprovementsToPlayerCities(player);
end
Events.ResearchCompleted.Add(OnResearchCompleted);

-- Add improvements when the game is first started, e.g. for scenarios
function AddImprovementsAtGameStart()
    local players = PlayerManager.GetAliveMajors();
    for _, player in ipairs(players) do
        AddImprovementsToPlayerCities(player);
    end
end
LuaEvents.NewGameInitialized.Add(AddImprovementsAtGameStart);

local pillagedImprovements = {};

function OnImprovementPillaged(plotIndex, improvementIndex)
    print("**************************************** OnImprovementPillaged()");
    print("**************************************** plotIndex=", plotIndex);
    print("**************************************** improvementIndex=", improvementIndex);
    if (improvementIndex ~= NO_IMPROVEMENT and plotIndex ~= nil) then
        print("**************************************** pillagedImprovements[" .. tostring(plotIndex) .. "] = " .. tostring(Game.GetCurrentGameTurn()));
        pillagedImprovements[plotIndex] = Game.GetCurrentGameTurn();
    end
end
GameEvents.OnImprovementPillaged.Add(OnImprovementPillaged);

-- When a game is first loaded, get any pillaged tiles so that they can be automatically
-- repaired since the OnImprovementPillaged event won't fire for already pillaged tiles
function GetPillagedTiles()
    print("**************************************** GetPillagedTiles()")
    local players = PlayerManager.GetAliveMajors();
    for _, player in ipairs(players) do
        local playerCities = player:GetCities();
        for _, city in playerCities:Members() do
            for _, plot in pairs(GetCityPlots(city)) do
                if plot ~= nil and PlotHasImprovement(plot) and plot:IsImprovementPillaged() then
                    print("**************************************** pillagedImprovements[" .. tostring(plot:GetIndex()) .. "] = " .. tostring(Game.GetCurrentGameTurn()));
                    -- Since we don't know how long the tile has been pillaged for, it
                    -- could have been pillaged anywhere from 0 to REPAIR_PILLAGED_TILES_TURNS
                    -- turns, so divide by two to simulate an average
                    pillagedImprovements[plot:GetIndex()] = Game.GetCurrentGameTurn() - (REPAIR_PILLAGED_TILES_TURNS / 2);
                end
            end
        end
    end
end
-- Run this any time a game is loaded, not just for newly started games
Events.LoadGameViewStateDone.Add(GetPillagedTiles);

function RepairPillagedTiles(_playerID)
    print("**************************************** RepairPillagedTiles()");
    local currentTurn = Game.GetCurrentGameTurn();
    for plotIndex, turnPillaged in pairs(pillagedImprovements) do
        print("**************************************** pillagedImprovements[" .. tostring(plotIndex) .. "] = " .. tostring(turnPillaged));
        if (currentTurn >= turnPillaged + REPAIR_PILLAGED_TILES_TURNS) then
            local plot = Map.GetPlotByIndex(plotIndex);
            if plot ~= nil and PlotHasImprovement(plot) then
                print("**************************************** repairing pillaged plot");
                ImprovementBuilder.SetImprovementPillaged(plot, false);
            end
            pillagedImprovements[plotIndex] = nil;
        end
    end
end
-- Only run once per game turn, not once for every player turn
GameEvents.OnGameTurnStarted.Add(RepairPillagedTiles);
