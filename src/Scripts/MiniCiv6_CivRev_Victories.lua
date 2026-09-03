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

-- Functionality adapted from CiVI Reformation Victories (https://forums.civfanatics.com/resources/civi-reformation-victories.25796/)
function ProcessVictoryConditions(localPlayerOnly)
	print("**************************************** ProcessVictoryConditions()");
	local victoryType = "";
	local localPlayer = Players[Game.GetLocalPlayer()];

	victoryType = GetCustomVictoryCompleted(localPlayer);

	if (victoryType ~= "") then
		-- LuaEvents.CustomVictoryTriggered(localPlayer, victoryType, nil, nil);
		Game.SetWinningTeam(localPlayer:GetTeam());
	end

	if (not localPlayerOnly) then
		-- check if any other player or ai have achieved any custom victory type
		for i, player in ipairs(PlayerManager:GetAliveMajors()) do
			if (player:GetID() ~= player:GetID()) then
				victoryType = GetCustomVictoryCompleted(player);

				if (victoryType ~= "") then
					print("ProcessVictoryConditions: player=" .. player:GetID() .. ", reason=" .. victoryType);
          -- TODO: show player defeat if another player wins?
					-- LuaEvents.CustomVictoryTriggered(localPlayer, "DEFEAT_DEFAULT", player, victoryType);
					break;
				end
			end
		end
	end
end

function OnLocalPlayerTurnBegin()
	ProcessVictoryConditions(false);
end
Events.LocalPlayerTurnBegin.Add(OnLocalPlayerTurnBegin);
