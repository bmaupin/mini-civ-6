Styles["VICTORY_CIVREV_ECONOMIC"] = {
  RibbonIcon = "ICON_VICTORY_SCORE",
  Ribbon = "EndGame_Ribbon_Time",
  RibbonTile = "EndGame_RibbonTile_Time",
  Background = "EndGame_BG_Time",
  Movie = "Time.bk2",
  SndStart = "Play_Cinematic_Endgame_Time",
  SndStop = "Stop_Cinematic_Endgame_Time",
  Color = "COLOR_VICTORY_SCORE",
};

local BASE_TeamVictoryData = TeamVictoryData;

local ECONOMIC_VICTORY_TYPE = "VICTORY_CIVREV_ECONOMIC";
local ECONOMIC_VICTORY_WINNER_PROPERTY = "MC6_EconomicVictoryWinner";

function TeamVictoryData(winningTeamID, victoryType)
  local economicVictoryWinner = Game:GetProperty(ECONOMIC_VICTORY_WINNER_PROPERTY);

  if economicVictoryWinner == winningTeamID then
    victoryType = ECONOMIC_VICTORY_TYPE;
  end

  return BASE_TeamVictoryData(winningTeamID, victoryType);
end
