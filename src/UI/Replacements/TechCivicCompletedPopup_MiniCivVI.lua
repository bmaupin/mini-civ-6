include "TechCivicCompletedPopup";

-- Copy the original function from the game
local BASE_ShowCivicCompletedPopup = ShowCivicCompletedPopup;

function ShowCivicCompletedPopup( player, civic, quote, audio )
    BASE_ShowCivicCompletedPopup(player, civic, quote, audio);

    local civicInfo = GameInfo.Civics[civic];
    if civicInfo == nil then
        UI.DataError("Cannot show civic popup because GameInfo.Civics["..tostring(civic).."] doesn't have data.");
        return;
    end

    local civicType = civicInfo.CivicType;
    ---@diagnostic disable-next-line: undefined-global
    local unlockableTypes = GetUnlockablesForCivic(civicType, player);
    local isCivicUnlockGovernmentType = false;

    -- Determine if we've unlocked a new government type
    for _,unlockItem in ipairs(unlockableTypes) do
        local typeInfo = GameInfo.Types[unlockItem[1]];
        if(typeInfo and typeInfo.Kind == "KIND_GOVERNMENT") then
            isCivicUnlockGovernmentType = true;
        end
    end

    -- In the original game, the government button becomes "Show Policies" if a new
    -- government isn't unlocked. Instead, hide it altogether.
    if not isCivicUnlockGovernmentType then
        Controls.ChangeGovernmentButton:SetHide(true);
    end
end