-------------------------------------------------------
-- Local Variables
-------------------------------------------------------
local AM = "AbstractionMarks"  -- AM Title
local AMF = "AbstractionMarksFlares"   -- AMFlares Title
local versionNum = GetAddOnMetadata("AbstractionMarks", "Version")
local curVer = versionNum      -- Version Number

-------------------------------------------------------
-- Default variables
-------------------------------------------------------
Defaults = {
	shown = true,
	vertical = false,
	locked = true,
	clamped = true,
	tooltips = false,
	backgroundHide = false,
	disabled = false,
	markerScale = 1,
	flareScale = 1,
	buttonScale = 1,
	buttonsEnabled = true,
	partyTime = 5,
	raidTime = 10,
	breakTime = 5,
}
defaultDefault = {
	shown = true,
	vertical = false,
	locked = true,
	clamped = true,
	tooltips = false,
	backgroundHide = false,
	disabled = false,
	markerScale = 1,
	flareScale = 1,
	buttonScale = 1,
	buttonsEnabled = true,
	partyTime = 5,
	raidTime = 10,
	breakTime = 5,
}
for i, val in ipairs(Defaults) do if val == nil then Defaults[i] = defaultDefault[i] end end
local isPullTimerStarted = false
local isBreakTimerStarted = false
local playerOutOfCombat = true
local last = nil
local textPrefix = "/"
--Helper function for setting common frame attributes
-------------------------------------------------------
-- backdrops for frame
-------------------------------------------------------

local editBoxBackdrop = {
	bgFile = "Interface\\COMMON\\Common-Input-Border",
	tile = false,
}

-------------------------------------------------------
-- Main frames <<-- Unnecessary
-------------------------------------------------------

---------
--Temp Compatibility Variables
----------

local AM_IconFrame = AbsMarks
local AM_mainFrame = AbsMarks
local AM_Flares_mainFrame = AbsFlares
local AM_FlareFrame = AbsFlares

-------------------------------------------------------
-- AM Icon Frame and Icons
-------------------------------------------------------

--Used as a debug button
--AM_LockIcon:SetScript("OnClick", function(self) name,_,_,isEnabled,_,_,_ = GetAddOnInfo("DBM-Cores") SendChatMessage(isEnabled) end)

-------------------------------------------------------
-- AM_Flares Main Frame and Movers
-------------------------------------------------------

-------------------------------------------------------
-- The AM_Flare Frame and AM_Flares
-------------------------------------------------------
------ TEMPORARY WORKAROUND
local AM_FlareWhite = AbsFlares.flares[1]
local AM_FlareRed = AbsFlares.flares[2]
local AM_FlareBlue = AbsFlares.flares[3]
local AM_FlareSilver = AbsFlares.flares[4]
local AM_FlareGreen = AbsFlares.flares[5]
local AM_FlarePurple = AbsFlares.flares[6]
local AM_FlareOrange = AbsFlares.flares[7]
local AM_FlareYellow = AbsFlares.flares[8]
local AM_FlareClear = AbsFlares.flares[9]

-------------------------------------------------------
-- Readycheck and dbm buttons
-------------------------------------------------------

AM_Console_mainFrame = CreateFrame("Frame", "AM_Console_mainFrame", UIParent)
AM_Console_mainFrame:SetBackdrop(defaultBackdrop)
AM_Console_mainFrame:SetBackdropColor(0.1,0.1,0.1,0.1,0.7)
AM_Console_mainFrame:EnableMouse(true)
AM_Console_mainFrame:SetMovable(true)
AM_Console_mainFrame:SetSize(81,84)
AM_Console_mainFrame:SetPoint("TOP", UIParent, "TOP",0,-40)
AM_Console_mainFrame:SetClampedToScreen(true)

-------------------------------------------------------
-- The AM_Flare Frame and AM_Flares
-------------------------------------------------------
local AM_ConsoleFrame = CreateFrame("Frame", "AM_ConsoleFrame", AM_Console_mainFrame)
AM_ConsoleFrame:SetBackdrop(defaultBackdrop)
AM_ConsoleFrame:SetBackdropColor(0.1,0.1,0.1,0.1,0.7)
AM_ConsoleFrame:EnableMouse(true)
AM_ConsoleFrame:SetMovable(true)
AM_ConsoleFrame:SetSize(81,84)
AM_ConsoleFrame:SetPoint("LEFT", AM_Console_mainFrame, "LEFT")
AM_ConsoleFrame:SetClampedToScreen(true)
AM_ConsoleFrame:SetScript("OnMouseDown", function(self,button) if (button=="LeftButton" and Defaults.locked == false) then AM_Console_mainFrame:StartMoving() end end)
AM_ConsoleFrame:SetScript("OnMouseUp", function(self) AM_Console_mainFrame:StopMovingOrSizing() end)

