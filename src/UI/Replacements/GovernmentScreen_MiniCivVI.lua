include "GovernmentScreen";

-- Copy the original function from the game
local BASE_RealizeTabs = RealizeTabs;

function RealizeTabs()
	BASE_RealizeTabs();
    Controls.ButtonPolicies:SetHide(true);
end
