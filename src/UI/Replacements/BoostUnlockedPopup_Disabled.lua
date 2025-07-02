-- BoostUnlockedPopup_Disabled
-- Author: Zur13
-- DateCreated: 5/2/2019 8:00:21 PM
--------------------------------------------------------------

include("BoostUnlockedPopup");

local ORIG_OnNotificationPanel_ShowTechBoost = OnNotificationPanel_ShowTechBoost;
local ORIG_OnNotificationPanel_ShowCivicBoost = OnNotificationPanel_ShowCivicBoost;

local techBoostPopUpRequests = {}; -- KEY - playerID; VALUE - { KEY - techID; VALUE - request counter }
local civicBoostPopUpRequests = {}; -- KEY - playerID; VALUE - { KEY - civicID; VALUE - request counter }

function ProcessTechBoostPopupRequest( ePlayer, techIndex, iTechProgress, eSource )
	local res = false;
	if ePlayer == Game.GetLocalPlayer() then
		local pStor = techBoostPopUpRequests[ ePlayer ];
		if pStor == nil then
			pStor = {};
			techBoostPopUpRequests[ ePlayer ] = pStor;
		end
		local pTech = pStor[ techIndex ];
		if pTech ~= nil then
			pTech = pTech + 1;
			res = true;
		else
			pTech = 1;
		end
		-- Update player tech popup requests
		pStor[ techIndex ] = pTech;
	end
	return res;
end

function ProcessCivicBoostPopupRequest( ePlayer, civicIndex, iCivicProgress, eSource )
	local res = false;
	if ePlayer == Game.GetLocalPlayer() then
		local pStor = civicBoostPopUpRequests[ ePlayer ];
		if pStor == nil then
			pStor = {};
			civicBoostPopUpRequests[ ePlayer ] = pStor;
		end
		local pCivic = pStor[ civicIndex ];
		if pCivic ~= nil then
			pCivic = pCivic + 1;
			res = true;
		else
			pCivic = 1;
		end
		-- Update player tech popup requests
		pStor[ civicIndex ] = pCivic;
	end
	return res;
end

function OnNotificationPanel_ShowTechBoost( ePlayer, techIndex, iTechProgress, eSource )
	-- Show tech boost only on second time it is called
	print( "Tech boost popup request" );
	if ProcessTechBoostPopupRequest( ePlayer, techIndex, iTechProgress, eSource ) then
		DoTechBoost( ePlayer, techIndex, iTechProgress, eSource );
	end
end

function OnNotificationPanel_ShowCivicBoost( ePlayer, civicIndex, iCivicProgress, eSource )
	-- Show civic boost only on second time it is called
	print( "Civic boost popup request" );
	if ProcessCivicBoostPopupRequest( ePlayer, civicIndex, iCivicProgress, eSource ) then
		DoCivicBoost( ePlayer, civicIndex, iCivicProgress, eSource );
	end
end

-- ===========================================================================
function InitializeBoostUnlockPopupDisabled()

	LuaEvents.NotificationPanel_ShowTechBoost.Remove( ORIG_OnNotificationPanel_ShowTechBoost );
	LuaEvents.NotificationPanel_ShowCivicBoost.Remove( ORIG_OnNotificationPanel_ShowCivicBoost );

	LuaEvents.NotificationPanel_ShowTechBoost.Add( OnNotificationPanel_ShowTechBoost );
	LuaEvents.NotificationPanel_ShowCivicBoost.Add( OnNotificationPanel_ShowCivicBoost );

	print(" Disable Tech/Civic Boosted Popup Initialized ");
end

InitializeBoostUnlockPopupDisabled();