local AM_ReadyCheck = CreateFrame("Button", "AM_ReadyCheck", AM_ConsoleFrame, "SecureActionButtonTemplate")
AM_ReadyCheck:SetSize(81,26)
AM_ReadyCheck:SetNormalTexture("Interface\\AddOns\\AbstractionMarks\\Media\\ReadyCheckUp")
AM_ReadyCheck:GetNormalTexture():SetTexCoord(0,1,0,1)
AM_ReadyCheck:SetPoint("TOP", AM_ConsoleFrame, "TOP",0,0)
AM_ReadyCheck:EnableMouse(true)
AM_ReadyCheck:SetAttribute("type", "macro")
AM_ReadyCheck:SetAttribute("macrotext1", "/readycheck")
AM_ReadyCheck:SetScript("OnMouseDown", function(self,button) if (button=="LeftButton") then AM_ReadyCheck:SetNormalTexture("Interface\\AddOns\\AbstractionMarks\\Media\\ReadyCheckDown") end end)
AM_ReadyCheck:SetScript("OnMouseUp", function(self) AM_ReadyCheck:SetNormalTexture("Interface\\AddOns\\AbstractionMarks\\Media\\ReadyCheckUp") end)

local AM_Pull = CreateFrame("Button", "AM_Pull", AM_ConsoleFrame, "SecureActionButtonTemplate")
AM_Pull:SetSize(81,26)
AM_Pull:SetNormalTexture("Interface\\AddOns\\AbstractionMarks\\Media\\PullUp")
AM_Pull:GetNormalTexture():SetTexCoord(0,1,0,1)
AM_Pull:SetPoint("TOP", AM_ReadyCheck, "BOTTOM",0,0)
AM_Pull:EnableMouse(true)
AM_Pull:SetAttribute("type", "macro")
AM_Pull:SetAttribute("macrotext1", textPrefix.."pull 15")
AM_Pull:SetScript("OnMouseDown", function(self,button) if (button=="LeftButton") then AM_Pull:SetNormalTexture("Interface\\AddOns\\AbstractionMarks\\Media\\PullDown") end end)
AM_Pull:SetScript("OnMouseUp", function(self) AM_Pull:SetNormalTexture("Interface\\AddOns\\AbstractionMarks\\Media\\PullUp") AM_pullCommon() end)
	
local AM_Break = CreateFrame("Button", "AM_Break", AM_ConsoleFrame, "SecureActionButtonTemplate")
AM_Break:SetSize(81,26)
AM_Break:SetNormalTexture("Interface\\AddOns\\AbstractionMarks\\Media\\BreakUp")
AM_Break:GetNormalTexture():SetTexCoord(0,1,0,1)
AM_Break:SetPoint("TOP", AM_Pull, "BOTTOM",0,0)
AM_Break:EnableMouse(true)
AM_Break:SetAttribute("type", "macro")
AM_Break:SetAttribute("macrotext1", textPrefix.."break 5")
AM_Break:SetScript("OnMouseDown", function(self,button) if (button=="LeftButton") then AM_Break:SetNormalTexture("Interface\\AddOns\\AbstractionMarks\\Media\\BreakDown") end end)
AM_Break:SetScript("OnMouseUp", function(self) AM_Break:SetNormalTexture("Interface\\AddOns\\AbstractionMarks\\Media\\BreakUp") AM_breakCommon() end)

-------------------------------------------------------
-- Functions
-------------------------------------------------------
function AM_pullCommon()
	if playerOutOfCombat == true then
		AM_AddonCheck()
		if IsInRaid() then
			countdownTime = Defaults.raidTime
			chatChan = "RAID_WARNING"
		elseif not IsInRaid() then
			countdownTime = Defaults.partyTime
			chatChan = "PARTY"
		end
		if isPullTimerStarted == true then
			AM_Pull:SetAttribute("macrotext1", textPrefix.."pull 0")
			SendChatMessage("PULL TIMER CANCELLED", chatChan)
			isPullTimerStarted = false
		elseif isPullTimerStarted == false then
			AM_Pull:SetAttribute("macrotext1", textPrefix.."pull "..countdownTime)
			isPullTimerStarted = true
			pullTimer = C_Timer.NewTimer(countdownTime, AM_resetPull)
		end
	end
