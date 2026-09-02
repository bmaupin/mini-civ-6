include("WorldRankings");

local ECONOMIC_VICTORY_GOLD_IN_TREASURY = 20000;

-- Logic adapted from DLC/BlackDeathScenario/UI/Replacements/WorldRankings_BlackDeathScenario.lua
g_victoryData.VICTORY_CIVREV_ECONOMIC = {
	GetText = function(player)
		return Locale.Lookup(
			"LOC_WORLD_RANKINGS_VICTORY_CIVREV_ECONOMIC",
			Players[player:GetID()]:GetTreasury():GetGoldBalance(),
			ECONOMIC_VICTORY_GOLD_IN_TREASURY
		);
	end,
	GetScore = function(player)
    return Players[player:GetID()]:GetTreasury():GetGoldBalance();
	end
};
