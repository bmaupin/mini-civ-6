include("WorldRankings");

local ECONOMIC_VICTORY_GOLD_IN_TREASURY = 20000;

local m_GenericIM:table = InstanceManager:new("GenericInstance", "ButtonBG", Controls.GenericViewStack);
local m_GenericTeamIM:table = InstanceManager:new("GenericTeamInstance", "ButtonFrame", Controls.GenericViewStack);

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

-- Logic adapted from DLC/NubiaScenario/UI/Replacements/WorldRankings_NubiaScenario.lua
function ViewGeneric(victoryType)
	ResetState(function() ViewGeneric(victoryType); end);
	Controls.GenericView:SetHide(false);

	ChangeActiveHeader("GENERIC", m_GenericHeaderIM, Controls.GenericViewHeader);

	local victoryInfo:table = GameInfo.Victories[victoryType];
	PopulateGenericHeader(RealizeGenericStackSize, victoryInfo.Name, nil, victoryInfo.Description, ICON_GENERIC);

	local genericData:table = GatherGenericData(victoryType);

	table.sort(genericData, function(a, b) return a.TeamScore > b.TeamScore; end);

	m_GenericIM:ResetInstances();
	m_GenericTeamIM:ResetInstances();

	for i, teamData in ipairs(genericData) do
		if #teamData.PlayerData > 1 then
			PopulateGenericTeamInstance(m_GenericTeamIM:GetInstance(), teamData, victoryType);
		elseif #teamData.PlayerData > 0 then
			-- elseif #teamData.PlayerData > 0 and teamData.PlayerData[1].PlayerID < 2 then
			PopulateGenericInstance(m_GenericIM:GetInstance(), teamData.PlayerData[1], victoryType, false);
		end
	end

	RealizeGenericStackSize();
end

function GatherGenericData(victoryType)
    local data = {};
    local victoryData = g_victoryData[victoryType];

    for teamID, team in pairs(Teams) do
        if teamID >= 0 then
            local teamData = {
                TeamID = teamID,
                PlayerData = {},
                TeamScore = 0
            };

            for _, playerID in ipairs(team) do
                if IsAliveAndMajor(playerID) then
                    local pPlayer = Players[playerID];
                    local playerScore = victoryData.GetScore(pPlayer);
                    local playerText = victoryData.GetText(pPlayer);

                    table.insert(teamData.PlayerData, {
                        PlayerID = playerID,
                        PlayerScore = playerScore,
                        PlayerText = playerText
                    });

                    teamData.TeamScore = math.max(teamData.TeamScore, playerScore);
                end
            end

            if #teamData.PlayerData > 0 then
                table.insert(data, teamData);
            end
        end
    end

    return data;
end

function PopulateGenericInstance(instance, playerData, victoryType, showTeamDetails)
    PopulatePlayerInstanceShared(instance, playerData.PlayerID)
    instance.Details:SetText(playerData.PlayerText)
    instance.ButtonBG:SetSizeY(SIZE_SCORE_ITEM_DEFAULT)
end