end
function AM_breakCommon()
	if playerOutOfCombat == true then
		AM_AddonCheck()
		if IsInRaid() then
			chatChan = "RAID_WARNING"
		elseif not IsInRaid() then
			chatChan = "PARTY"
		end
		if isBreakTimerStarted == true then
			AM_Break:SetAttribute("macrotext1", textPrefix.."break 0")
			SendChatMessage("BREAK TIMER CANCELLED", chatChan)
			isBreakTimerStarted = false
		elseif isBreakTimerStarted == false then
			AM_Break:SetAttribute("macrotext1", textPrefix.."break "..Defaults.breakTime)
			isBreakTimerStarted = true
			breakTimer = C_Timer.NewTimer(math.floor((Defaults.breakTime*60)), AM_resetBreak)
		end
	end
end

function AM_resetPull()
	isPullTimerStarted = false
end

function AM_resetBreak()
	isBreakTimerStarted = false
end

function AM_lock()
    Defaults.locked = true
	AM_mainFrame:EnableMouse(false)
	AM_mainFrame:SetMovable(false)
    AM_LockIcon:GetNormalTexture():SetTexCoord(0, 0.25, 0, 1)
end

function AM_unlock()
    Defaults.locked = false
	AM_mainFrame:EnableMouse(true)
	AM_mainFrame:SetMovable(true)
    AM_LockIcon:GetNormalTexture():SetTexCoord(0.25, 0.50, 0, 1)
end

function AM_lockToggle()
    if Defaults.locked then AM_unlock("main") else AM_lock("main") end
end 

AM_LockIcon:SetScript("OnClick", function(self) AM_lockToggle() end)  

function AM_time(self, DB)
	if self == nil then return end
	if DB == "party" then
		Defaults.partyTime = (self:GetValue())
		getglobal(self:GetName().."Text"):SetText("Party Pull Time: "..math.floor(Defaults.partyTime).."sec")
	elseif DB == "raid" then
		Defaults.raidTime = (self:GetValue())
		getglobal(self:GetName().."Text"):SetText("Raid Pull Time: "..math.floor(Defaults.raidTime).."sec")
	elseif DB == "break" then
		Defaults.breakTime = (self:GetValue())
		getglobal(self:GetName().."Text"):SetText("Break Time: "..math.floor(Defaults.breakTime).."min")
	end
end

function AM_scale(self, DB)
	if self == nil then return end
	if DB == "main" then
		Defaults.markerScale = (self:GetValue())
		getglobal(self:GetName().."Text"):SetText("Marker scale: "..math.floor((Defaults.markerScale*100)).."%")
		AM_mainFrame:SetScale(Defaults.markerScale)
	elseif DB == "flare" then
		Defaults.flareScale = (self:GetValue())
		getglobal(self:GetName().."Text"):SetText("Flares scale: "..math.floor((Defaults.flareScale*100)).."%")
		AM_Flares_mainFrame:SetScale(Defaults.flareScale)
	end
end

function AM_backgroundChange()
	if Defaults.backgroundHide == true then
		AM_IconFrame:SetBackdropColor(0,0,0,0)
		AM_IconFrame:SetBackdropBorderColor(0,0,0,0)
		AM_FlareFrame:SetBackdropColor(0,0,0,0)
		AM_FlareFrame:SetBackdropBorderColor(0,0,0,0)
		AM_ConsoleFrame:SetBackdropColor(0,0,0,0)
		AM_ConsoleFrame:SetBackdropBorderColor(0,0,0,0)
	elseif Defaults.backgroundHide == false then
		AM_IconFrame:SetBackdropColor(0.1,0.1,0.1,0.7)
		AM_IconFrame:SetBackdropBorderColor(1,1,1,1)
		AM_FlareFrame:SetBackdropColor(0.1,0.1,0.1,0.7)
		AM_FlareFrame:SetBackdropBorderColor(1,1,1,1)
		AM_ConsoleFrame:SetBackdropColor(0.1,0.1,0.1,0.7)
		AM_ConsoleFrame:SetBackdropBorderColor(0.1,0.1,0.1,0.1,0.7)
	end
