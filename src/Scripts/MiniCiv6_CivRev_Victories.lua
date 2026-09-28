-- NOTE: If this is changed it also needs to be changed in src/UI/Replacements/WorldRankings_CivRev.lua
local ECONOMIC_VICTORY_GOLD_IN_TREASURY = 20000;

function GetEconomicVictoryCompleted(player)
	if (player:GetTreasury():GetGoldBalance() >= ECONOMIC_VICTORY_GOLD_IN_TREASURY) then
		return true;
	end

	return false;
end

function GetCustomVictoryCompleted(player)
	if (GetEconomicVictoryCompleted(player)) then
		return 'VICTORY_CIVREV_ECONOMIC';
	end
end

function ProcessVictoryConditions(playerID)
  local player = Players[playerID];

	local victoryType = GetCustomVictoryCompleted(player);
	if (victoryType ~= nil) then
		Game.SetWinningTeam(player:GetTeam());
	end
end
Events.PlayerTurnActivated.Add(ProcessVictoryConditions);
