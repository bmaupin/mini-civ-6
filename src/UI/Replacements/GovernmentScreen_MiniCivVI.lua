include "GovernmentScreen";

-- Copy the original function from the game
local BASE_RealizeTabs = RealizeTabs;

-- Override the RealizeTabs function to hide the policies tab button
function RealizeTabs()
    BASE_RealizeTabs();
    -- Hide the policies tab button
    Controls.ButtonPolicies:SetHide(true);
    -- Remove the gap caused by hiding the button
    Controls.ButtonPolicies:SetSizeX(0);
end

-- If the policies tab gets opened (for example, this will happen automatically after
-- accepting a government change), switch to the governments tab.
---@diagnostic disable-next-line: undefined-global
LuaEvents.GovernmentScreen_PolicyTabOpen.Add(OnOpenGovernmentScreenGovernments);