end

function AM_makeVertical()
--[[  for i = 2, 8 do
    AbsMarks.marks[i]:ClearAllPoints()
    AbsFlares.flares[i-1]:ClearAllPoints()
  end
  AbsFlares.flares[9]:ClearAllPoints()]]
  if Defaults.vertical == true then
    AbsFlares:SetSize(35,230)
    AbsMarks:SetSize(30, 206)
 --   AbsMarks.marks[8]:SetPoint("TOPLEFT", AbsMarks, "TOPLEFT", 5, -5)
 --   AbsFlares.flares[1]:SetPoint("TOPLEFT", AbsFlares, "TOPLEFT", 5, -5)  
    for i = 2, 8 do
      local t = 9 - i
      AbsMarks.marks[t]:SetPoint("TOPLEFT", AbsMarks.marks[t+1], "BOTTOMLEFT", 0, -2)
      AbsFlares.flares[i]:SetPoint("TOPLEFT", AbsFlares.flares[i-1], "BOTTOMLEFT")
    end
    AbsFlares.flares[9]:SetPoint("TOPLEFT", AbsFlares.flares[8], "BOTTOMLEFT")
    AM_LockIcon:SetPoint("TOPLEFT", AbsMarks.marks[1], "BOTTOMLEFT", 0, -2)
  elseif Defaults.vertical == false then
    AbsFlares:SetSize(230,35)
    AbsMarks:SetSize(190, 30)
    for i = 2, 8 do
      local t = 9 - i
      AbsMarks.marks[t]:SetPoint("TOPLEFT", AbsMarks.marks[t+1], "TOPRIGHT")
      AbsFlares.flares[i]:SetPoint("TOPLEFT", AbsFlares.flares[i-1], "TOPRIGHT")
    end
    AbsFlares.flares[9]:SetPoint("TOPLEFT", AbsFlares.flares[8], "TOPRIGHT")
    AM_LockIcon:SetPoint("TOPLEFT", AbsMarks.marks[1], "TOPRIGHT")
	end
end

function AM_disable()
  if Defaults.disabled == true then
    AbsMarks:Hide()
    AbsFlares:Hide()
    AM_ConsoleFrame:Hide()

	elseif Defaults.disabled == false then
    AbsMarks:Show()
    AbsFlares:Show()
    AM_ConsoleFrame:Show()
	end
end

function AM_SavePositions()
	local f_ap, _, _, f_x, f_y = AM_Flares_mainFrame:GetPoint()
	local m_ap, _, _, m_x, m_y = AM_mainFrame:GetPoint()
	Defaults.FlaresAP = f_ap
	Defaults.FlaresX = f_x
	Defaults.FlaresY = f_y	
	Defaults.MarkersAP = m_ap
	Defaults.MarkersX = m_x
	Defaults.MarkersY = m_y
end

function AM_SetPositions()
	if (Defaults.MarkersX ~= nil) then
		AM_mainFrame:ClearAllPoints()
		AM_Flares_mainFrame:ClearAllPoints()
		AM_mainFrame:SetPoint(Defaults.MarkersAP, UIParent, Defaults.MarkersX, Defaults.MarkersY)
		AM_Flares_mainFrame:SetPoint(Defaults.FlaresAP, UIParent, Defaults.FlaresX, Defaults.FlaresY)
		AM_CheckUpdater()
	end
end

function AM_CheckUpdater()
	AbstractionMarksVertCheck:SetChecked(Defaults.vertical)
	if Defaults.vertical == true then
		AM_makeVertical()
	end
	AbstractionMarksBackgroundCheck:SetChecked(Defaults.backgroundHide)
	if Defaults.backgroundHide == true then
		AM_backgroundChange()
	end
	AbstractionMarksDisablerCheck:SetChecked(Defaults.disabled)
	if Defaults.disabled == true then
		AM_disable()
	end
	AM_mainFrame:SetScale(Defaults.markerScale);
	AM_Flares_mainFrame:SetScale(Defaults.flareScale)
end

function AM_UpdatePullTimer(time_to_zero)
	if (not time_to_zero) then
		return false
	end
	if (math.ceil(time_to_zero - GetTime()) > 0) then
		isPullTimerStarted = true
	elseif (math.ceil(time_to_zero - GetTime()) <= 0) then
		isPullTimerStarted = false
	end
