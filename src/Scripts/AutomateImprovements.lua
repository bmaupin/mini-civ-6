-- Automatically repair a pillaged tile after this many turns
local REPAIR_PILLAGED_TILES_TURNS = 3;

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

function PlaceImprovement(plot, player, improvementType)
    local improvement = GameInfo.Improvements[improvementType];

    print("**************************************** improvementType=" .. tostring(improvementType));

    if (CanImprovementBeAdded(plot, improvement, player)) then
        print("**************************************** Adding improvement " .. tostring(improvement.ImprovementType) .. " to plot " .. tostring(plot:GetX()) .. "," .. tostring(plot:GetY()));
        ImprovementBuilder.SetImprovementType(plot, improvement.Index, plot:GetOwner());
        return;
    end
end

function AddImprovementsToPlot(plot, player)
    if plot ~= nil and not PlotHasImprovement(plot) then
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
            for row in GameInfo.Improvement_ValidResources() do
                local resource = GameInfo.Resources[row.ResourceType];
                if (resource.Index == resourceIndex) then
                    print("**************************************** mustRemoveFeature=" .. tostring(row.MustRemoveFeature));
                    PlaceImprovement(plot, player, row.ImprovementType);
                    return;
                end
            end

        elseif (featureIndex ~= NO_FEATURE) then
            for row in GameInfo.Improvement_ValidFeatures() do
                local feature = GameInfo.Features[row.FeatureType];
                if (feature.Index == featureIndex) then
                    for _, improvementType in ipairs(IMPROVEMENTS_TO_AUTOMATE) do
                        if row.ImprovementType == improvementType then
                            PlaceImprovement(plot, player, improvementType);
                            return;
                        end
                    end
                end
            end

        elseif (terrainIndex ~= NO_TERRAIN) then
            for row in GameInfo.Improvement_ValidTerrains() do
                local terrain = GameInfo.Terrains[row.TerrainType];
                if (terrain.Index == terrainIndex) then
                    for _, improvementType in ipairs(IMPROVEMENTS_TO_AUTOMATE) do
                        -- Filtering out PrereqCivic ensures hils on plains/grassland get
                        -- mines, not farms
                        if row.PrereqCivic == nil and row.ImprovementType == improvementType then
                            PlaceImprovement(plot, player, improvementType);
                            return;
                        end
                    end
                end
            end
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