end

function AM_AddonCheck()
	local isEnabledDBM = IsAddOnLoaded("DBM-Core")
	local isEnabledBigWigs = IsAddOnLoaded("BigWigs")
	if (not isEnabledDBM and not isEnabledBigWigs) then DEFAULT_CHAT_FRAME:AddMessage("A Bossmod, such as Deadly Boss Mods or BigWigs, is required for the Pull and Break timer operations within AbstractionMarks.  ReadyCheck, Markers, and Flares will continue to work without these additional addons.") end
end

-------------------------------------------------------
-- Options
-------------------------------------------------------
AbstractionMarksOptions = {};
AbstractionMarksOptions.panel = CreateFrame( "Frame", "AbstractionMarksOptions", InterfaceOptionsFramePanelContainer );
AbstractionMarksOptions.panel.name = "Abstraction Marks";
InterfaceOptions_AddCategory(AbstractionMarksOptions.panel);

local AbstractionMarksOptionsTitle = AbstractionMarksOptions.panel:CreateFontString("AbstractionMarksOptionsTitle", "OVERLAY", "ChatFontNormal")
AbstractionMarksOptionsTitle:SetPoint("TOP", AbstractionMarksOptions.panel, "TOP",0,-10) 
AbstractionMarksOptionsTitle:SetText("|cffe1a500 AbstractionMarks Options")

local AbstractionMarksVertCheck = CreateFrame("CheckButton", "AbstractionMarksVertCheck", AbstractionMarksOptions.panel, "UICheckButtonTemplate")
AbstractionMarksVertCheck:SetPoint("LEFT",AbstractionMarksOptions.panel,"TOPLEFT",10,-50)
AbstractionMarksVertCheck:SetSize(20,20)
AbstractionMarksVertCheck:SetScript("OnClick", function(self) Defaults.vertical = not Defaults.vertical; AM_makeVertical() end)
local AbstractionMarksVertText = AbstractionMarksOptions.panel:CreateFontString("vertText", "OVERLAY", "ChatFontSmall")
AbstractionMarksVertText:SetPoint("LEFT", AbstractionMarksVertCheck , "RIGHT", 5,0)
AbstractionMarksVertText:SetText("|cffe1a500 Display vertically")

local AbstractionMarksBackgroundCheck = CreateFrame("CheckButton", "AbstractionMarksBackgroundCheck", AbstractionMarksOptions.panel, "UICheckButtonTemplate")
AbstractionMarksBackgroundCheck:SetPoint("TOP",AbstractionMarksVertCheck,"BOTTOM",0,-5)
AbstractionMarksBackgroundCheck:SetSize(20,20)
AbstractionMarksBackgroundCheck:SetScript("OnClick", function(self) Defaults.backgroundHide = not Defaults.backgroundHide; AM_backgroundChange() end)
local AbstractionMarksBackgroundText = AbstractionMarksOptions.panel:CreateFontString("AbstractionMarksBackgroundText", "OVERLAY", "ChatFontSmall")
AbstractionMarksBackgroundText:SetPoint("LEFT", AbstractionMarksBackgroundCheck, "RIGHT", 5,0)
AbstractionMarksBackgroundText:SetText("|cffe1a500 Hide background and border")

local AbstractionMarksDisablerCheck = CreateFrame("CheckButton", "AbstractionMarksDisablerCheck", AbstractionMarksOptions.panel, "UICheckButtonTemplate")
AbstractionMarksDisablerCheck:SetPoint("TOP",AbstractionMarksBackgroundCheck,"BOTTOM",0,-5)
AbstractionMarksDisablerCheck:SetSize(20,20)
AbstractionMarksDisablerCheck:SetScript("OnClick", function(self) Defaults.disabled = not Defaults.disabled; AM_disable() end)
local AbstractionMarksDisablerText = AbstractionMarksOptions.panel:CreateFontString("AbstractionMarksDisablerText", "OVERLAY", "ChatFontSmall")
AbstractionMarksDisablerText:SetPoint("LEFT", AbstractionMarksDisablerCheck, "RIGHT", 5,0)
AbstractionMarksDisablerText:SetText("|cffe1a500 Disable AbstractionMarks")

local AbstractionMarksParty = CreateFrame("Slider", "AbstractionMarksParty", AbstractionMarksOptions.panel, "OptionsSliderTemplate")
AbstractionMarksParty:SetPoint("TOPLEFT", AbstractionMarksDisablerCheck, "BOTTOMLEFT",0,-25)
AbstractionMarksParty:SetSize(180,16)
AbstractionMarksParty:SetMinMaxValues(3,30)
AbstractionMarksParty:SetValue(math.floor(Defaults.partyTime))
AbstractionMarksParty:SetValueStep(1.0)
AbstractionMarksParty:SetOrientation("HORIZONTAL")
getglobal(AbstractionMarksParty:GetName().."Low"):SetText("3sec")
getglobal(AbstractionMarksParty:GetName().."High"):SetText("30sec")
getglobal(AbstractionMarksParty:GetName().."Text"):SetText("Party Pull Time: "..math.floor(Defaults.partyTime).."sec")
AbstractionMarksParty:SetValue(Defaults.partyTime)
AbstractionMarksParty:SetScript("OnValueChanged", function(self) AM_time(self, "party") end)
AbstractionMarksParty:SetScript("OnLoad", function(self) AM_time(self, "party") end)

local AbstractionMarksRaid = CreateFrame("Slider", "AbstractionMarksRaid", AbstractionMarksOptions.panel, "OptionsSliderTemplate")
AbstractionMarksRaid:SetPoint("TOPLEFT", AbstractionMarksParty, "BOTTOMLEFT",0,-25)
AbstractionMarksRaid:SetSize(180,16)
AbstractionMarksRaid:SetMinMaxValues(3,30)
AbstractionMarksRaid:SetValue(math.floor(Defaults.raidTime))
AbstractionMarksRaid:SetValueStep(1)
AbstractionMarksRaid:SetOrientation("HORIZONTAL")
getglobal(AbstractionMarksRaid:GetName().."Low"):SetText("3sec")
getglobal(AbstractionMarksRaid:GetName().."High"):SetText("30sec")
getglobal(AbstractionMarksRaid:GetName().."Text"):SetText("Raid Pull Time: "..math.floor(Defaults.raidTime).."sec")
AbstractionMarksRaid:SetValue(Defaults.raidTime)
AbstractionMarksRaid:SetScript("OnValueChanged", function(self) AM_time(self, "raid") end)
AbstractionMarksRaid:SetScript("OnLoad", function(self) AM_time(self, "raid") end)

local AbstractionMarksBreak = CreateFrame("Slider", "AbstractionMarksBreak", AbstractionMarksOptions.panel, "OptionsSliderTemplate")
AbstractionMarksBreak:SetPoint("TOPLEFT", AbstractionMarksRaid, "BOTTOMLEFT",0,-25)
AbstractionMarksBreak:SetSize(180,16)
AbstractionMarksBreak:SetMinMaxValues(1,60)
AbstractionMarksBreak:SetValue(math.floor(Defaults.breakTime))
AbstractionMarksBreak:SetValueStep(1)
AbstractionMarksBreak:SetOrientation("HORIZONTAL")
getglobal(AbstractionMarksBreak:GetName().."Low"):SetText("1min")
getglobal(AbstractionMarksBreak:GetName().."High"):SetText("60min")
getglobal(AbstractionMarksBreak:GetName().."Text"):SetText("Break Time: "..math.floor(Defaults.breakTime).."min")
AbstractionMarksBreak:SetValue(Defaults.breakTime)
AbstractionMarksBreak:SetScript("OnValueChanged", function(self) AM_time(self, "break") end)
AbstractionMarksBreak:SetScript("OnLoad", function(self) AM_time(self, "break") end)

local AbstractionMarksScale = CreateFrame("Slider", "AbstractionMarksScale", AbstractionMarksOptions.panel, "OptionsSliderTemplate")
AbstractionMarksScale:SetPoint("TOPLEFT", AbstractionMarksBreak, "BOTTOMLEFT",0,-25)
AbstractionMarksScale:SetSize(180,16)
AbstractionMarksScale:SetMinMaxValues(0.5,1.5)
AbstractionMarksScale:SetValue(1)
AbstractionMarksScale:SetValueStep(0.01)
AbstractionMarksScale:SetOrientation("HORIZONTAL")
getglobal(AbstractionMarksScale:GetName().."Low"):SetText("50%")
getglobal(AbstractionMarksScale:GetName().."High"):SetText("150%")
getglobal(AbstractionMarksScale:GetName().."Text"):SetText("Marker scale: "..math.floor((Defaults.markerScale*100)).."%")
AbstractionMarksScale:SetValue(Defaults.markerScale)
AbstractionMarksScale:SetScript("OnValueChanged", function(self) AM_scale(self, "main") end)
AbstractionMarksScale:SetScript("OnLoad", function(self) AM_scale(self, "main") end)

local AbstractionMarksScaleFlares = CreateFrame("Slider", "AbstractionMarksScaleFlares", AbstractionMarksOptions.panel, "OptionsSliderTemplate")
AbstractionMarksScaleFlares:SetPoint("TOPLEFT", AbstractionMarksScale, "BOTTOMLEFT",0,-25)
AbstractionMarksScaleFlares:SetSize(180,16)
AbstractionMarksScaleFlares:SetMinMaxValues(0.5,1.5)
AbstractionMarksScaleFlares:SetValue(1)
AbstractionMarksScaleFlares:SetValueStep(0.01)
AbstractionMarksScaleFlares:SetOrientation("HORIZONTAL")
getglobal(AbstractionMarksScaleFlares:GetName().."Low"):SetText("50%")
getglobal(AbstractionMarksScaleFlares:GetName().."High"):SetText("150%")
getglobal(AbstractionMarksScaleFlares:GetName().."Text"):SetText("Flares scale: "..math.floor((Defaults.flareScale*100)).."%")
AbstractionMarksScaleFlares:SetValue(Defaults.flareScale)
AbstractionMarksScaleFlares:SetScript("OnValueChanged", function(self) AM_scale(self, "flare") end)
AbstractionMarksScaleFlares:SetScript("OnLoad", function(self) AM_scale(self, "flare") end)

-------------------------------------------------------
-- OnEvent
-------------------------------------------------------
local AM_OnUpdate = CreateFrame("Frame")
AM_OnUpdate:RegisterEvent("ADDON_LOADED")
AM_OnUpdate:RegisterEvent("PLAYER_LOGOUT")
AM_OnUpdate:RegisterEvent("PLAYER_LOGIN")
AM_OnUpdate:RegisterEvent("PLAYER_ENTERING_WORLD")
AM_OnUpdate:RegisterEvent("PLAYER_REGEN_DISABLED")
AM_OnUpdate:RegisterEvent("PLAYER_REGEN_ENABLED")
AM_OnUpdate:RegisterEvent("CHAT_MSG_ADDON")

AM_OnUpdate:SetScript("OnEvent", function(self,event,addon,...)
	if (event=="PLAYER_LOGOUT" or event=="PLAYER_ENTERING_WORLD") then
		AM_SavePositions()
	end
	if (event=="PLAYER_LOGIN") then
		AM_SetPositions()
	end
	if (event=="PLAYER_REGEN_DISABLED") then
		isPullTimerStarted = false
		isBreakTimerStarted = false
		playerOutOfCombat = false
	end
	if (event=="PLAYER_REGEN_ENABLED") then
		isPullTimerStarted = false
		isBreakTimerStarted = false
		playerOutOfCombat = true
	end
	if (event=="CHAT_MSG_ADDON") then
		if (prefix == "BigWigs" and string.find(message, "Pull") ) then
			last = GetTime()
			local timer = string.match(message, "%d+")
			timer = tonumber(timer)
			time_to_zero = GetTime() + timer
			AM_UpdatePullTimer(time_to_zero)
		elseif prefix == "D4" and string.find(message, "PT") then
			last = GetTime()
			local timer = string.match(message, "\t(%d+)\t")
			timer = tonumber(timer)
			time_to_zero = GetTime() + timer
			AM_UpdatePullTimer(time_to_zero)
		end
	end
end)

-------------------------------------------------------
-- Slash Commands
-------------------------------------------------------

SLASH_MB1 = '/AM'
SLASH_MB2 = '/AbstractionMarks'
function SlashCmdList.MB(msg, editbox)
	local chan
	if (msg=="options") then
		InterfaceOptionsFrame_OpenToCategory(AbstractionMarksOptions.panel)
		InterfaceOptionsFrame_OpenToCategory(AbstractionMarksOptions.panel)
    elseif (msg=="toggle") then
    	Defaults.disabled = not Defaults.disabled
    	AM_disable()
	else
		DEFAULT_CHAT_FRAME:AddMessage("use /AM options to open configuration screen")
	end
end