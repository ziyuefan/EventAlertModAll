----------------------------------------------------
-- Assign addon space to local G var.  
-- For sync addon space to each lua fils
-----------------------------------------------------
local _
local _G = _G

local addonName, G = ... 
_G[addonName] = _G[addonName] or G
-----------------------------------
if LibDebug then LibDebug() end
-----------------------------------
G.WOW_VERSION = select(4,	GetBuildInfo())	-- Numric Version 
-----------------------------------
-- 檢查Lib_ZYF是否有先載入
--------------------------------
if (Lib_ZYF == nil ) then
	print("No Lib_ZYF loaded")	
	return
else
	print("Lib_ZYF loaded")
end
--------------------------------
-- 常用函數設為區域變數以提昇效能
--------------------------------
-- lua default command zone
local print = print
local pairs = pairs
local ipairs = ipairs
local tonumber = tonumber
local tostring = tostring
local type = type
local table = table
local select = select
local collectgarbage = collectgarbage
local hooksecurefunc = hooksecurefunc
-- lua table zone
local tinsert = table.insert
local tsort = table.sort
local tremove = table.remove
local tconcat = table.concat
local tcopy = table.copy

-- lua sting zone
local format = format
local strsplit = string.split
local strfind = string.find
local strmatch = string.match
local strgub = string.gsub
local strdump = string.dump
local stlen = string.len
local strlower = string.lower
local strupper = string.upper
local strchar = string.char
local strbyte = string.byte
local strgmatch = string.gmatch
local strrep = string.rep
local strreverse = string.reverse
local strsub = string.sub
-- WOW API zone
local CreateFrame = CreateFrame
local UnitBuff = UnitBuff
local UnitDebuff = UnitDebuff
local UnitAura = UnitAura
local UnitPower = UnitPower
local UnitPowerMax = UnitPowerMax
local UnitPowerType = UnitPowerType
local UnitAffectingCombat = UnitAffectingCombat
local UnitLevel = UnitLevel
local UnitClass = UnitClass
local UnitSpellHaste = UnitSpellHaste
local UnitName = UnitName
local UnitIsCorpse = UnitIsCorpse
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitIsEnemy = UnitIsEnemy
local UnitInRaid = UnitInRaid
local UnitInParty = UnitInParty
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitExists = UnitExists
local GetTime = GetTime
local GetActiveSpecGroup = GetActiveSpecGroup
local GetItemSpell = GetItemSpell 
local GetItemCooldown = GetItemCooldown
-- WOW API : ShapeshiftForm
local GetShapeshiftForm = GetShapeshiftForm
local GetShapeshiftFormID = GetShapeshiftFormID
-- WOW API : Specialization
local GetSpecialization = GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo
-- WOW API : Spell
local GetSpellCharges = GetSpellCharges
local GetSpellCooldown = GetSpellCooldown
local GetSpellInfo = GetSpellInfo
local GetSpellLink = GetSpellLink
local GetSpellTexture = GetSpellTexture
local IsUsableSpell = IsUsableSpell
local GetTotemInfo = GetTotemInfo
-- WOW API : Group
local GetNumSubgroupMembers = GetNumSubgroupMembers
-- WOW API : Widget
local UIParent = UIParent
local GameTooltip = GameTooltip
local UIFrameFadeIn = UIFrameFadeIn
local UIFrameFadeOut = UIFrameFadeOut
-- WOW API : System
local RegisterAllEvents = RegisterAllEvents
local RegisterEvent = RegisterEvent
local PlaySoundFile = PlaySoundFile
--------------------------------
-- EventAlertMod Var. 
--------------------------------
-- local EA_LISTSEC_SELF = 0
-- local EA_LISTSEC_TARGET = 0
-- local EA_SPEC_expirationTime1 = 0
-- local EA_SPEC_expirationTime2 = 0
G.LISTSEC 	= 	{
				SELF 	= 0, 
				TARGET 	= 0,
				}
G.SPEC		=	{
				expirationTime = {[1]=0,[2]=0}
				}
--------------------------------
local EA_FormType_FirstTimeCheck = true
local EA_ADDONS_NAME = "EventAlertMod"
EA_flagAllHidden = false
--------------------------------
-- For OnUpdate Using, only Gloabal Var.
--------------------------------             
G.UpdateInterval						= 0.1
--------------------------------
G.DEBUG = {}
--------------------------------   
local function EAFun_GetSpellItemEnable(EAItems)
	local SpellEnable = false
	if (EAItems ~= nil) then
		if (EAItems.enable) then SpellEnable = true end
	end
	return SpellEnable
end		
--------------------------------
local function EAFun_CheckSpellConditionMatch(EA_count, EA_unitCaster, EAItems)
	local ifAdd_buffCur, orderWtd = true, 1
	local SC_Stack, SC_Self = 1, false
	if (EAItems ~= nil) then
		if (EAItems.stack ~= nil) then SC_Stack = EAItems.stack end
		if (EAItems.self ~= nil) then SC_Self = EAItems.self end
		if (EAItems.orderwtd ~= nil) then orderWtd = EAItems.orderwtd end		
	end
	if (SC_Stack ~= nil and SC_Stack > 1) then		
		if (EA_count < SC_Stack) then ifAdd_buffCur = false end
	end
	if (SC_Self == true) then		
		if (EA_unitCaster ~= "player") then 
			ifAdd_buffCur = false 
		end	
	end
	return ifAdd_buffCur, orderWtd
end	
--------------------------------
-- The first event of this UI(Event sequence : "Onload"->"ADDON_LOADED")
------------------------------
	
function G:OnLoad(f)
	
	G.EventList = {
		--["PLAYER_LOGIN"]				=nil					,
		["ADDON_LOADED"]				= G.ADDON_LOADED,
		["PLAYER_ENTERING_WORLD"]		= G.PLAYER_ENTERING_WORLD,
		["PLAYER_DEAD"]					= G.PLAYER_ENTERING_WORLD,
		["PLAYER_ENTER_COMBAT"]			= G.PLAYER_ENTER_COMBAT,
		["PLAYER_LEAVE_COMBAT"]			= G.PLAYER_LEAVE_COMBAT,
		["PLAYER_REGEN_DISABLED"]		= G.PLAYER_ENTER_COMBAT,
		["PLAYER_REGEN_ENABLED"]		= G.PLAYER_LEAVE_COMBAT,
		["PLAYER_TALENT_UPDATE"]		= G.PLAYER_TALENT_UPDATE,
		-- ["PLAYER_TALENT_WIPE"]		= G.PLAYER_TALENT_WIPE,
		["PLAYER_TARGET_CHANGED"]		= G.TARGET_CHANGED,
		["ACTIVE_TALENT_GROUP_CHANGED"]	= G.ACTIVE_TALENT_GROUP_CHANGED,
		["COMBAT_LOG_EVENT_UNFILTERED"]	= G.COMBAT_LOG_EVENT_UNFILTERED ,
		--["COMBAT_TEXT_UPDATE"]		=G:COMBAT_TEXT_UPDATE,		
		["SPELL_UPDATE_COOLDOWN"]		= G.SPELL_UPDATE_COOLDOWN,
		["SPELL_UPDATE_CHARGES"]		= G.SPELL_UPDATE_CHARGES,
		["SPELL_UPDATE_USABLE"]			= G.SPELL_UPDATE_USABLE,
		["UPDATE_SHAPESHIFT_FORM"]		= G.UPDATE_SHAPESHIFT_FORM,
		["UNIT_SPELLCAST_START"]		= G.UNIT_SPELLCAST_START,
		["UNIT_SPELLCAST_CHANNEL_START"]= G.UNIT_SPELLCAST_CHANNEL_START,
		["UNIT_SPELLCAST_FAILED"]		= G.UNIT_SPELLCAST_FAILED,
		
		["UNIT_AURA"]						= G.UNIT_AURA,		
	--	["UNIT_COMBO_POINTS"]				= G.COMBO_POINTS,
		["UNIT_DISPLAYPOWER"]				= G.DISPLAYPOWER,
		["UNIT_HEALTH"]						= G.UNIT_HEALTH	,
		["UNIT_POWER_UPDATE"]				= G.UNIT_POWER_UPDATE,
		["UNIT_POWER_FREQUENT"]				= G.UNIT_POWER_UPDATE,
		["RUNE_TYPE_UPDATE"]				= G.UpdateRunes,
		["RUNE_POWER_UPDATE"]				= G.UpdateRunes,
		--["UNIT_SPELLCAST_SUCCEEDED"]		= G.UNIT_SPELLCAST_SUCCEEDED,		
		["PLAYER_TOTEM_UPDATE"]				= G.UNIT_PLAYER_TOTEM_UPDATE,	
		["BAG_UPDATE_COOLDOWN"]				= G.BAG_UPDATE_COOLDOWN,		
		["UPDATE_UI_WIDGET"]				= G.UPDATE_UI_WIDGET,		
		["UNIT_SPELLCAST_EMPOWER_START"]	= G.EMPOWER_START,
		["UNIT_SPELLCAST_EMPOWER_UPDATE"]	= G.EMPOWER_UPDATE,
	}
	
	
	for event, func in pairs(G.EventList) do		
		f:RegisterEvent(event)		
		f:SetScript("OnEvent", function(self, event, ...)
			func = G.EventList[event]
			if type(func) == "function" then 
				func(self, event, ...)
			end
		end
		)
	end
	
	-- Init Slash Command as function name 
	G:InitSlashCommand()
	-- Init Main Array
	-- G:InitArray()	
	
	 -- local tempInterval = 0.1
	 local tempInterval = G.UpdateInterval * 10
	 -- Lib_ZYF:SetOnUpdate(tempInterval, G.Icon_Options_Frame_AdjustTimerFontSize)
	 
		Lib_ZYF:SetOnUpdate(tempInterval, G.SpecialFrame_Update)
		Lib_ZYF:SetOnUpdate(tempInterval, G.PositionFrames)
		Lib_ZYF:SetOnUpdate(tempInterval, G.TarPositionFrames)
		Lib_ZYF:SetOnUpdate(tempInterval, G.ScdPositionFrames)	
	
	-- Lib_ZYF:SetOnUpdate(0.1, G:SpecialFrame_Update)
	
	-- Next Event : ADDON_LOADED
end
--------------------------------

--ESC鍵隱藏
function G:OnKeyDown(key)		
	if (EA_Config.AllowESC == true ) then
		if (key == "ESCAPE") and (EA_flagAllHidden == true) then			
			EA_Main_Frame:SetAlpha(1)
			EA_flagAllHidden = false
			-- print(EA_flagAllHidden)
		elseif (key == "ESCAPE") and (EA_flagAllHidden == false) then
			--若使用Hide()隱藏將導致無法接受鍵盤事件,所以只能改用調整透明度為0以保持事件偵測
			EA_Main_Frame:SetAlpha(0)
			EA_flagAllHidden = true
			-- print(EA_flagAllHidden)
		end		
	end
	--此行重要,防止按鍵卡在此函數,無法讓遊戲其他UI吃到按鍵
	--self:SetPropagateKeyboardInput(true)
end
function G:OnKeyDown(key)		
	return
end
--------------------------------
-- If 'OnLoad' event had loaded, then excute this 'ADDON_LOADED' event.
--------------------------------
function G:ADDON_LOADED(event, ...)
	local arg1,arg2 = ...
	if (arg1 == EA_ADDONS_NAME) then
		-- // 1. Load the Default Spell Arrays, but not apply to this player now.
		G:LoadSpellArray()
		localizedPlayerClass,EA_playerClass = UnitClass("player")
		-- // 2. Check EAM version. If version isn't match. Load Default Spells automatically.
		G:VersionCheck()
		DEFAULT_CHAT_FRAME:AddMessage(EA_XLOAD_LOAD..EA_Config.Version.."\124r")
		-- // 3. Start to check the savedvariables
		-- (Load savedvariables from WOW FOLDER\WTF\Account\youraccount\SavedVariables\EventAlertMod.lua)
		G:InitArrayConfig()
		G:InitArrayPosition()
		G:InitArrayPos()
		if (EA_Config.ShareSettings ~= true) then
			EA_Position = EA_Pos[EA_playerClass]
			if EA_Position.Tar_NewLine == nil then EA_Position.Tar_NewLine = true end
			if EA_Position.Execution == nil then EA_Position.Execution = 0 end
			if EA_Position.PlayerLv2BOSS == nil then EA_Position.PlayerLv2BOSS = true end
		end
		G:InitArraySpecCheckPower()
		G:Options_Init()
		G:Icon_Options_Frame_Init()
		--G:Class_Events_Frame_Init()
		--G:Other_Events_Frame_Init()
		--G:Target_Events_Frame_Init()
		--G:SCD_Events_Frame_Init()
		--G:Group_Events_Frame_Init()
		G:CreateFrames()
		
		if G.WOW_VERSION >= 100002 then
			EAFun_DealTooltips()			
		else
			EAFun_HookTooltips()
			--EAFun_DealTooltips()			
		end
	end
end

-------------------------------------------------
function G:InitSlashCommand()
	SlashCmdList["EVENTALERTMOD"] = G.SlashHandler
	SLASH_EVENTALERTMOD1 = "/eventalertmod"
	SLASH_EVENTALERTMOD2 = "/eam"
end

-------------------------------------------------
function G:InitArrayConfig()	

	--若存檔(EA_Config)無紀錄,就從預設值(EA_Config2)複製一份
	for k,v in pairs(EA_Config2) do
		if EA_Config[k] == nil then 
			EA_Config[k] = EA_Config2[k]		
		end
	end	
	
	local function SetNewValue(tbl,key,value) 	
		if (type(tbl) == "table") and (type(key) == "string") then
			if tbl[key] == nil then 
				tbl[key] = value 
			end
		end
	end
	
	--第一次執行預設值
	SetNewValue(EA_Config, "AlertSound", 			568154)
	SetNewValue(EA_Config, "AlertSoundValue",		1)
	SetNewValue(EA_Config, "DoAlertSound",			true)
	SetNewValue(EA_Config, "LockFrame",				false)
	SetNewValue(EA_Config, "ShareSettings",			true)
	SetNewValue(EA_Config, "ShowFrame", 			true)
	SetNewValue(EA_Config, "ShowTimer", 			true)
	SetNewValue(EA_Config, "ShowFlash", 			true)
	SetNewValue(EA_Config, "ShowTimer",				true)
	SetNewValue(EA_Config, "IconSize",				45)
	SetNewValue(EA_Config, "ChangeTimer", 			true)
	SetNewValue(EA_Config, "AllowESC",				false)
	SetNewValue(EA_Config, "AllowAltAlerts",		false)
	SetNewValue(EA_Config, "Target_MyDebuff",		true)
	SetNewValue(EA_Config, "NewLineByIconCount",	0)
	-- SetNewValue(EA_Config, "BaseFontSize",			26)	
	SetNewValue(EA_Config, "TimerFontSize",			25)	
	SetNewValue(EA_Config, "StackFontSize",			15)	
	SetNewValue(EA_Config, "SNameFontSize",			15)	
	
	G:CreateSpellItemCache()
	G:Icon_Options_Frame_AdjustTimerFontSize()
end
-------------------------------------------------------

function G:InitArrayPosition()
	if EA_Position.Anchor == nil then EA_Position.Anchor = "CENTER" end
	if EA_Position.relativePoint == nil then EA_Position.relativePoint = "CENTER" end
	if EA_Position.xLoc == nil then EA_Position.xLoc = 0 end
	if EA_Position.yLoc == nil then EA_Position.yLoc = -140 end
	if EA_Position.xOffset == nil then EA_Position.xOffset = -40 end
	if EA_Position.yOffset == nil then EA_Position.yOffset = 0 end
	if EA_Position.RedDebuff == nil then EA_Position.RedDebuff = 0.5 end
	if EA_Position.GreenDebuff == nil then EA_Position.GreenDebuff = 0.5 end
	if EA_Position.Tar_NewLine == nil then EA_Position.Tar_NewLine = true end
	if EA_Position.TarAnchor == nil then EA_Position.TarAnchor = "CENTER" end
	if EA_Position.TarrelativePoint == nil then EA_Position.TarrelativePoint = "CENTER" end
	if EA_Position.Tar_xOffset == nil then EA_Position.Tar_xOffset = 0 end
	if EA_Position.Tar_yOffset == nil then EA_Position.Tar_yOffset = -220 end
	if EA_Position.ScdAnchor == nil then EA_Position.ScdAnchor = "CENTER" end
	if EA_Position.Scd_xOffset == nil then EA_Position.Scd_xOffset = 0 end
	if EA_Position.Scd_yOffset == nil then EA_Position.Scd_yOffset = 80 end
	if EA_Position.Execution == nil then EA_Position.Execution = 0 end
	if EA_Position.PlayerLv2BOSS == nil then EA_Position.PlayerLv2BOSS = true end
	if EA_Position.SCD_UseCooldown == nil then EA_Position.SCD_UseCooldown = false end
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function G:InitArrayPos()
	if EA_Pos == nil then EA_Pos = { } end
	if EA_Pos[EA_CLASS_DK] == nil then EA_Pos[EA_CLASS_DK] = EA_Position end
	if EA_Pos[EA_CLASS_DRUID] == nil then EA_Pos[EA_CLASS_DRUID] = EA_Position end
	if EA_Pos[EA_CLASS_HUNTER] == nil then EA_Pos[EA_CLASS_HUNTER] = EA_Position end
	if EA_Pos[EA_CLASS_MAGE] == nil then EA_Pos[EA_CLASS_MAGE] = EA_Position end
	if EA_Pos[EA_CLASS_PALADIN] == nil then EA_Pos[EA_CLASS_PALADIN] = EA_Position end
	if EA_Pos[EA_CLASS_PRIEST] == nil then EA_Pos[EA_CLASS_PRIEST] = EA_Position end
	if EA_Pos[EA_CLASS_ROGUE] == nil then EA_Pos[EA_CLASS_ROGUE] = EA_Position end
	if EA_Pos[EA_CLASS_SHAMAN] == nil then EA_Pos[EA_CLASS_SHAMAN] = EA_Position end
	if EA_Pos[EA_CLASS_WARLOCK] == nil then EA_Pos[EA_CLASS_WARLOCK] = EA_Position end
	if EA_Pos[EA_CLASS_WARRIOR] == nil then EA_Pos[EA_CLASS_WARRIOR] = EA_Position end
	if EA_Pos[EA_CLASS_MONK] == nil then EA_Pos[EA_CLASS_MONK] = EA_Position end
	if EA_Pos[EA_CLASS_DEMONHUNTER] == nil then EA_Pos[EA_CLASS_DEMONHUNTER] = EA_Position end
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function G:InitArraySpecCheckPower()
	if EA_Config.SpecPowerCheck == nil then EA_Config.SpecPowerCheck = {} end						
	for k,v in pairs(EA_SpecPower) do		
		if EA_Config.SpecPowerCheck[k] == nil then 
			EA_Config.SpecPowerCheck[k] = false 
		end
	end
end

--以協程平滑獲取伺服器物品資料,避免卡頓
function G:CreateSpellItemCache() 
	
	local max_itemID = 10^6-1
	local i
	for i = max_itemID, 1, -1 do
		if C_Item.DoesItemExistByID(i) then 
			max_itemID = i
			break
		end
	end
	
	
	EA_Config.EA_SPELL_ITEM =  EA_Config.EA_SPELL_ITEM or (G.EA_SPELL_ITEM or {})
	-- 定義一個從伺服器獲取數據的協程
	local function getAllItemSpell()
		
		--為避免每次都重頭建立,所以以最後建立的ID開始搜尋, 直到全部搜尋完成
		local begin = EA_Config.EA_SPELL_ITEM.LastUpdate or 1 
		local spellID, i		
		
		 for i = begin, max_itemID do 
					
			_, spellID = GetItemSpell(i)
			
			if spellID then 
				EA_Config.EA_SPELL_ITEM[spellID] = i
				EA_Config.EA_SPELL_ITEM.LastUpdate = i  					
			end			
			coroutine.yield()							
		end
		
		EA_Config.EA_SPELL_ITEM.LastUpdate = nil
		print("EAM Item map Spell Cache had created done!")
	end
	
	-- 創建一個定時器，每0.005秒執行一次 getAllItemSpell()
	local co = coroutine.create(getAllItemSpell)
	G.tickerGetItemSpell = C_Timer.NewTicker(0.005, function()	
	
		-- 如果協程已經結束，取消定時器		
		if coroutine.status(co) == "dead" then  			
			G.tickerGetItemSpell:Cancel()
			return
		end                 
		
		-- 恢復協程的執行，繼續獲取數據
		coroutine.resume(co)
	end)

	-- 啟動協程執行
	coroutine.resume(co) 	
end
--------------------------------------------------------------------]]
function G:PLAYER_ENTER_COMBAT(event, ...)
	ShowAllScdCurrentBuff()	
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function G:PLAYER_LEAVE_COMBAT(event, ...)
	if EA_Config.SCD_NocombatStillKeep == false then
		HideAllScdCurrentBuff()
	end
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function G:PLAYER_ENTERING_WORLD(event, ...)

		local pairs = pairs
		local tonumber = tonumber
		local foreach = table.foreach
		local wipe = table.wipe
		
		local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9 = ...
		
		G:PlayerSpecPower_Update()
		
		for p,tblPower in pairs(EA_SpecPower) do 
			if (tblPower.func) and (EA_Config.SpecPowerCheck[k]) and (tblPower.has) then
				if (tblPower.powerId) then
					tblPower.func(tblPower.powerId)
				else
					tblPower.func()
				end
			end
		end
		
		
		local v = foreach(EA_CurrentBuffs, function(i, v) if v==arg9 then return v end end)
		if v then
			local f = _G["EAFrame_"..v]
			f:Hide()
			EA_CurrentBuffs = wipe(EA_CurrentBuffs)
		end
		EA_ClassAltSpellName = {}
		
		local DoesSpellExist = C_Spell.DoesSpellExist
		local GetSpellInfo = GetSpellInfo 
		for i,v in pairs(EA_AltItems[EA_playerClass]) do
			if DoesSpellExist(i) then
				local name = GetSpellInfo(i)
				EA_ClassAltSpellName[name] = tonumber(i)
			end
		end
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function G:TARGET_CHANGED(event, ...)
	G:TarChange_ClearFrame()
	if UnitName("player") ~= UnitName("target") then
		G:TarBuffs_Update("target")
		if (EA_Config.SpecPowerCheck.ComboPoints and EA_SpecPower.ComboPoints.has) then
			G:UpdateComboPoints()
		end
		G:CheckExecution()
	end
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function G:UNIT_SPELLCAST_SUCCEEDED(event,...)
	local unitCaster,spellName,_,_,spellID = ...
	local surName = UnitName(unitCaster)	
	G:ScdBuffs_Update(surName, spellName, spellID)
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function G:COMBAT_LOG_EVENT_UNFILTERED(event, ...)	
	local 	timestp, 
			event, 
			hideCaster, 
			surGUID, 
			surName, 
			surFlags, 
			surRaidFlags, 
			dstGUID, 
			dstName, 
			dstFlags, 
			dstRaidFlags, 
			spellID, 
			spellName = CombatLogGetCurrentEventInfo()
			
	local f = EA_EventList_COMBAT_LOG_EVENT_UNFILTERED[event]
	
	if type(f) == "function" then f(CombatLogGetCurrentEventInfo()) end
	spellID = tonumber(spellID)
	if (dstName ~= nil) then dstName = strsplit("-", dstName, 2) end
	if ((spellID ~= nil) and (spellID > 0 and spellID < 1000000)) then
		-- "/ea showc" will also display in this function
		G:ScdBuffs_Update(surName, spellName, spellID, timestp) -- WOW 4.1 Change with spellID
		local iUnitPower = UnitPower("player", 8)
		if (EA_playerClass == EA_CLASS_DRUID and EA_Config.SpecPowerCheck.LifeBloom and EA_SpecPower.LifeBloom.has and iUnitPower == 0) then
			local EA_PlayerName = UnitName("player")
			if (surName == EA_PlayerName and spellID == 33763 and dstName ~= nil) then
				-- print ("tar="..arg8.." /spid="..arg10)
				local EA_UnitID = ""
				if (dstName == EA_PlayerName) then
					EA_UnitID = "player"
				elseif dstName == EA_SpecFrame_LifeBloom.UnitName then
					EA_UnitID = EA_SpecFrame_LifeBloom.UnitID
				else
					EA_UnitID = EAFun_GetUnitIDByName(dstName)
				end
					G:UpdateLifeBloom(EA_UnitID)
			end
		end
		--if (EA_playerClass == EA_CLASS_DK) then			
			--G:UpdateRunes()
		--end
	end
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function G:COMBAT_LOG_EVENT_SPELL_AURA_REFRESH(...)
	
	local 	timestp, event, hideCaster, 
			surGUID, surName, surFlags, surRaidFlags, 
			dstGUID, dstName, dstFlags, dstRaidFlags, 
			spellID, spellName = CombatLogGetCurrentEventInfo()
	
	if (dstGUID == UnitGUID("player")) or (dstGUID == UnitGUID("pet")) then
		G:Buffs_Update(CombatLogGetCurrentEventInfo())
	else
		G:TarBuffs_Update(CombatLogGetCurrentEventInfo())
	end
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function G:COMBAT_LOG_EVENT_SPELL_CAST_SUCCESS(...)
	local	timestp, event, hideCaster,
			surGUID, surName, surFlags, surRaidFlags,
			dstGUID, dstName, dstFlags, dstRaidFlags,
			spellID, spellName = CombatLogGetCurrentEventInfo()
			
	G:ScdBuffs_Update(surName, spellName, spellID, timestp )
	G:Buffs_Update(CombatLogGetCurrentEventInfo())
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function G:COMBAT_LOG_EVENT_SPELL_SUMMON(...)		
	local 	timestp, event, hideCaster, 
			surGUID, surName, surFlags, surRaidFlags, 
			dstGUID, dstName, dstFlags, dstRaidFlags, 
			spellID, spellName = CombatLogGetCurrentEventInfo()
			
	G:Buffs_Update(CombatLogGetCurrentEventInfo())
	
		--若 /eam showc 啟用，則也顯示招喚圖騰型法術ID
		if (EA_DEBUGFLAG3) then
			sSpellLink = GetSpellLink(spellID)
			if (sSpellLink ~= nil) then
					-- DEFAULT_CHAT_FRAME:AddMessage("\124cffFFFF00"..EA_XCMD_DEBUG_P2.."\124r="..EA_spellID.." / \124cffFFFF00"..EA_XCMD_DEBUG_P1.."\124r="..sSpellLink)
					EAFun_AddSpellToScrollFrame(spellID, "")
					print("SUMMON SPELL ID:",spellID,sSpellLink)
			end
		end
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function G:PLAYER_TOTEM_UPDATE(event,totemIndex)
	--print(totemIndex)
	G:Buffs_Update()
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function G:UNIT_AURA(event, ...)
	
	local unitID = select(1, ...)
	
	if (unitID == "player") or (unitID == "pet") then			
		G:Buffs_Update(...)	
	else		
		G:TarBuffs_Update(...)
	end
	
	if (EA_FormType_FirstTimeCheck) then
		--DEFAULT_CHAT_FRAME:AddMessage("First time check FormType")
		G:PlayerSpecPower_Update()
		EA_FormType_FirstTimeCheck = false
	end
end
--[[------------------------------------------------------------------
function G:COMBAT_TEXT_UPDATE(self, event, ...)
	local arg1, arg2 = ...
	if (arg1 == "SPELL_ACTIVE") then
		G:COMBAT_TEXT_SPELL_ACTIVE(arg2)
	end
end
--------------------------------------------------------------------]]
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function G:UNIT_COMBO_POINTS(event, ...)
	if (EA_Config.SpecPowerCheck.ComboPoints and EA_SpecPower.ComboPoints.has) then
		G:UpdateComboPoints()
	end
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function G:UNIT_HEALTH(event, ...)
		
		local arg1 = ...
		if arg1 == "target" then
			G:CheckExecution()
		end
end
function G:UNIT_SPELLCAST_START(event,unitCaster,CastGUID,spellId)
	if (EA_DEBUGFLAG3) then
				sSpellLink = GetSpellLink(spellId)
				--if (sSpellLink ~= nil) then
					-- DEFAULT_CHAT_FRAME:AddMessage("\124cffFFFF00"..EA_XCMD_DEBUG_P2.."\124r="..EA_spellID.." / \124cffFFFF00"..EA_XCMD_DEBUG_P1.."\124r="..sSpellLink)
					EAFun_AddSpellToScrollFrame(spellId, "")
				--end
	end
end
function G:UNIT_SPELLCAST_CHANNEL_START(event, unitCaster, CastGUID, spellId)
	if (EA_DEBUGFLAG3) then
				sSpellLink = GetSpellLink(spellId)
				--if (sSpellLink ~= nil) then
					-- DEFAULT_CHAT_FRAME:AddMessage("\124cffFFFF00"..EA_XCMD_DEBUG_P2.."\124r="..EA_spellID.." / \124cffFFFF00"..EA_XCMD_DEBUG_P1.."\124r="..sSpellLink)
					EAFun_AddSpellToScrollFrame(spellId, "")
				--end
	end
end
function G:UNIT_SPELLCAST_FAILED(event, unitCaster, CastGUID, spellId)
	
	if unitCaster == "player" then
		--G:ScdBuffs_Update(unitCaster,GetSpellInfo(spellId), spellId)
	end
end
function G:BAG_UPDATE_COOLDOWN(event,...)
	
	local tmpSpellID	
	tmpSpellID = select(2,GetItemSpell(GetInventoryItemID("player",13)))
	if tmpSpellID then 
		
		G:ScdBuffs_Update("player",GetSpellInfo(tmpSpellID), tmpSpellID)
	end 	
	tmpSpellID = select(2,GetItemSpell(GetInventoryItemID("player",14)))
	if tmpSpellID then
		
		G:ScdBuffs_Update("player",GetSpellInfo(tmpSpellID), tmpSpellID)
	end
end
------------------------------------------------------------------
--切換專精
------------------------------------------------------------------
function G:ACTIVE_TALENT_GROUP_CHANGED(event, ...)	
	--G:PLAYER_ENTERING_WORLD()
	
	G:PlayerSpecPower_Update()	
	G:RemoveAllScdCurrentBuff()
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function G:UNIT_DISPLAYPOWER(event, ...)
	G:PlayerSpecPower_Update()
	--RemoveAllScdCurrentBuff()
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function G:UPDATE_SHAPESHIFT_FORM(event, ...)
	G:PlayerSpecPower_Update()
	--RemoveAllScdCurrentBuff()
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function G:PLAYER_TALENT_UPDATE(event, ...)
	G:PlayerSpecPower_Update()
	G:RemoveAllScdCurrentBuff()
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function G:PLAYER_TALENT_WIPE(event, ...)
	G:PlayerSpecPower_Update()
	G:RemoveAllScdCurrentBuff()
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function G:SPELL_UPDATE_COOLDOWN(event, ...)
	--G:ScdPositionFrames()
	
	-- for i,spellID in ipairs(EA_ScdCurrentBuffs) do
		-- G:OnSCDUpdate(spellID)
	-- end	
	local tmpSpellID
	
	tmpSpellID = select(2,GetItemSpell(GetInventoryItemID("player",13)))
	if tmpSpellID then 
		G:ScdBuffs_Update("player",GetSpellInfo(tmpSpellID), tmpSpellID)
	end 	
	tmpSpellID = select(2,GetItemSpell(GetInventoryItemID("player",14)))
	if tmpSpellID then
		G:ScdBuffs_Update("player",GetSpellInfo(tmpSpellID), tmpSpellID)
	end
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function G:SPELL_UPDATE_CHARGES(event, ...)
	--G:ScdPositionFrames()
	
	-- for i,spellID in ipairs(EA_ScdCurrentBuffs) do
		-- G:OnSCDUpdate(spellID)
	-- end
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function G:RUNE_TYPE_UPDATE(event, ...)
	G:UpdateRunes()
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function G:RUNE_POWER_UPDATE(event, ...)
	G:UpdateRunes()
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function G:EMPOWER_START(event, ...)
	local unitTarget, castGUID, spellID = ...	
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function G:EMPOWER_UPDATE(event,...)
	local unitTarget, castGUID, spellID = ...    	
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function G:UPDATE_UI_WIDGET(event,...)
		local UIWidgetInfo = ...
		-- local widgetID, widgetSetID, widgetType, unitToken = UIWidgetInfo		
		
		if UIWidgetInfo.widgetType == 24 then 
			
			local widgetInfo 		= 	C_UIWidgetManager.GetFillUpFramesWidgetVisualizationInfo(UIWidgetInfo.widgetID)
			
			--Debug Test
			 -- for k,v in pairs(widgetInfo) do print(k,v) end
						
			local numTotalFrames 	= 	widgetInfo.numTotalFrames
			local numFullFrames		= 	widgetInfo.numFullFrames
			local fillMax 			=	widgetInfo.fillMax
			local fillValue			= 	widgetInfo.fillValue
			local icon				= 	widgetInfo.textureKit
			local shownState		=	widgetInfo.shownState   			
			
			local vigorCount		= 	numFullFrames
			local vigorCountMax		= 	numTotalFrames
			-- local vigor 			= 	numFullFrames 	* fillMax + fillValue
			local vigor 			= 	fillValue
			local vigorMax 			= 	numTotalFrames	* fillMax 
			
			if  shownState == Enum.WidgetShownState.Hidden then 
				G.vigorCount = G.vigorCount or vigorCountMax
				G.fillValue	 = G.fillValue	or 0
				if G.vigorCount < vigorCountMax then 					
					if 	(fillValue < G.fillValue)	then 
						G.vigorCount = G.vigorCount + 1
						G.vigorCount = (G.vigorCount > vigorCountMax) and vigorCountMax or G.vigorCount
					end
					vigor		=	FillValue
					G.FillValue =	FillValue
				else
					vigor	=	0
				end
				
				vigorCount 	= G.vigorCount
			else
				G.vigor					=	vigor
				G.vigorMax				=	vigorMax
				G.vigorCount			=	vigorCount
				G.vigorCountMax			=	vigorCountMax
				G.fillValue 			=	fillValue
			end
			
			G:UpdateVigor(vigor, vigorMax, vigorCount, vigorCountMax)
			
		end
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function G:UNIT_POWER_UPDATE(event,...)
	local arg1, arg2 = ...		
	if arg1 == "player" or arg1 == "pet" then
		for p,	tblPower in pairs(EA_SpecPower) do
			if (arg2 == tblPower.powerType) then
				if (tblPower.func) and (EA_Config.SpecPowerCheck[p]) and (tblPower.has) then	
					if(tblPower.powerId) then					
							tblPower.func(tblPower.powerId)						
					else
						tblPower.func()
					end
				end	
				break
			end
		end			
	end
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
local function EAFun_CheckSpellConditionOverGrow(EA_count, EAItems)
	local isOverGrow = false
	local SC_OverGrow = 0
	if (EAItems ~= nil) then
		if (EAItems.overgrow ~= nil) then SC_OverGrow = EAItems.overgrow end
	end
	if (EA_count) then
		if (EA_count <= 0) then EA_count = 1 end
		if (SC_OverGrow ~= nil and SC_OverGrow > 0) then
			if (SC_OverGrow <= EA_count) then isOverGrow = true end
		end
	end
	return isOverGrow
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
local function EAFun_GetSpellConditionRedSecText(EAItems)
	local SC_RedSecText = -1
	if (EAItems ~= nil) then
		if (EAItems.redsectext ~= nil) then SC_RedSecText = EAItems.redsectext end
		if (SC_RedSecText < 1) then SC_RedSecText = -1 end
	end
	return SC_RedSecText
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function G:Buffs_Update(...)	
	
	local 	canApplyAura, debuffType, isBossAura, isFromPlayerOrPlayerPet,
			isHarmful, isHelpful, isNameplateOnly, isRaid, name, 
			nameplateShowAll, sourceUnit, spellID
			
	local	addedAuras, updatedAuraInstanceIDs, removedAuraInstanceIDs
	
	local 	unitID, isFullUpdate, unitAuraUpdateInfo
	if G.WOW_VERSION >= 100000 then 
		
		unitID, unitAuraUpdateInfo					= ...
		
		canApplyAura, debuffType, isBossAura, isFromPlayerOrPlayerPet,
		isHarmful, isHelpful, isNameplateOnly, isRaid, name, 
		nameplateShowAll, sourceUnit, spellID, addedAuras, 
		updatedAuraInstanceIDs, removedAuraInstanceIDs, isFullUpdate = unitAuraUpdateInfo 
		
	elseif G.WOW_VERSION < 100000 then 
		
		unitID, isFullUpdate, unitAuraUpdateInfo	= ...
		
		canApplyAura, debuffType, isBossAura, isFromPlayerOrPlayerPet,
		isHarmful, isHelpful, isNameplateOnly, isRaid, name, 
		nameplateShowAll, sourceUnit, spellID = unitAuraUpdateInfo
	end	
		
	local tinsert  = table.insert
	local foreach  = table.foreach
	local UnitAura = UnitAura
	local UnitInRaid = UnitInRaid
	local UnitInParty = UnitInParty
	
	local buffsCurrent = {}
	local buffsToDelete = {}
	local SpellEnable, OtherEnable = false, false
	local ifAdd_buffCur = false
	local orderWtd = 1
	-- DEFAULT_CHAT_FRAME:AddMessage("G:Buffs_Update")
	-- if (EA_DEBUGFLAG1) then
	--  DEFAULT_CHAT_FRAME:AddMessage("----"..EA_XCMD_SELFLIST.."----")
	-- end
	if (EA_DEBUGFLAG11 or EA_DEBUGFLAG21) then
		CreateFrames_EventsFrame_ClearSpellList(3)
	end	
	
	--local EA_SPELLINFO_SELF = EA_SPELLINFO_SELF
	local P ,T = "player", "target"
	local PlayerItems = EA_Items[EA_playerClass]
	local OtherItems = EA_Items[EA_CLASS_OTHER]
	
	local 	name,  icon, count, debuffType,	duration, 
			expirationTime, unitCaster, isStealable, 
			nameplateShowPersonal, spellID, canApplyAura, 
			isBossDebuff, _, nameplateShowAll, timeMod, 
			value1, value2, value3
			
	--collect player's buff
	for i=1,40 do
		
		name,  icon, count, debuffType,	duration, 
		expirationTime, unitCaster, isStealable, 
		nameplateShowPersonal, spellID, canApplyAura, 
		isBossDebuff, _, nameplateShowAll, timeMod, 
		value1, value2, value3 = UnitAura(P, i, "HELPFUL")
		--local name,  icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod, value1, value2, value3 = UnitAura("player", i, "HELPFUL")
		if (spellID==nil) then break end
		if isCastByPlayer then unitCaster = P end
		if (spellID == 71601) then EA_SPEC_expirationTime1 = expirationTime end
		if (spellID == 71644) then EA_SPEC_expirationTime2 = expirationTime end			
		if (EA_DEBUGFLAG1) then
			-- if (EA_LISTSEC_SELF == 0 or (0 < duration and duration <= EA_LISTSEC_SELF)) then
			if (G.LISTSEC.SELF == 0 or (0 < duration and duration <= G.LISTSEC.SELF)) then
				EAFun_AddSpellToScrollFrame(spellID, " /\124cffFFFF00"..EA_XCMD_DEBUG_P3.."\124r:"..count..
					" /\124cffFFFF00"..EA_XCMD_DEBUG_P4.."\124r:"..duration)
				-- DEFAULT_CHAT_FRAME:AddMessage("["..i.."]\124cffFFFF00"..EA_XCMD_DEBUG_P1.."\124r:"..name..
				--  " /\124cffFFFF00"..EA_XCMD_DEBUG_P2.."\124r:"..spellID..
				--  " /\124cffFFFF00"..EA_XCMD_DEBUG_P3.."\124r:"..count..
				--  " /\124cffFFFF00"..EA_XCMD_DEBUG_P4.."\124r:"..duration)
			end
		end
		ifAdd_buffCur = false
		--spellID = tostring(spellID)
		SpellEnable = EAFun_GetSpellItemEnable(PlayerItems[spellID])
		OtherEnable = EAFun_GetSpellItemEnable(OtherItems[spellID])
		if (SpellEnable) then
			-- ifAdd_buffCur = true
			ifAdd_buffCur, orderWtd = EAFun_CheckSpellConditionMatch(count, unitCaster, PlayerItems[spellID])
		elseif (OtherEnable) then
			-- ifAdd_buffCur = true
			ifAdd_buffCur, orderWtd = EAFun_CheckSpellConditionMatch(count, unitCaster, OtherItems[spellID])
		elseif (EA_DEBUGFLAG11 or EA_DEBUGFLAG21) then
			-- ifAdd_buffCur = true
			if (EA_LISTSEC_SELF == 0 or (0 < duration and duration <= EA_LISTSEC_SELF)) then
				-- DEFAULT_CHAT_FRAME:AddMessage("spellID="..spellID.." /unitCaster="..unitCaster)
				if EA_DEBUGFLAG11 or (EA_DEBUGFLAG21 and (not (UnitInRaid(unitCaster) or UnitInParty(unitCaster)))) then
					if OtherItems[spellID] == nil then OtherItems[spellID] = {enable=true,} end
					CreateFrames_CreateSpellFrame(spellID, 1)
					ifAdd_buffCur = true
				end
			end
		end
		if (ifAdd_buffCur) then			
			
			EA_SPELLINFO_SELF[spellID] =	{	
											name			=	name,
											rank,
											icon 			= 	icon,
											count			=	count,
											duration		=	duration,
											expirationTime 	=	expirationTime,
											unitCaster 		= 	unitCaster,
											isDebuff		= 	false,
											orderwtd		=	orderWtd,
											value			=	{value1, value2, value3},
											aura			=	true,
											}
			
			tinsert(buffsCurrent, spellID)
		end
	end
	--collect pet's buff
	for i=1,40 do
		
		name,  icon, count, debuffType, duration, expirationTime, 
		unitCaster, isStealable, nameplateShowPersonal, spellID, 
		canApplyAura, isBossDebuff, isCastByPlayer, nameplateShowAll,
		timeMod, value1, value2, value3 = UnitAura("pet", i, "HELPFUL")
		
		if (spellID==nil) then break end
		
		if isCastByPlayer then unitCaster = P end
		--if (spellID == 71601) then EA_SPEC_expirationTime1 = expirationTime end
		--if (spellID == 71644) then EA_SPEC_expirationTime2 = expirationTime end
		if (EA_DEBUGFLAG1) then
			if (EA_LISTSEC_SELF == 0 or (0 < duration and duration <= EA_LISTSEC_SELF)) then
				EAFun_AddSpellToScrollFrame(spellID, " /\124cffFFFF00"..EA_XCMD_DEBUG_P3.."\124r:"..count..
					" /\124cffFFFF00"..EA_XCMD_DEBUG_P4.."\124r:"..duration)
				-- DEFAULT_CHAT_FRAME:AddMessage("["..i.."]\124cffFFFF00"..EA_XCMD_DEBUG_P1.."\124r:"..name..
				--  " /\124cffFFFF00"..EA_XCMD_DEBUG_P2.."\124r:"..spellID..
				--  " /\124cffFFFF00"..EA_XCMD_DEBUG_P3.."\124r:"..count..
				--  " /\124cffFFFF00"..EA_XCMD_DEBUG_P4.."\124r:"..duration)
			end
		end
		ifAdd_buffCur = false
		--spellID = tostring(spellID)
		SpellEnable = EAFun_GetSpellItemEnable(PlayerItems[spellID])
		OtherEnable = EAFun_GetSpellItemEnable(OtherItems[spellID])
		if (SpellEnable) then
			-- ifAdd_buffCur = true
			ifAdd_buffCur, orderWtd = EAFun_CheckSpellConditionMatch(count, unitCaster, PlayerItems[spellID])
		elseif (OtherEnable) then
			-- ifAdd_buffCur = true
			ifAdd_buffCur, orderWtd = EAFun_CheckSpellConditionMatch(count, unitCaster, OtherItems[spellID])
		elseif (EA_DEBUGFLAG11 or EA_DEBUGFLAG21) then
			-- ifAdd_buffCur = true
			if (EA_LISTSEC_SELF == 0 or (0 < duration and duration <= EA_LISTSEC_SELF)) then
				-- DEFAULT_CHAT_FRAME:AddMessage("spellID="..spellID.." /unitCaster="..unitCaster)
				if EA_DEBUGFLAG11 or (EA_DEBUGFLAG21 and (not (UnitInRaid(unitCaster) or UnitInParty(unitCaster)))) then
					if OtherItems[spellID] == nil then OtherItems[spellID] = {enable=true,} end
					CreateFrames_CreateSpellFrame(spellID, 1)
					ifAdd_buffCur = true
				end
			end
		end
		if (ifAdd_buffCur) then
			
			EA_SPELLINFO_SELF[spellID] =	{	
											name			=	name,
											rank,
											icon 			= 	icon,
											count			=	count,
											duration		=	duration,
											expirationTime 	=	expirationTime,
											unitCaster 		= 	unitCaster,
											isDebuff		= 	false,
											orderwtd		=	orderWtd,
											value			=	{value1, value2, value3},
											aura			=	true,
											}
			tinsert(buffsCurrent, spellID)
		end
	end
	--collect player's debuff
	for i = 1, 40 do
		name,  icon, count, debuffType, duration, expirationTime, 
		unitCaster, isStealable, nameplateShowPersonal, spellID, 
		canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod, 
		value1, value2, value3 = UnitAura(P, i, "HARMFUL")
		if (spellID==nil) then break end
		if isCastByPlayer then unitCaster = P end
		if (EA_DEBUGFLAG1) then
			if (EA_LISTSEC_SELF == 0 or (0 < duration and duration <= EA_LISTSEC_SELF)) then
				EAFun_AddSpellToScrollFrame(spellID, " /\124cffFFFF00"..EA_XCMD_DEBUG_P3.."\124r:"..count..
					" /\124cffFFFF00"..EA_XCMD_DEBUG_P4.."\124r:"..duration)
				-- DEFAULT_CHAT_FRAME:AddMessage("["..i.."]\124cffFFFF00"..EA_XCMD_DEBUG_P1.."\124r:"..name..
				--  " /\124cffFFFF00"..EA_XCMD_DEBUG_P2.."\124r:"..spellID..
				--  " /\124cffFFFF00"..EA_XCMD_DEBUG_P3.."\124r:"..count..
				--  " /\124cffFFFF00"..EA_XCMD_DEBUG_P4.."\124r:"..duration)
			end
		end
		ifAdd_buffCur = false
		--spellID = tostring(spellID)
		SpellEnable = EAFun_GetSpellItemEnable(PlayerItems[spellID])
		OtherEnable = EAFun_GetSpellItemEnable(OtherItems[spellID])
		if (SpellEnable) then
			-- ifAdd_buffCur = true
			ifAdd_buffCur, orderWtd = EAFun_CheckSpellConditionMatch(count, unitCaster, PlayerItems[spellID])
		elseif (OtherEnable) then
			-- ifAdd_buffCur = true
			ifAdd_buffCur, orderWtd = EAFun_CheckSpellConditionMatch(count, unitCaster, OtherItems[spellID])
		elseif (EA_DEBUGFLAG11 or EA_DEBUGFLAG21) then
			-- ifAdd_buffCur = true
			if (EA_LISTSEC_SELF == 0 or (0 < duration and duration <= EA_LISTSEC_SELF)) then
				-- DEFAULT_CHAT_FRAME:AddMessage("spellID="..spellID.." /unitCaster="..unitCaster)
				if EA_DEBUGFLAG11 or (EA_DEBUGFLAG21 and (not (UnitInRaid(unitCaster) or UnitInParty(unitCaster)))) then
					if OtherItems[spellID] == nil then OtherItems[spellID] = {enable=true,} end
					CreateFrames_CreateSpellFrame(spellID, 1)
					ifAdd_buffCur = true
				end
			end
		end
		if (ifAdd_buffCur) then
						
			EA_SPELLINFO_SELF[spellID] =	{	
											name			=	name,
											rank,
											icon 			= 	icon,
											count			=	count,
											duration		=	duration,
											expirationTime 	=	expirationTime,
											unitCaster 		= 	unitCaster,
											isDebuff		= 	true,
											orderwtd		=	orderWtd,
											value			=	{value1, value2, value3},
											aura			=	true,
											}
			tinsert(buffsCurrent, spellID)
		end
	end
	
	--collect pet's debuff
	for i=1,40 do
		name,  icon, count, debuffType, duration, expirationTime, 
		unitCaster, isStealable, nameplateShowPersonal, spellID, 
		canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod, 
		value1, value2, value3 = UnitAura("pet", i, "HARMFUL")
		
		if (spellID==nil) then break end
		
		if isCastByPlayer then unitCaster = P end
		
		if (EA_DEBUGFLAG1) then
			if (EA_LISTSEC_SELF == 0 or (0 < duration and duration <= EA_LISTSEC_SELF)) then
				EAFun_AddSpellToScrollFrame(spellID, " /\124cffFFFF00"..EA_XCMD_DEBUG_P3.."\124r:"..count..
					" /\124cffFFFF00"..EA_XCMD_DEBUG_P4.."\124r:"..duration)
				-- DEFAULT_CHAT_FRAME:AddMessage("["..i.."]\124cffFFFF00"..EA_XCMD_DEBUG_P1.."\124r:"..name..
				--  " /\124cffFFFF00"..EA_XCMD_DEBUG_P2.."\124r:"..spellID..
				--  " /\124cffFFFF00"..EA_XCMD_DEBUG_P3.."\124r:"..count..
				--  " /\124cffFFFF00"..EA_XCMD_DEBUG_P4.."\124r:"..duration)
			end
		end
		ifAdd_buffCur = false
		--spellID = tostring(spellID)
		SpellEnable = EAFun_GetSpellItemEnable(PlayerItems[spellID])
		OtherEnable = EAFun_GetSpellItemEnable(OtherItems[spellID])
		if (SpellEnable) then
			-- ifAdd_buffCur = true
			ifAdd_buffCur, orderWtd = EAFun_CheckSpellConditionMatch(count, unitCaster, PlayerItems[spellID])
		elseif (OtherEnable) then
			-- ifAdd_buffCur = true
			ifAdd_buffCur, orderWtd = EAFun_CheckSpellConditionMatch(count, unitCaster, OtherItems[spellID])
		elseif (EA_DEBUGFLAG11 or EA_DEBUGFLAG21) then
			-- ifAdd_buffCur = true
			if (EA_LISTSEC_SELF == 0 or (0 < duration and duration <= EA_LISTSEC_SELF)) then
				-- DEFAULT_CHAT_FRAME:AddMessage("spellID="..spellID.." /unitCaster="..unitCaster)
				if EA_DEBUGFLAG11 or (EA_DEBUGFLAG21 and (not (UnitInRaid(unitCaster) or UnitInParty(unitCaster)))) then
					if OtherItems[spellID] == nil then OtherItems[spellID] = {enable=true,} end
					CreateFrames_CreateSpellFrame(spellID, 1)
					ifAdd_buffCur = true
				end
			end
		end
		if (ifAdd_buffCur) then			
			EA_SPELLINFO_SELF[spellID] =	{	
											name			=	name,
											rank,
											icon 			= 	icon,
											count			=	count,
											duration		=	duration,
											expirationTime 	=	expirationTime,
											unitCaster 		= 	unitCaster,
											isDebuff		= 	true,
											orderwtd		=	orderWtd,
											value			=	{value1, value2, value3},
											aura			=	true,
											}
			tinsert(buffsCurrent, spellID)
		end
	end
	--針對圖騰類法術進行偵測（如力之符文、屈心魔、邪DK華爾琪）
	local 	timestp, event, hideCaster, surGUID, 
			surName, surFlags, surRaidFlags, 
			dstGUID, dstName, dstFlags, dstRaidFlags, 
			spellID, spellName = ...
	
	local haveTotem, TotemName, TotemStart, TotemDuration, TotemIcon
	
	local GetTotemInfo = GetTotemInfo
	local count = 1
	local unitCaster = P
	
	for t = 1, 4 do			
		haveTotem, TotemName, TotemStart, TotemDuration, TotemIcon = GetTotemInfo(t)			
		ifAdd_buffCur = false
		SpellEnable = EAFun_GetSpellItemEnable(PlayerItems[spellID])			
		if (SpellEnable) then			
			ifAdd_buffCur, orderWtd = EAFun_CheckSpellConditionMatch(count, unitCaster, PlayerItems[spellID])	
		end
		if (ifAdd_buffCur) then
			if haveTotem then
				if event == "SPELL_SUMMON" then 	
					EA_SPELLINFO_SELF[spellID] =	{	
													name			=	spellName,											
													icon 			= 	TotemIcon,
													count			=	count,
													duration		=	TotemDuration,
													expirationTime 	=	TotemStart + TotemDuration,
													unitCaster 		= 	unitCaster,
													isDebuff		= 	false,
													orderwtd		=	orderWtd,											
													totem			=	t,
											}
					-- EA_SPELLINFO_SELF[spellID].name = spellName
					-- EA_SPELLINFO_SELF[spellID].icon = TotemIcon
					-- EA_SPELLINFO_SELF[spellID].count = count
					-- EA_SPELLINFO_SELF[spellID].duration = TotemDuration
					-- EA_SPELLINFO_SELF[spellID].expirationTime = TotemStart + TotemDuration
					-- EA_SPELLINFO_SELF[spellID].unitCaster = unitCaster
					-- EA_SPELLINFO_SELF[spellID].isDebuff = false
					-- EA_SPELLINFO_SELF[spellID].orderWtd = orderWtd
					-- EA_SPELLINFO_SELF[spellID].totem = t
				end
				tinsert(buffsCurrent, spellID)			
			end
		end
	end
	
	local t,s
	for _ ,s in pairs(EA_CurrentBuffs) do 		
		if EA_SPELLINFO_SELF[s] then 		
			t = EA_SPELLINFO_SELF[s].totem 			
			if t and t > 0 then	
				haveTotem, TotemName, TotemStart, TotemDuration, TotemIcon = GetTotemInfo(t)
				if haveTotem and GetTime() < EA_SPELLINFO_SELF[s].expirationTime then			
					tinsert(buffsCurrent, s)
				else
					EA_SPELLINFO_SELF[s].totem = nil
					tinsert(buffsToDelete, s)
				end			
			end
		end		
	end	
	local 	timestp, event, hideCaster, 
			surGUID, surName, surFlags, surRaidFlags, 
			dstGUID, dstName, dstFlags, dstRaidFlags, 
			spellID, spellName = ...
			
	unitCaster=""	
	if surGUID == UnitGUID(P) then 	unitCaster = P end
	if surGUID == UnitGUID(T) then 	unitCaster = T end
	if (spellID) and (unitCaster == P) then		
		if (event == "SPELL_AURA_APPLIED") or (event == "SPELL_AURA_REFRESH") then	
			if EA_SPELLINFO_SELF[spellID] then
				EA_SPELLINFO_SELF[spellID].aura = true	
			end
			-- if EA_SPELLINFO_TARGET[spellID] then
				-- EA_SPELLINFO_TARGET[spellID].aura = true	
			-- end
		end
		ifAdd_buffCur = false
		SpellEnable = EAFun_GetSpellItemEnable(PlayerItems[spellID])	
		if (SpellEnable) then					
			ifAdd_buffCur, orderWtd = EAFun_CheckSpellConditionMatch(count, unitCaster, PlayerItems[spellID])	
		end		
		local EffectDuration = tonumber(Lib_ZYF:GetSpellDurationByDesc(spellID))		
		if (ifAdd_buffCur) then		
			if (event == "SPELL_CAST_SUCCESS") and EffectDuration then 				
				if not(EA_SPELLINFO_SELF[spellID].aura) then
					-- EA_SPELLINFO_SELF[spellID].name = spellName
					-- EA_SPELLINFO_SELF[spellID].icon = GetSpellTexture(spellID)
					-- EA_SPELLINFO_SELF[spellID].count = 0
					-- EA_SPELLINFO_SELF[spellID].duration = 	EffectDuration
					-- EA_SPELLINFO_SELF[spellID].expirationTime = GetTime() + EffectDuration
					-- EA_SPELLINFO_SELF[spellID].unitCaster = unitCaster
					-- EA_SPELLINFO_SELF[spellID].isDebuff = false
					-- EA_SPELLINFO_SELF[spellID].orderWtd = orderWtd
					-- EA_SPELLINFO_SELF[spellID].spellcast = true
					EA_SPELLINFO_SELF[spellID] =	{	
													name			=	spellName,											
													icon 			= 	GetSpellTexture(spellID),
													count			=	0,
													duration		=	EffectDuration,
													expirationTime 	=	GetTime() + EffectDuration,
													unitCaster 		= 	unitCaster,
													isDebuff		= 	false,
													orderwtd		=	orderWtd,											
													spellcast		=	true,
												}
					tinsert(buffsCurrent, spellID)
				end
			end
		end
	end
	
	local spellcast
	for _,s in pairs(EA_CurrentBuffs) do 		
		if EA_SPELLINFO_SELF[s] then 		
			spellcast = EA_SPELLINFO_SELF[s].spellcast
			if spellcast then					
				if  GetTime() < EA_SPELLINFO_SELF[s].expirationTime then			
					tinsert(buffsCurrent, s)
				else
					EA_SPELLINFO_SELF[s].spellcast = false
					tinsert(buffsToDelete, s)
				end			
			end
		end		
	end	
	--[[
	-- Check: Buff dropped
	local v1 = table.foreach(EA_CurrentBuffs,
		function(i, v1)
			-- DEFAULT_CHAT_FRAME:AddMessage("buff-check: "..i.." id: "..v1)
			SpellEnable = false
			SpellEnable = EAFun_GetSpellItemEnable(EA_AltItems[EA_playerClass][v1])
			if (not SpellEnable) then				
				local v3 = table.foreach(buffsCurrent,					
					function(k, v2)							
						if (v1==v2) then
							return v2
						end
					end
				)
				if(not v3) then					
					-- Buff dropped
					table.insert(buffsToDelete, v1)					
				end			
			end
		end
	)
	]]--
	-- Check: Buff dropped	
	
	local v = foreach(EA_CurrentBuffs,
		function(i, v1)		
			--DEFAULT_CHAT_FRAME:AddMessage("buff-check: "..i.." id: "..v1)
			SpellEnable = false
			OtherEnable = false			
			SpellEnable = EAFun_GetSpellItemEnable(PlayerItems[v1])	
			OtherEnable = EAFun_GetSpellItemEnable(OtherItems[v1])			
			if (SpellEnable) or (OtherEnable) then				
				local v3 = foreach(buffsCurrent,						
					function(k, v2)							
						if (v1==v2)  then							
							return v2
						end
					end
				)
				if(not v3) then					
					-- Buff dropped					
					tinsert(buffsToDelete, v1)					
				end			
			end
		end
	)
	-- Drop Buffs
	foreach(buffsToDelete,
		function(i, v)			
			-- DEFAULT_CHAT_FRAME:AddMessage("buff-dropped: id: "..v)			
			G:Buff_Dropped(v)
		end
	)
	-- Check: Buff applied
	local v1 = foreach(buffsCurrent,
		function(i, v1)
			local v2 = foreach(EA_CurrentBuffs,
				function(k, v2)
					if (v1==v2) then
						return v2
					end
				end
			)
			if(not v2) then
				-- Buff applied
				G:Buff_Applied(v1)
			end
		end
	)
	-- G:PositionFrames()
	if (EA_DEBUGFLAG11 or EA_DEBUGFLAG21) then
		CreateFrames_EventsFrame_RefreshSpellList(3)
	end
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function G:TarBuffs_Update(...)
	
	if type(...) == "table" and #(...) == 2  then 
		local unit, unitAuraUpdateInfo = ...
	end 
	
	local tinsert = table.insert
	local tforeach = table.foreach
	local UnitAura = UnitAura
	
	local buffsCurrent = {}
	local buffsToDelete = {}
	local SpellEnable = false
	local OtherEnable = false
	local ifAdd_buffCur = false
	local orderWtd = 1
	-- DEFAULT_CHAT_FRAME:AddMessage("G:Buffs_Update")
	-- if (EA_DEBUGFLAG2) then
	--  DEFAULT_CHAT_FRAME:AddMessage("--------"..EA_XCMD_TARGETLIST.."--------")
	-- end
		
	local TarItems = EA_TarItems[EA_playerClass]
	local OtherItems = EA_Items[EA_CLASS_OTHER]
	local P,T = "player", "target"
	local 	name,  icon, count, debuffType, duration, expirationTime, 
			unitCaster, isStealable, nameplateShowPersonal, spellID, 
			canApplyAura, isBossDebuff, isCastByPlayer, nameplateShowAll, 
			timeMod, value1, value2, value3
			
	for i=1,40 do
		
		name,  icon, count, debuffType, duration, expirationTime, 
		unitCaster, isStealable, nameplateShowPersonal, spellID, 
		canApplyAura, isBossDebuff, isCastByPlayer, nameplateShowAll, 
		timeMod, value1, value2, value3 = UnitAura(T, i, "HARMFUL")
				
		--if (not spellID) then break end
		if (spellID == nil) then break end
		
		if (EA_DEBUGFLAG2) then
			if (EA_LISTSEC_TARGET == 0 or (0 < duration and duration <= EA_LISTSEC_TARGET)) then
				EAFun_AddSpellToScrollFrame(spellID, " /\124cffFFFF00"..EA_XCMD_DEBUG_P3.."\124r:"..count..
					" /\124cffFFFF00"..EA_XCMD_DEBUG_P4.."\124r:"..duration)
				-- DEFAULT_CHAT_FRAME:AddMessage("["..i.."]\124cffFFFF00"..EA_XCMD_DEBUG_P1.."\124r:"..name..
				--  " /\124cffFFFF00"..EA_XCMD_DEBUG_P2.."\124r:"..spellID..
				--  " /\124cffFFFF00"..EA_XCMD_DEBUG_P3.."\124r:"..count..
				--  " /\124cffFFFF00"..EA_XCMD_DEBUG_P4.."\124r:"..duration)
			end
		end
		ifAdd_buffCur = false
		--spellID = tostring(spellID)
		SpellEnable = EAFun_GetSpellItemEnable(TarItems[spellID])
		OtherEnable = EAFun_GetSpellItemEnable(OtherItems[spellID])
		if (SpellEnable) then			
			ifAdd_buffCur, orderWtd = EAFun_CheckSpellConditionMatch(count, unitCaster, TarItems[spellID])
		elseif (OtherEnable) then
			-- ifAdd_buffCur = true
			ifAdd_buffCur, orderWtd = EAFun_CheckSpellConditionMatch(count, unitCaster, OtherItems[spellID])	
		end 
		if (ifAdd_buffCur) then
				-- if EA_SPELLINFO_TARGET[spellID] == nil then 
					-- EA_SPELLINFO_TARGET[spellID] = {name,  icon, count, duration, expirationTime, unitCaster, isDebuff} 
				-- end
				
				-- EA_SPELLINFO_TARGET[spellID].name 			= name
				-- EA_SPELLINFO_TARGET[spellID].icon 			= icon
				-- EA_SPELLINFO_TARGET[spellID].count 			= count
				-- EA_SPELLINFO_TARGET[spellID].duration		= duration
				-- EA_SPELLINFO_TARGET[spellID].expirationTime 	= expirationTime
				-- EA_SPELLINFO_TARGET[spellID].unitCaster 		= unitCaster
				-- EA_SPELLINFO_TARGET[spellID].isDebuff 		= true
				-- EA_SPELLINFO_TARGET[spellID].orderWtd 		= orderWtd
				-- EA_SPELLINFO_TARGET[spellID].value 			= {value1,value2,value3}
				-- EA_SPELLINFO_TARGET[spellID].aura 			= true
				
				EA_SPELLINFO_TARGET[spellID]	=	{
													name			=	name,
													icon			=	icon,
													count			=	count,
													duration		=	duration,
													expirationTime	=	expirationTime,
													unitCaster		=	unitCaster,
													isDebuff		=	true,
													orderwtd		=	orderWtd,
													value			=	{value1, value2, value3},
													aura			=	true,
													}
				tinsert(buffsCurrent, spellID)
		end		
	end
	
	for i=1,40 do
	
		name,  icon, count, debuffType, duration, expirationTime, 
		unitCaster, isStealable, nameplateShowPersonal, spellID,
		canApplyAura, isBossDebuff, isCastByPlayer, nameplateShowAll, 
		timeMod, value1, value2, value3 = UnitAura(T, i, "HELPFUL")
		--if (not spellID) then break end
		if (spellID==nil) then break end
		--if isCastByPlayer then unitCaster = "player" end
		if (EA_DEBUGFLAG2) then
			if (EA_LISTSEC_TARGET == 0 or (0 < duration and duration <= EA_LISTSEC_TARGET)) then
				EAFun_AddSpellToScrollFrame(spellID, " /\124cffFFFF00"..EA_XCMD_DEBUG_P3.."\124r:"..count..
					" /\124cffFFFF00"..EA_XCMD_DEBUG_P4.."\124r:"..duration)
				-- DEFAULT_CHAT_FRAME:AddMessage("["..i.."]\124cffFFFF00"..EA_XCMD_DEBUG_P1.."\124r:"..name..
				--  " /\124cffFFFF00"..EA_XCMD_DEBUG_P2.."\124r:"..spellID..
				--  " /\124cffFFFF00"..EA_XCMD_DEBUG_P3.."\124r:"..count..
				--  " /\124cffFFFF00"..EA_XCMD_DEBUG_P4.."\124r:"..duration)
			end
		end
		ifAdd_buffCur = false
		--spellID = tostring(spellID)
		SpellEnable = EAFun_GetSpellItemEnable(TarItems[spellID])
		OtherEnable = EAFun_GetSpellItemEnable(OtherItems[spellID])
		if (SpellEnable) then			
			ifAdd_buffCur, orderWtd = EAFun_CheckSpellConditionMatch(count, unitCaster, TarItems[spellID])
		elseif (OtherEnable) then
			-- ifAdd_buffCur = true
			ifAdd_buffCur, orderWtd = EAFun_CheckSpellConditionMatch(count, unitCaster, OtherItems[spellID])			
		end 
		if (ifAdd_buffCur) then
				-- if EA_SPELLINFO_TARGET[spellID] == nil then 
					-- EA_SPELLINFO_TARGET[spellID] = {name,  icon, count, duration, expirationTime, unitCaster, isDebuff} 
				-- end
				-- EA_SPELLINFO_TARGET[spellID].name = name
				-- EA_SPELLINFO_TARGET[spellID].icon = icon
				-- EA_SPELLINFO_TARGET[spellID].count = count
				-- EA_SPELLINFO_TARGET[spellID].duration = duration
				-- EA_SPELLINFO_TARGET[spellID].expirationTime = expirationTime
				-- EA_SPELLINFO_TARGET[spellID].unitCaster = unitCaster
				-- EA_SPELLINFO_TARGET[spellID].isDebuff = false
				-- EA_SPELLINFO_TARGET[spellID].orderWtd = orderWtd
				-- EA_SPELLINFO_TARGET[spellID].value = {value1,value2,value3}
				-- EA_SPELLINFO_TARGET[spellID].aura = true
				
				EA_SPELLINFO_TARGET[spellID]	=	{
													name			=	name,
													icon			=	icon,
													count			=	count,
													duration		=	duration,
													expirationTime	=	expirationTime,
													unitCaster		=	unitCaster,
													isDebuff		=	false,
													orderwtd		=	orderWtd,
													value			=	{value1, value2, value3},
													aura			=	true,
													}
				tinsert(buffsCurrent, spellID)
		end
end
	-- Check: Buff dropped
	local v1 = tforeach(EA_TarCurrentBuffs,
		function(i, v1)
			-- DEFAULT_CHAT_FRAME:AddMessage("buff-check: "..i.." id: "..v1)
			local v2 = tforeach(buffsCurrent,
				function(k, v2)
					-- DEFAULT_CHAT_FRAME:AddMessage("=== buff-check: "..i.." /v2 id: "..v1)
					if (v1==v2) then
						return v2
					end
				end
			)
			if(not v2) then
				-- Buff dropped
				-- DEFAULT_CHAT_FRAME:AddMessage("=== add to Delete /v1 id: "..v1)
				tinsert(buffsToDelete, v1)
			end
		end
	)
	-- Drop Buffs
	tforeach(buffsToDelete,
		function(i, v)
			-- DEFAULT_CHAT_FRAME:AddMessage("buff-dropped: id: "..v)
			G:TarBuff_Dropped(v)
		end
	)
	-- Check: Buff applied
	local v1 = tforeach(buffsCurrent,
		function(i, v1)
			local v2 = tforeach(EA_TarCurrentBuffs,
				function(k, v2)
					if (v1==v2) then
					return v2
					end
				end
			)
			if(not v2) then
				-- Buff applied
				-- DEFAULT_CHAT_FRAME:AddMessage("G:Buff_Applied("..v1..")")
				G:TarBuff_Applied(v1)
			end
		end
	)
	-- G:TarPositionFrames()
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function G:TarChange_ClearFrame()
	-- local TarBuff_Dropped = G:TarBuff_Dropped
	local ibuff = #EA_TarCurrentBuffs
	local i
	for i=1, ibuff do
		G:TarBuff_Dropped(EA_TarCurrentBuffs[1])
	end
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function G:ScdBuffs_Update(EA_Unit, EA_SpellName, EA_spellID, EA_timestp)
		
		if EA_flagAllHidden == true then 
			EA_Main_Frame:SetAlpha(0) 
			return 
		else
			EA_Main_Frame:SetAlpha(1) 
		end
		
		local spellID = tonumber(EA_spellID)
		--local spellDescription = GetSpellDescription(spellID)
		local sSpellLink = ""
		local SpellEnable = false
		local ScdItems = EA_ScdItems[EA_playerClass]
		local EA_SPELLINFO_SCD_SPELLID = EA_SPELLINFO_SCD[spellID]
		
		-- DEFAULT_CHAT_FRAME:AddMessage("spellID="..spellID.." / EA_SpellName="..EA_SpellName)
		-- DEFAULT_CHAT_FRAME:AddMessage("EA_Unit="..EA_Unit)
		if ((EA_Unit == UnitName("player") or (EA_Unit == UnitName("pet"))) and (spellID ~= 0)) then
			-- print (EA_spellID.." /"..EA_SpellName.." /"..EA_Unit)
		-- if ((EA_Unit == "player") and (spellID ~= 0)) then
			if (EA_DEBUGFLAG3) then
				sSpellLink = GetSpellLink(EA_spellID)
				--if (sSpellLink ~= nil) then
					-- DEFAULT_CHAT_FRAME:AddMessage("\124cffFFFF00"..EA_XCMD_DEBUG_P2.."\124r="..EA_spellID.." / \124cffFFFF00"..EA_XCMD_DEBUG_P1.."\124r="..sSpellLink)
					EAFun_AddSpellToScrollFrame(EA_spellID, "")
				--end
			end
			--if (spellID==47666 or spellID==47750) then spellID=47540 end   -- Priest Penance
			--if (spellID==73921 or spellID==98887) then spellID=73920 end   -- Shaman Healing Rain
			--if (spellID==61391) then spellID=50516 end   			-- Druid Typhoon
			SpellEnable = EAFun_GetSpellItemEnable(ScdItems[spellID])			
			
			if (SpellEnable) then
				-- DEFAULT_CHAT_FRAME:AddMessage("spellID="..spellID.." / EA_ScdItems[EA_playerClass][spellID]=true")
				local strspellID = tostring(spellID)

				local eaf = _G["EAScdFrame_"..strspellID]

				insertBuffValue(EA_ScdCurrentBuffs, spellID)				
				--if EA_SPELLINFO_SCD[spellID].start == nil then
				local EA_start, EA_duration, EA_Enable = GetSpellCooldown(spellID)
				-- local s = EA_SPELLINFO_SCD[spellID].start
				local s = EA_SPELLINFO_SCD_SPELLID.start
				--local d = EA_duration or EA_SPELLINFO_SCD[spellID].duration
				-- local d =  EA_SPELLINFO_SCD[spellID].duration
				local d =  EA_SPELLINFO_SCD_SPELLID.duration
				local t = GetTime()
				if EA_start == 0 then
					if s == nil or s == 0 then					
						EA_SPELLINFO_SCD_SPELLID.start = t					
					else
						
						if d and (d>0) then						
							if format("%d",s+d) <= format("%d",t) then 							
								EA_SPELLINFO_SCD_SPELLID.start = t 							
							end							
						end
					end
				end
				
				
				
				if eaf ~= nil then
					eaf:Hide()
					if not eaf:IsVisible() then
						local gsiIcon = EA_SPELLINFO_SCD_SPELLID.icon
						--for 7.0
						if not eaf.texture then eaf.texture=eaf:CreateTexture() end
						eaf.texture:SetAllPoints(eaf)
						eaf.texture:SetTexture(gsiIcon)
						--eaf:SetBackdrop({bgFile = gsiIcon})
						eaf:SetWidth(EA_Config.IconSize)
						eaf:SetHeight(EA_Config.IconSize)

						eaf:SetAlpha(1)	

						-- local tmpUpdateInterval = G:UpdateInterval 
						-- if EA_start and (t - EA_start) > 1  then 
							-- tmpUpdateInterval = tmpUpdateInterval * 10	 
						-- else
							-- tmpUpdateInterval = tmpUpdateInterval * 1	 
						-- end
						-- Lib_ZYF:FrameSetOnUpdate(eaf, tmpUpdateInterval , G:OnSCDUpdate, spellID)
						
						-- eaf:SetScript("OnUpdate", function(self,elapsedTime)
							 -- G:TimeSinceUpdate_SCD = G:TimeSinceUpdate_SCD + elapsedTime
							 -- if G:TimeSinceUpdate_SCD > G:UpdateInterval then
								 -- G:OnSCDUpdate(spellID)
								 -- G:TimeSinceUpdate_SCD = 0
							 -- end
						-- end)
					end					
					if eaf:IsShown()==false then eaf:Show() end
					--G:ScdPositionFrames()
				end
			end
		end
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function G:Buff_Dropped(spellID)
	-- DEFAULT_CHAT_FRAME:AddMessage("buff-dropping: id: "..spellID)
	local eaf = _G["EAFrame_"..spellID]
	if eaf~= nil then
		G:FrameGlowShowOrHide(eaf,false)
		--EA_ActionButton_HideOverlayGlow(eaf)
		--eaf.overgrow = false
		eaf:Hide()
		-- eaf:SetScript("OnUpdate", nil)
		Lib_ZYF:StopOnUpdate(eaf)
	end
	G:removeBuffValue(EA_CurrentBuffs, spellID)
	-- G:PositionFrames()
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function G:Buff_Applied(spellID)
	-- DEFAULT_CHAT_FRAME:AddMessage("buff-applying: id: "..spellID)
	tinsert(EA_CurrentBuffs, spellID)
	G:PositionFrames()
	G:DoAlert()
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function G:TarBuff_Dropped(spellID)
	-- DEFAULT_CHAT_FRAME:AddMessage("buff-dropping: id: "..spellID)
	local eaf = _G["EATarFrame_"..spellID]
	if eaf ~= nil then
		G:FrameGlowShowOrHide(eaf,false)
		--EA_ActionButton_HideOverlayGlow(eaf)
		--eaf.overgrow = false
		eaf:Hide()
		Lib_ZYF:StopOnUpdate(eaf)
		-- eaf:SetScript("OnUpdate", nil)
	end
	G:removeBuffValue(EA_TarCurrentBuffs, spellID)
	G:TarPositionFrames()
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function G:TarBuff_Applied(spellID)
	-- DEFAULT_CHAT_FRAME:AddMessage("buff-applying: id: "..spellID)
	tinsert(EA_TarCurrentBuffs, spellID)
	G:TarPositionFrames()
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function G:SPELL_UPDATE_USABLE()
	local tonumber = tonumber
	local IsUsableSpell = IsUsableSpell	
	local EA_CurrentBuffs = EA_CurrentBuffs
	local AltItems = EA_AltItems[EA_playerClass]
	local SpellEnable = false
	local s,v,v2,i2
	local spellID
	local flag_usable, flag_nomana
	if (EA_Config.AllowAltAlerts==true) then
		-- DEFAULT_CHAT_FRAME:AddMessage("spell-active: "..spellName)
		-- searching for the spell-id, because we only get the name of the spell
		for s, v in pairs(AltItems) do
			spellID = tonumber(s)
			SpellEnable = v.enable
			local v2 = table.foreach(EA_CurrentBuffs,
				function(i2, v2)					
					if v2==spellID then						
						return v2
					end
				end)
			flag_usable, flag_nomana = IsUsableSpell(spellID)
			if (SpellEnable and flag_usable) then
				if (not v2) then
					-- DEFAULT_CHAT_FRAME:AddMessage("G:Buff_Applied("..spellID..")")
					G:Buff_Applied(spellID)
					
				end
			else
				if (v2) then
					G:Buff_Dropped(spellID)
					
				end
			end
		end
	end	
end
--[[
function G:COMBAT_TEXT_SPELL_ACTIVE(spellName)
	local SpellEnable = false
	if (EA_Config.AllowAltAlerts==true) then
		-- DEFAULT_CHAT_FRAME:AddMessage("spell-active: "..spellName)
		-- searching for the spell-id, because we only get the name of the spell
		local spellID = table.foreach(EA_ClassAltSpellName,
		function(i, spellID)
			-- DEFAULT_CHAT_FRAME:AddMessage("EA_ClassAltSpellName("..spellID..")")
			print(i,spellID)
			if i==spellName then
				return spellID
			end
		end)
		if spellID then
			spellID = tonumber(spellID)
			SpellEnable = EAFun_GetSpellItemEnable(EA_AltItems[EA_playerClass][spellID])
			if (SpellEnable) then
				local v2 = table.foreach(EA_CurrentBuffs,
				function(i2, v2)
					if v2==spellID then
						return v2
					end
				end)
				if (not v2) then
					-- DEFAULT_CHAT_FRAME:AddMessage("G:Buff_Applied("..spellID..")")
					G:Buff_Applied(spellID)
					G:PositionFrames()
				end
			end
		end
	end
end
]]--
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function G:OnUpdate(spellID)
	
	local tonumber = tonumber
	local tostring = tostring
	local IsUsableSpell = IsUsableSpell	
	
	local PlayerItems = EA_Items[EA_playerClass]
	local OtherItems  = EA_Items[EA_CLASS_OTHER]	
	--	local timerFontSize = 0
	local SC_RedSecText, isOverGrow = -1, false
	local strSpellID = tostring(spellID)
	local eaf = _G["EAFrame_"..strSpellID]
	local EA_usable, EA_nomana
	local SpellEnable
	local s,v
	
	spellID = tonumber(strSpellID)
	local name = EA_SPELLINFO_SELF[spellID].name	
	
	if (EA_Config.AllowAltAlerts == true) then
		for s,v in pairs(OtherItems) do
			--local SpellEnable = EAFun_GetSpellItemEnable(EA_AltItems[EA_playerClass][spellID])
			SpellEnable = v.enable
			if (s==spellID and SpellEnable) then
				--local EA_usable, EA_nomana = IsUsableSpell(name)
				EA_usable, EA_nomana = IsUsableSpell(s)
				if (EA_usable) then					
					-- local _,_,_,EAA_count,_,_,EAA_expirationTime,_,_ = UnitAura("player", name, rank)
					EA_SPELLINFO_SELF[s]	=	{
												count = 0,
												expirationTime = 0,
												isDebuff = false,
												}
					-- G:PositionFrames()
				else					
					G:Buff_Dropped(s)
					-- G:PositionFrames()
					return
				end
			end
		end
	end
	if eaf ~= nil then
		--eaf:SetCooldown(1, 0)
		if (EA_Config.ShowTimer) then
			-- local _,_,_,_,_,_,EA_expirationTime,_,_ = UnitAura("player", name, rank)
			-- local EA_Name,_,_,EA_count,_,_,EA_expirationTime,_,_ = UnitAura("player", name, rank)
			local EA_SPELLINFO_SELF_SPELLID = EA_SPELLINFO_SELF[spellID]
			local EA_Name 					= EA_SPELLINFO_SELF_SPELLID.name
			local EA_count 					= EA_SPELLINFO_SELF_SPELLID.count
			local EA_expirationTime 		= EA_SPELLINFO_SELF_SPELLID.expirationTime
			local EA_isDebuff 				= EA_SPELLINFO_SELF_SPELLID.isDebuff
			local EA_currentTime 			= 0
			local EA_timeLeft				= 0
			-- eaf:SetCooldown(EA_start, EA_duration)
			if (EA_expirationTime ~= nil) then
				EA_currentTime = GetTime()
				EA_timeLeft = 0 + EA_expirationTime - EA_currentTime
			end
			SC_RedSecText = EAFun_GetSpellConditionRedSecText(PlayerItems[spellID])
			if (SC_RedSecText == -1 ) then
				SC_RedSecText = EAFun_GetSpellConditionRedSecText(OtherItems[spellID])
			end
			EAFun_SetCountdownStackText(eaf, EA_timeLeft, EA_count, SC_RedSecText)
			isOverGrow = EAFun_CheckSpellConditionOverGrow(EA_count, PlayerItems[spellID])
			if (not isOverGrow) then
				isOverGrow = EAFun_CheckSpellConditionOverGrow(EA_count, OtherItems[spellID])
			end
			G:FrameGlowShowOrHide(eaf,isOverGrow)
		else
			eaf.spellTimer:SetText("")
			eaf.spellStack:SetText("")
		end
	end
end
-----------------------------------------------------------------
-- function G:OnTarUpdate()
function G:OnTarUpdate(spellID)
	
	local tonumber = tonumber
	
	local TarItems = EA_TarItems[EA_playerClass]
	local OtherItems = EA_Items[EA_CLASS_OTHER]	
	local SC_RedSecText, isOverGrow = -1, false
	
	local strSpellID = tostring(spellID)
	local eaf = _G["EATarFrame_"..strSpellID]
	spellID = tonumber(strSpellID)		
	
	if eaf ~= nil then
		--eaf:SetCooldown(1, 0)
		if (EA_Config.ShowTimer) then
			--local EA_Name,_,_,EA_count,_,EA_duration,EA_expirationTime,_,_ = UnitAura("target", name, rank, "HELPFUL|HARMFUL")
			local EA_SPELLINFO_TARGET_SPELLID 	= EA_SPELLINFO_TARGET[spellID]
			local EA_Name 						= EA_SPELLINFO_TARGET_SPELLID.name
			local EA_count 						= EA_SPELLINFO_TARGET_SPELLID.count
			local EA_expirationTime 			= EA_SPELLINFO_TARGET_SPELLID.expirationTime
			local EA_isDebuff 					= EA_SPELLINFO_TARGET_SPELLID.isDebuff
			local EA_currentTime 				= 0
			local EA_timeLeft 					= 0
			if (EA_expirationTime ~= nil) then
				EA_currentTime = GetTime()
				EA_timeLeft = 0 + EA_expirationTime - EA_currentTime
			end		
			
			SC_RedSecText = EAFun_GetSpellConditionRedSecText(TarItems[spellID])
			if (SC_RedSecText == -1 ) then
				SC_RedSecText = EAFun_GetSpellConditionRedSecText(OtherItems[spellID])
			end
			EAFun_SetCountdownStackText(eaf, EA_timeLeft, EA_count, SC_RedSecText)
			
			isOverGrow = EAFun_CheckSpellConditionOverGrow(EA_count, TarItems[spellID])
			if (not isOverGrow) then
				isOverGrow = EAFun_CheckSpellConditionOverGrow(EA_count, OtherItems[spellID])
			end
			G:FrameGlowShowOrHide(eaf,isOverGrow)
		else
			eaf.spellTimer:SetText("")
			eaf.spellStack:SetText("")
		end
		-- G:TarPositionFrames()
	end
end
-----------------------------------------------------------------

function G:OnSCDUpdate(spellID)	
	
	local GetInventoryItemID = GetInventoryItemID
	local GetInventoryItemCooldown = GetInventoryItemCooldown
	local GetItemSpell = GetItemSpell
	local GetItemCooldown = GetItemCooldown
	local GetSpellCooldown = GetSpellCooldown
	local GetContainerNumSlots = GetContainerNumSlots
	local GetContainerItemID = GetContainerItemID
	local GetSpellTexture = GetSpellTexture
	
	local select = select
	
	local iShift = 0
	local cooldown_alpha = 0.5
	local eaf = _G["EAScdFrame_"..spellID]
	local flag_usable,flag_nomana = IsUsableSpell(spellID)
	local EA_ChargeCurrent, EA_ChargeMax, EA_ChargeStart,EA_ChargeDuration = GetSpellCharges(spellID)
	local EA_start, EA_duration, EA_Enable = GetSpellCooldown(spellID)	
	local ScdItems = EA_ScdItems[EA_playerClass]
	
	local tmpItemID
	local tmpSpellID
	
	local flagFind = false
	local i
	local p = "player"
	local tmpStart, tmpDuration, tmpEnable
	local flagSameSpell=false
	for i=17, 1, -1 do 
		if flagFind then break end
		tmpItemID  = GetInventoryItemID(p, i)		
		if tmpItemID then 
			tmpSpellID = select(2, GetItemSpell(tmpItemID))
			if tmpSpellID == 55004 then tmpSpellID = 54861 end
			if (spellID == tmpSpellID) then			
				--EA_start, EA_duration, EA_Enable = GetSpellCooldown(spellID)
				--EA_start, EA_duration, EA_Enable = GetItemCooldown(tmpItemID)
				EA_start, EA_duration, EA_Enable = GetInventoryItemCooldown(p, i)
				
				flagSameSpell=false
				--處理共同法術ID飾品問題
				if (i == 13) then 					
					tmpStart, tmpDuration, tmpEnable = GetInventoryItemCooldown(p, 14)
					tmpSpellID2 = select(2, GetItemSpell(GetInventoryItemID(p, 14)))					
					if spellID == tmpSpellID2 then												
						flagSameSpell = true
					end
				end 
				if (i==14) then 
					tmpStart, tmpDuration, tmpEnable = GetInventoryItemCooldown(p, 13)
					tmpSpellID2 = select(2, GetItemSpell(GetInventoryItemID(p, 13)))					
					if spellID == tmpSpellID2  then																		
							flagSameSpell = true						
					end
				end 
				if  ((i==13) or (i==14)) then
					if flagSameSpell then
						if (tmpStart==0) or ((EA_start+EA_duration-GetTime()) > (tmpStart+tmpDuration-GetTime())) 	 then 
							EA_duration = tmpDuration
							EA_start = tmpStart
							EA_Enbale = tmpEnable
						end	
					else 
						
					end
				end
				
				flagFind = true				
				break			
			end
		end
		
	end     
	
	-- local bagID, slotID
	-- for bagID = 0, 4 do 
		-- if flagFind then break end
		-- for slotID = 1, GetContainerNumSlots(bagID) do
			-- tmpItemID = GetContainerItemID(bagID, slotID)
			-- if tmpItemID and spellID == select(2, GetItemSpell(tmpItemID)) then					
				-- EA_start, EA_duration, EA_Enable = GetItemCooldown(tmpItemID)
				-- flagFind = true
				-- break			
			-- end						
		-- end		
	-- end
	
	if flagFind==false then
		--local itemID = EA_Config.EA_SPELL_ITEM[spellID]
		local itemID = EA_Config.EA_SPELL_ITEM[spellID]
		if itemID then		
			EA_start, EA_duration, EA_Enable = GetItemCooldown(itemID)
			flagFind = true
		end
	end
	
	local EA_SPELLINFO_SCD_SPELLID = EA_SPELLINFO_SCD[spellID]
	local s = EA_SPELLINFO_SCD_SPELLID.start 
	local d = EA_SPELLINFO_SCD_SPELLID.duration
	local SC_RedSecText
	local gsiIcon
	local EA_timeLeft
	
	if  d and d > 0 then 
		EA_duration = d
		if s and s > 0 then EA_start = s end
	end	
	if (eaf ~= nil) then
		gsiIcon = GetSpellTexture(spellID)
		if not eaf.texture then eaf.texture = eaf:CreateTexture() end
		eaf.texture:SetAllPoints(eaf)
		eaf.texture:SetTexture(gsiIcon)
		eaf:SetWidth(EA_Config.IconSize)
		eaf:SetHeight(EA_Config.IconSize)
		if (EA_Position.SCD_UseCooldown) then
			eaf.useCooldown = true
		else
			eaf.useCooldown = false
		end		
		if EA_ChargeCurrent then
			EA_timeLeft = EA_ChargeStart + EA_ChargeDuration - GetTime()
			if EA_ChargeCurrent > 0 then
				if (EA_ChargeCurrent == EA_ChargeMax) then				
					SC_RedSecText = EAFun_GetSpellConditionRedSecText(ScdItems[spellID])					
					if eaf.useCooldown then
						eaf.cooldown:SetHideCountdownNumbers(false)						
						eaf.cooldown:SetDrawSwipe(false)
						eaf.cooldown:SetCooldown(0, 0)						
						if EA_ChargeCurrent == 1 then 							
							EAFun_SetCountdownStackText(eaf, 0 , 0, SC_RedSecText)						
						else
							EAFun_SetCountdownStackText(eaf, 0 , EA_ChargeCurrent, SC_RedSecText)						
						end
					else
						if EA_ChargeCurrent == 1 then 						
							EAFun_SetCountdownStackText(eaf, 0 , 0, SC_RedSecText)							
						else
							EAFun_SetCountdownStackText(eaf, 0 , EA_ChargeCurrent, SC_RedSecText)							
						end
					end
					if EA_Config.SCD_RemoveWhenCooldown == true then 
						G:RemoveSingleSCDCurrentBuff(spellID) 
					end
				else
					if eaf.useCooldown then					
						eaf.cooldown:SetSwipeColor(1.0, 1.0, 1.0, cooldown_alpha)							
						eaf.cooldown:SetHideCountdownNumbers(true)						
						eaf.cooldown:SetDrawSwipe(true)							
						eaf.cooldown:SetCooldown(EA_ChargeStart, EA_ChargeDuration)
					end	
					SC_RedSecText = EAFun_GetSpellConditionRedSecText(ScdItems[spellID])					
					EAFun_SetCountdownStackText(eaf, EA_timeLeft , EA_ChargeCurrent, SC_RedSecText)
				end
				if EA_Config.SCD_GlowWhenUsable==true  then 
					G:FrameGlowShowOrHide(eaf,flag_usable)
				end
			else
				SC_RedSecText = EAFun_GetSpellConditionRedSecText(ScdItems[spellID])					
				if eaf.useCooldown then
					eaf.cooldown:SetSwipeColor(1.0, 1.0, 1.0, cooldown_alpha)					
					eaf.cooldown:SetHideCountdownNumbers(true)					
					eaf.cooldown:SetDrawSwipe(true)
					eaf.cooldown:SetCooldown(EA_ChargeStart, EA_ChargeDuration)										
				end	
				EAFun_SetCountdownStackText(eaf, EA_timeLeft , EA_ChargeCurrent, SC_RedSecText)					
				if EA_Config.SCD_GlowWhenUsable == true then
					G:FrameGlowShowOrHide(eaf,  false)								
				end
			end
		else
			if (EA_Enable == 1) then
				EA_timeLeft = EA_start + EA_duration - GetTime()
				
				local EA_GCD 
				EngClass = select(2, UnitClass(p))
				if (EngClass==EA_CLASS_ROGUE) or 
				   (EngClass==EA_CLASS_DRUID and GetShapeshiftForm()==2 ) then
					EA_GCD = 1
				else
					EA_GCD = 1.5
				end				
				EA_GCD = EA_GCD / (1 + GetHaste()/100)
				if EA_GCD < 0.75 then EA_GCD = 0.75 end
				--print("EAM GCD:",EA_GCD)
				--print("GetSpellCooldown(61304):",(select(2,GetSpellCooldown(61304))))
				
				--if (EA_start > 0 and EA_duration > EA_GCD )  then
				if (EA_timeLeft > 0 and EA_duration > EA_GCD )  then
					 --DEFAULT_CHAT_FRAME:AddMessage("[spellID="..spellID.." / EA_timeLeft="..EA_timeLeft.."]")
					if EA_Config.SCD_GlowWhenUsable then G:FrameGlowShowOrHide(eaf, false) end
					SC_RedSecText = EAFun_GetSpellConditionRedSecText(ScdItems[spellID])					
					if eaf.useCooldown then
						eaf.cooldown:SetSwipeColor(1.0, 1.0, 1.0, cooldown_alpha)
						eaf.cooldown:SetHideCountdownNumbers(true)						
						eaf.cooldown:SetDrawSwipe(true)
						eaf.cooldown:SetCooldown(EA_start, EA_duration)
					end 
						EAFun_SetCountdownStackText(eaf, EA_timeLeft , 0, SC_RedSecText)
				else
					eaf.spellTimer:SetText("")												
					EA_SPELLINFO_SCD_SPELLID.start = nil					
					if EA_Config.SCD_RemoveWhenCooldown==true then 
						G:RemoveSingleSCDCurrentBuff(spellID) 
					else
						if EA_Config.SCD_GlowWhenUsable == true then
							G:FrameGlowShowOrHide(eaf,flag_usable)
						end
					end
				end
			end
		end
		-- G:ScdPositionFrames()
	end
	
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function G:DoAlert()
	if (EA_Config.ShowFlash == true) then
		UIFrameFadeIn(LowHealthFrame, 1, 0, 1)
		UIFrameFadeOut(LowHealthFrame, 2, 1, 0)
	end
	if (EA_Config.DoAlertSound == true) then
		PlaySoundFile(EA_Config.AlertSound)
	end
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function G:PositionFrames()	
	
	if EA_flagAllHidden == true then 
		EA_Main_Frame:SetAlpha(0) 
		return 
	else
		EA_Main_Frame:SetAlpha(1) 
	end
	
	local tonumber = tonumber
	local type = type
	local ipairs = ipairs
	local format = format
	--local EA_SPELLINFO_SELF = EA_SPELLINFO_SELF		
	local Anchor = EA_Position.Anchor
	local ShowAuraValueWhenOver = EA_Config.ShowAuraValueWhenOver						
	local IconSize = EA_Config.IconSize
	if (EA_Config.ShowFrame == true) then
		EA_Main_Frame:ClearAllPoints()
		EA_Main_Frame:SetPoint(Anchor, UIParent, EA_Position.relativePoint, EA_Position.xLoc, EA_Position.yLoc)
		local prevFrame = "EA_Main_Frame"
		local prevFrame2 = "EA_Main_Frame"
		local xOffset = 100 + EA_Position.xOffset
		local yOffset = 0 + EA_Position.yOffset
		local SfontName, SfontSize = "", 0
		
		EA_CurrentBuffs = EAFun_SortCurrBuffs(1, EA_CurrentBuffs)	
		
		--for speedup
		local eaf
		local spellID
		local gsiName,gsiValue,gsiIcon,gsiIsDebuff		
		local tmp		
		local k,s,i,v
		local EA_SPELLINFO_SELF_SPELLID
		
		for k,s in ipairs(EA_CurrentBuffs) do
			eaf = _G["EAFrame_"..s]
			spellID = tonumber(s)	
			EA_SPELLINFO_SELF_SPELLID = EA_SPELLINFO_SELF[spellID]
			gsiName 	= EA_SPELLINFO_SELF_SPELLID.name
			gsiValue 	= EA_SPELLINFO_SELF_SPELLID.value 
			gsiIcon 	= EA_SPELLINFO_SELF_SPELLID.icon
			gsiIsDebuff = EA_SPELLINFO_SELF_SPELLID.isDebuff
			if eaf ~= nil then
				eaf:ClearAllPoints()
				if EA_Position.Tar_NewLine then
					if gsiIsDebuff then
						if (prevFrame2 == "EA_Main_Frame" or prevFrame2 == eaf) then
							prevFrame2 = "EA_Main_Frame"
							if EA_SpecFrame_Self then
								eaf:SetPoint(Anchor, prevFrame2, Anchor, -4 * xOffset, -2 * yOffset)
							else
								eaf:SetPoint(Anchor, prevFrame2, Anchor, -1 * xOffset, -1 * yOffset)
							end
						else
							eaf:SetPoint("CENTER", prevFrame2, "CENTER", -1 * xOffset, -1 * yOffset)
						end
						prevFrame2 = eaf
					else
						if (prevFrame == "EA_Main_Frame" or prevFrame == eaf) then
							prevFrame = "EA_Main_Frame"
							eaf:SetPoint(Anchor, prevFrame, Anchor, 0, 0)
						else
							eaf:SetPoint("CENTER", prevFrame, "CENTER", xOffset, yOffset)
						end
						prevFrame = eaf
					end
				else
					if (prevFrame == "EA_Main_Frame" or prevFrame == eaf) then
						prevFrame = "EA_Main_Frame"
						eaf:SetPoint(Anchor, prevFrame, Anchor, 0, 0)
					else
						eaf:SetPoint("CENTER", prevFrame, "CENTER", xOffset, yOffset)
					end
					prevFrame = eaf
				end
				eaf:SetWidth(IconSize)
				eaf:SetHeight(IconSize)
				--eaf:SetBackdrop({bgFile = gsiIcon})
				--for 7.0
				if not eaf.texture then eaf.texture = eaf:CreateTexture() end
				eaf.texture:SetAllPoints(eaf)
				eaf.texture:SetTexture(gsiIcon)
				--TEST
				--FrameAppendSpellTip(eaf,spellID)				
				G:FrameAppendAuraTip(eaf,"player",spellID,gsiIsDebuff)				
				G:FrameAppendAuraTip(eaf,"pet",spellID,gsiIsDebuff)				
				--if gsiIsDebuff then eaf:SetBackdropColor(EA_Position.RedDebuff,0,0) end
				--if gsiIsDebuff then eaf.texture:SetColorTexture(1.0,EA_Position.RedDebuff,EA_Position.RedDebuff) end
				if gsiIsDebuff then eaf.texture:SetVertexColor(1.0,EA_Position.RedDebuff,EA_Position.RedDebuff) end
				if (EA_Config.ShowName == true) then
					
					tmp={}
					tinsert(tmp,gsiName)
					if gsiValue and type(gsiValue)=="table" then
						for i, v in pairs(gsiValue) do
							v = tonumber(v)		--avoid true/false boolean value
							if v and (v > ShowAuraValueWhenOver) then 
								if v > 10000 then v = format("%.1f萬",v/10000) end
								-- tmp = tmp.."\n"..v 
								tinsert(tmp,"\n")
								tinsert(tmp,v)
							end
						end
					end
					--if gsiValue1 and (gsiValue1 > 0) then  tmp=tmp.."\n"..gsiValue1 end
					--if gsiValue2 and (gsiValue2 > 0) then  tmp=tmp.."\n"..gsiValue2 end
					--if gsiValue3 and (gsiValue3 > 0) then  tmp=tmp.."\n"..gsiValue3 end
					eaf.spellName:SetText(tconcat(tmp))
				
					
					SfontName, SfontSize = eaf.spellName:GetFont()
					eaf.spellName:SetFont(SfontName, EA_Config.SNameFontSize)
				else
					eaf.spellName:SetText("")
				end
				eaf.spellTimer:SetFont(EA_FONTS, EA_Config.TimerFontSize, "OUTLINE")
				eaf.spellStack:SetFont(EA_FONTS, EA_Config.StackFontSize, "OUTLINE")
				Lib_ZYF:FrameSetOnUpdate(eaf, G.UpdateInterval, G.OnUpdate, spellID)
				-- eaf:SetScript("OnUpdate", function(self,elapsedTime)
					-- G:TimeSinceUpdate_Self = G:TimeSinceUpdate_Self + elapsedTime
					-- if G:TimeSinceUpdate_Self > G:UpdateInterval then
						-- G:OnUpdate(spellID)
						-- G:TimeSinceUpdate_SELF = 0
					-- end
				-- end)
				if eaf:IsShown()==false then  eaf:Show() end
			end
		end
	end
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function G:TarPositionFrames()

	if EA_flagAllHidden == true then 
		EA_Main_Frame:SetAlpha(0) 
		return 
	else
		EA_Main_Frame:SetAlpha(1) 
	end
	
	local tonumber = tonumber
	local type = type
	local ipairs = ipairs
	local format = format
	
	if (EA_Config.ShowFrame == true) then
		EA_Main_Frame:ClearAllPoints()
		EA_Main_Frame:SetPoint(EA_Position.Anchor, UIParent, EA_Position.relativePoint, EA_Position.xLoc, EA_Position.yLoc)
		local prevFrame = "EA_Main_Frame"
		local prevFrame2 = "EA_Main_Frame"
		local xOffset = 100 + EA_Position.xOffset
		local yOffset = 0 + EA_Position.yOffset
		local SfontName, SfontSize = "", 0
		
		EA_TarCurrentBuffs = EAFun_SortCurrBuffs(2, EA_TarCurrentBuffs)
				
		local IconSize = EA_Config.IconSize
		local ShowAuraValueWhenOver = EA_Config.ShowAuraValueWhenOver
		
		--for speedup
		local s,i,k,v 
		local eaf
		local spellID
		local tmp		
		local EA_SPELLINFO_TARGET_SPELLID
		local gsiName,gsiIcon,gsiValue,gsiIsDebuff
		
		for k,v in ipairs(EA_TarCurrentBuffs) do
			eaf = _G["EATarFrame_"..v]
			spellID = tonumber(v)
			EA_SPELLINFO_TARGET_SPELLID = EA_SPELLINFO_TARGET[spellID]
			gsiName = EA_SPELLINFO_TARGET_SPELLID.name
			gsiIcon = EA_SPELLINFO_TARGET_SPELLID.icon
			gsiValue = EA_SPELLINFO_TARGET_SPELLID.value
			gsiIsDebuff = EA_SPELLINFO_TARGET_SPELLID.isDebuff
			if eaf ~= nil then
				eaf:ClearAllPoints()
				if EA_Position.Tar_NewLine then
					if gsiIsDebuff then
						if (prevFrame == "EA_Main_Frame" or prevFrame == eaf) then
							prevFrame = "EA_Main_Frame"
							eaf:SetPoint(EA_Position.TarAnchor, UIParent, EA_Position.TarAnchor, EA_Position.Tar_xOffset, EA_Position.Tar_yOffset)
						else
							eaf:SetPoint("CENTER", prevFrame, "CENTER", xOffset, yOffset)
						end
						prevFrame = eaf
					else
						if (prevFrame2 == "EA_Main_Frame" or prevFrame2 == eaf) then
							prevFrame2 = "EA_Main_Frame"
							if EA_SpecFrame_Target then
								eaf:SetPoint(EA_Position.TarAnchor, UIParent, EA_Position.TarAnchor, EA_Position.Tar_xOffset - 2 * xOffset, EA_Position.Tar_yOffset - 2 * yOffset)
								-- eaf:SetPoint(EA_Position.TarAnchor, prevFrame2, EA_Position.TarAnchor, -2 * xOffset, -2 * yOffset)
							else
								eaf:SetPoint(EA_Position.TarAnchor, UIParent, EA_Position.TarAnchor, EA_Position.Tar_xOffset - xOffset, EA_Position.Tar_yOffset - yOffset)
								-- eaf:SetPoint(EA_Position.TarAnchor, prevFrame2, EA_Position.TarAnchor, -1 * xOffset, -1 * yOffset)
							end
						else
							eaf:SetPoint("CENTER", prevFrame2, "CENTER", -1 * xOffset, -1 * yOffset)
						end
						prevFrame2 = eaf
					end
				else
					if (prevFrame == "EA_Main_Frame" or prevFrame == eaf) then
						prevFrame = "EA_Main_Frame"
						eaf:SetPoint(EA_Position.Anchor, prevFrame, EA_Position.Anchor, -1 * xOffset, -1 * yOffset)
					else
						eaf:SetPoint("CENTER", prevFrame, "CENTER", -1 * xOffset, -1 * yOffset)
					end
				end
				eaf:SetWidth(IconSize)
				eaf:SetHeight(IconSize)
				--eaf:SetBackdrop({bgFile = gsiIcon})
				--for 7.0
				if not eaf.texture then eaf.texture = eaf:CreateTexture() end
				eaf.texture:SetAllPoints(eaf)
				eaf.texture:SetTexture(gsiIcon)
				--增加鼠標提示
				--FrameAppendSpellTip(eaf,spellID)
				G:FrameAppendAuraTip(eaf,"target",spellID,gsiIsDebuff)
				--if gsiIsDebuff then eaf:SetBackdropColor(0,EA_Position.GreenDebuff,0) end
				--if gsiIsDebuff then eaf.texture:SetColorTexture(EA_Position.GreenDebuff,1.0,EA_Position.GreenDebuff) end
				if gsiIsDebuff then eaf.texture:SetVertexColor(EA_Position.GreenDebuff,1.0,EA_Position.GreenDebuff) end
				if (EA_Config.ShowName == true) then
					
					tmp={}
					tinsert(tmp,gsiName)
					if gsiValue and type(gsiValue)=="table" then
						for k,v in pairs(gsiValue) do
							v = tonumber(v) --avoid true/false boolean value
							if v and (v > ShowAuraValueWhenOver) then 
								if v > 10000 then v = format("%.1f萬",v/10000) end
								-- tmp = tmp.."\n"..v 
								tinsert(tmp,"\n")
								tinsert(tmp,v)
							end
						end
					end
					--if gsiValue1 and (gsiValue1 > 0) then  tmp=tmp.."\n"..gsiValue1 end
					--if gsiValue2 and (gsiValue2 > 0) then  tmp=tmp.."\n"..gsiValue2 end
					--if gsiValue3 and (gsiValue3 > 0) then  tmp=tmp.."\n"..gsiValue3 end
					eaf.spellName:SetText(tconcat(tmp))
					
					SfontName, SfontSize = eaf.spellName:GetFont()
					eaf.spellName:SetFont(SfontName, EA_Config.SNameFontSize)
				else
					eaf.spellName:SetText("")
				end
				eaf.spellTimer:SetFont(EA_FONTS, EA_Config.TimerFontSize, "OUTLINE")
				eaf.spellStack:SetFont(EA_FONTS, EA_Config.StackFontSize, "OUTLINE")
				
				Lib_ZYF:FrameSetOnUpdate(eaf, G.UpdateInterval, G.OnTarUpdate, spellID)
				-- eaf:SetScript("OnUpdate", function(self,elapsedTime)
					-- G:TimeSinceUpdate_Target = G:TimeSinceUpdate_Target + elapsedTime
					-- if G:TimeSinceUpdate_Target > G:UpdateInterval then
						-- G:OnTarUpdate(spellID)
						-- G:TimeSinceUpdate_Target = 0
					-- end				
				-- end)
				if eaf:IsShown()==false then  eaf:Show() end
			end
		end
	end
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]

function G:ScdPositionFrames()	
	
	if EA_flagAllHidden == true then 
		EA_Main_Frame:SetAlpha(0) 
		return 
	else
		EA_Main_Frame:SetAlpha(1) 
	end
	
	--If Player is Combating, don't show Spell Cooldown Frame.
	if UnitAffectingCombat("player") == false then		
		if EA_Config.SCD_NocombatStillKeep == false then
			HideAllScdCurrentBuff()
			return
		end
	end
	
	local mathabs	= math.abs
	local floor 	= math.floor
	local tonumber 	= tonumber	
	local ipairs 	= ipairs
	local pairs 	= pairs	
	
	local NewLineByIconCount = EA_Config.NewLineByIconCount
	local EA_Position = EA_Position
	
	if (EA_Config.ShowFrame == true) then
		
		EA_Main_Frame:ClearAllPoints()
		EA_Main_Frame:SetPoint(EA_Position.Anchor, UIParent, EA_Position.relativePoint, EA_Position.xLoc, EA_Position.yLoc)
		
		local prevFrame = "EA_Main_Frame"
		local xOffset = 100 + EA_Position.xOffset
		local yOffset =   0 + EA_Position.yOffset
		local SfontName, SfontSize = "", 0
		
		local s, v
		local k, v2		
		
		for s, v in pairs(EA_ScdItems[EA_playerClass]) do
			if EA_SPELLINFO_SCD[s] then
				for k, v2 in pairs(v) do 
					if (k == "orderwtd") then					
						EA_SPELLINFO_SCD[s][k] =  v2
					end 
					if (k == "redsectext") then					
						EA_SPELLINFO_SCD[s][k] =  v2
					end 
				end
			end
		end 
		
		EA_ScdCurrentBuffs = EAFun_SortCurrBuffs(3, EA_ScdCurrentBuffs)		
		
		local sx,sy = EA_Position.Scd_xOffset,EA_Position.Scd_yOffset
		local sanchor = EA_Position.ScdAnchor
		
		local i
		local eaf
		local spellID
		local gsiName
		local modvalue
		local divvalue
		local SfontName, SfontSize
		local EA_start
		local tmpUpdateInterval
		
		for i, v in ipairs(EA_ScdCurrentBuffs) do
			eaf = _G["EAScdFrame_"..v]
			spellID = tonumber(v)
			gsiName = EA_SPELLINFO_SCD[spellID].name			
			if eaf ~= nil then
				eaf:Hide()
				eaf:ClearAllPoints()
				if (prevFrame == "EA_Main_Frame") or (prevFrame == eaf ) then
					prevFrame = "EA_Main_Frame"
					eaf:SetPoint("CENTER", UIParent, sanchor, sx,sy)				
				else
					if NewLineByIconCount and NewLineByIconCount > 0  then 							
						modvalue = (i-1) % NewLineByIconCount
						divvalue = floor((i-1) / NewLineByIconCount)						
						if (modvalue) == 0 then
							--prevFrame = "EA_Main_Frame"
							eaf:SetPoint("CENTER", prevFrame, "CENTER", -xOffset*(NewLineByIconCount-1), -mathabs(xOffset))							
						else
							eaf:SetPoint("CENTER", prevFrame, "CENTER", xOffset, yOffset)
						end
					else
						eaf:SetPoint("CENTER", prevFrame, "CENTER", xOffset, yOffset)
					end
				end
				if (EA_Config.ShowName == true) then
					eaf.spellName:SetText(gsiName)
					SfontName, SfontSize = eaf.spellName:GetFont()
					eaf.spellName:SetFont(SfontName, EA_Config.SNameFontSize)
				else
					eaf.spellName:SetText("")
				end
				eaf.spellTimer:SetFont(EA_FONTS, EA_Config.TimerFontSize, "OUTLINE")
				eaf.spellStack:SetFont(EA_FONTS, EA_Config.StackFontSize, "OUTLINE")
				--增加鼠標提示
				G:FrameAppendSpellTip(eaf, spellID)
				prevFrame = eaf
								
				Lib_ZYF:FrameSetOnUpdate(eaf, G.UpdateInterval , G.OnSCDUpdate, spellID)
				
				if eaf:IsShown()==false then  eaf:Show() end
			end
		end		
		
	end
	
end
------------------------------------------------------------------
-- The command parser
------------------------------------------------------------------
function G:SlashHandler(...)

	local msg = self
	
	local F_EA = "\124cffFFFF00EventAlertMod\124r"
	local F_ON = "\124cffFF0000".."[ON]".."\124r"
	local F_OFF = "\124cff00FFFF".."[OFF]".."\124r"
	local RtnMsg = ""
	local MoreHelp = false
	
	msg = string.lower(msg)
	local cmdtype, para1 = strsplit(" ", msg)
	--local cmdtype, para1, para2 = strsplit(" ", msg)
	
	local listSec = 0
	if para1 ~= nil then
		listSec = tonumber(para1)
	end
	
	if (cmdtype == "options" or cmdtype == "opt") then
		if not EA_Options_Frame:IsVisible() then
			-- ShowUIPanel(EA_Options_Frame)
			EA_Options_Frame:Show()
		else
			-- HideUIPanel(EA_Options_Frame)
			EA_Options_Frame:Hide()
		end
	-- elseif (cmdtype == "version" or cmdtype == "ver") then
	--  DEFAULT_CHAT_FRAME:AddMessage(F_EA..EA_XCMD_VER..EA_Config.Version)
	
	elseif (cmdtype == "show") then
		EA_DEBUGFLAG11 = false
		EA_DEBUGFLAG21 = false
		EA_LISTSEC_SELF = 0
		if (EA_DEBUGFLAG1) then
			EA_DEBUGFLAG1 = false
			RtnMsg = F_EA..EA_XCMD_SELFLIST..F_OFF
		else
			EA_DEBUGFLAG1 = true
			EA_LISTSEC_SELF = listSec
			RtnMsg = F_EA..EA_XCMD_SELFLIST..F_ON
			if EA_LISTSEC_SELF > 0 then RtnMsg = RtnMsg.." ("..EA_LISTSEC_SELF.." secs)" end
			EAFun_ClearSpellScrollFrame()
			EA_Version_Frame:Show()
		end
		DEFAULT_CHAT_FRAME:AddMessage(RtnMsg)
	
	elseif (cmdtype == "showtarget" or cmdtype == "showt") then
		EA_DEBUGFLAG11 = false
		EA_DEBUGFLAG21 = false
		EA_LISTSEC_TARGET = 0
		if (EA_DEBUGFLAG2) then
			EA_DEBUGFLAG2 = false
			RtnMsg = F_EA..EA_XCMD_TARGETLIST..F_OFF
		else
			EA_DEBUGFLAG2 = true
			EA_LISTSEC_TARGET = listSec
			RtnMsg = F_EA..EA_XCMD_TARGETLIST..F_ON
			if EA_LISTSEC_TARGET > 0 then RtnMsg = RtnMsg.." ("..EA_LISTSEC_TARGET.." secs)" end
			EAFun_ClearSpellScrollFrame()
			EA_Version_Frame:Show()
		end
		DEFAULT_CHAT_FRAME:AddMessage(RtnMsg)
	
	elseif (cmdtype == "showcast" or cmdtype == "showc") then
		EA_DEBUGFLAG11 = false
		EA_DEBUGFLAG21 = false
		if (EA_DEBUGFLAG3) then
			EA_DEBUGFLAG3 = false
			RtnMsg = F_EA..EA_XCMD_CASTSPELL..F_OFF
		else
			EA_DEBUGFLAG3 = true
			RtnMsg = F_EA..EA_XCMD_CASTSPELL..F_ON
			EAFun_ClearSpellScrollFrame()
			EA_Version_Frame:Show()
		end
		DEFAULT_CHAT_FRAME:AddMessage(RtnMsg)
		
	elseif (cmdtype == "showautoadd" or cmdtype == "showa") then
		EA_DEBUGFLAG1 = false
		EA_DEBUGFLAG2 = false
		EA_DEBUGFLAG3 = false
		EA_DEBUGFLAG21 = false
		EA_LISTSEC_SELF = 60
		if (EA_DEBUGFLAG11) then
			EA_DEBUGFLAG11 = false
			RtnMsg = F_EA..EA_XCMD_AUTOADD_SELFLIST..F_OFF
		else
			EA_DEBUGFLAG11 = true
			RtnMsg = F_EA..EA_XCMD_AUTOADD_SELFLIST..F_ON
			if listSec > 0 then EA_LISTSEC_SELF = listSec end
			if EA_LISTSEC_SELF > 0 then RtnMsg = RtnMsg.." ("..EA_LISTSEC_SELF.." secs)" end
		end
		DEFAULT_CHAT_FRAME:AddMessage(RtnMsg)
		
	elseif (cmdtype == "showenvadd" or cmdtype == "showe") then
		EA_DEBUGFLAG1 = false
		EA_DEBUGFLAG2 = false
		EA_DEBUGFLAG3 = false
		EA_DEBUGFLAG11 = false
		EA_LISTSEC_SELF = 60
		if (EA_DEBUGFLAG21) then
			EA_DEBUGFLAG21 = false
			RtnMsg = F_EA..EA_XCMD_ENVADD_SELFLIST..F_OFF
		else
			EA_DEBUGFLAG21 = true
			RtnMsg = F_EA..EA_XCMD_ENVADD_SELFLIST..F_ON
			if listSec > 0 then EA_LISTSEC_SELF = listSec end
			if EA_LISTSEC_SELF > 0 then RtnMsg = RtnMsg.." ("..EA_LISTSEC_SELF.." secs)" end
		end
		DEFAULT_CHAT_FRAME:AddMessage(RtnMsg)
		
	elseif (cmdtype == "lookup") or (cmdtype == "l")then
		G:Lookup(para1, false)
	
	elseif (cmdtype == "lookupfull") or (cmdtype == "lf") then
		G:Lookup(para1, true)
		
	elseif (cmdtype == "list") then
		EA_Version_Frame_HeaderText:SetText(EA_XCMD_DEBUG_P0)
		EA_Version_ScrollFrame_EditBox:Hide()
		EA_Version_Frame:Show()
		
    elseif (cmdtype == "minimap") then
		local f = EA_MinimapOption
		if para1 and para1=="reset" then
			f:ClearAllPoints()
			f:SetPoint("TOPRIGHT",Minimap,"BOTTOMLEFT",0,0)
			EA_Config.OPTION_ICON = true
			f:Show()
		else
			print("show or hide option icon.\n(left button:show option/right button:move option icon)")
			if EA_Config.OPTION_ICON == false  then	
				print("Show option icon nearby minimap")
				EA_Config.OPTION_ICON = true
				f:Show()		
			else			
				EA_Config.OPTION_ICON = false
				f:Hide()
			end
		end
	
	elseif (cmdtype == "iconappendspelltip") then
		local msg = " Spell Tooltip on alert icon"
		if EA_Config.ICON_APPEND_SPELL_TIP == false  then	
			EA_Config.ICON_APPEND_SPELL_TIP = true				
			print("show "..msg)
		else			
			EA_Config.ICON_APPEND_SPELL_TIP = false			
			print("hide "..msg)
		end		
	elseif (cmdtype == "updateinterval") then
		print("upper the onupdate interval if you feel lag.(max 1s)")
		local para_updateinterval = tonumber(para1) or 0.01
		if para_updateinterval > 1 then para_updateinterval = 1 end		
		G.UpdateInterval = para_updateinterval 
		print("OnUpdate Event Will Occur Each "..para_updateinterval.." seconds") 
		print("WARNING! : Don't more than 1 sec ")
	elseif (cmdtype == "scdremovewhencooldown") then
		print("To remove or keep icon when spell cooldown")
		if EA_Config.SCD_RemoveWhenCooldown == true then			
			EA_Config.SCD_RemoveWhenCooldown = false
			print("EA_Config.SCD_RemoveWhenCooldown = false")			
		else
			EA_Config.SCD_RemoveWhenCooldown = true
			print("EA_Config.SCD_RemoveWhenCooldown = true")
		end
	
	elseif (cmdtype == "scdnocombatstillkeep") then
		print("Keep or hide icon when exit combat status.")
		if EA_Config.SCD_NocombatStillKeep == true then			
			EA_Config.SCD_NocombatStillKeep = false
			print("EA_Config.SCD_NocombatStillKeep = false")					
		else
			EA_Config.SCD_NocombatStillKeep = true
			print("EA_Config.SCD_NocombatStillKeep = true")
		end
	
	elseif (cmdtype == "scdglowwhenusable") then
		print("Glow CD icon when the spell can use.(not only cooldown) ")
		if EA_Config.SCD_GlowWhenUsable == true then			
			EA_Config.SCD_GlowWhenUsable = false
			print("EA_Config.SCD_GlowWhenUsable = false")					
		else
			EA_Config.SCD_GlowWhenUsable = true
			print("EA_Config.SCD_GlowWhenUsable = true")
		end
	
	elseif (cmdtype == "newlinebyiconcount") then
		print("Assign counts of icons for change new line")
		local para_count = tonumber(para1)
		if para_count then
			EA_Config.NewLineByIconCount = para_count
			print("EA_Config.NewLineByIconCount = "..para_count )					
		else
			print("Not assign count of icon for change line")
		end
		
	elseif (cmdtype == "snamefontsize") or (cmdtype == "nfs")then
		print("Set the SpellName size of FONT to show number and name ")
		local para_count = tonumber(para1)
		if para_count then
		
			EA_Config.SNameFontSize = para_count
					  
			print("EA_Config.SNameFontSize = "..para_count )					
		else
			print("Not assign font size, current size is "..para_count)
		end
		
	elseif (cmdtype == "stackfontsize") or (cmdtype == "sfs") then
		print("Set the Stack size of FONT to show number and name ")
		local para_count = tonumber(para1)
		if para_count then
			EA_Config.StackFontSize = para_count			
			print("EA_Config.StackFontSize = "..para_count )					
		else
			print("Not assign font size, current size is "..para_count)
		end
		
	elseif (cmdtype == "timerfontsize") or (cmdtype == "tfs")then
		print("Set the TIMER size of FONT to show number and name ")
		local para_count = tonumber(para1)
		if para_count then
			EA_Config.TimerFontSize = para_count
			
			print("EA_Config.TimerFontSize = "..para_count )					
		else
			print("Not assign font size, current size is "..para_count)
		end
	
	elseif (cmdtype == "showeaconfig") then
		local print = print
		local pairs = pairs
		local type  = type
		print("EA_Config:")
		for k,v in pairs(EA_Config) do
			if type(v)=="table" then
				print(k.."={")
				for k2,v2 in pairs(v) do print("   ",k2," = ",v2) end
				print("}")
			else
				print(k," = ",v)
			end
		end
	
	elseif (cmdtype == "showeaposition") then
		print("EA_Position:")
		for k,v in pairs(EA_Position) do
			if type(v)=="table" then
				print(k.."={")
				for k2,v2 in pairs(v) do print("   ",k2," = ",v2) end
				print("}")
			else
				print(k," = ",v)
			end
		end
	
	elseif (cmdtype == "showrunesbar") then		
		print("Show DK's Runs bar")
		if EA_Config.ShowRunesBar == true then			
			EA_Config.ShowRunesBar = false
			print("EA_Config.ShowRunesBar = false")	
			local eaf
			for i = 1, MAX_RUNES do				
				eaf = _G["EAFrameSpec_"..EA_SpecPower.Runes.frameindex[i]]
				if eaf:IsShown()  then eaf:Hide() end
			end
		else
			EA_Config.ShowRunesBar = true
			print("EA_Config.ShowRunesBar = true")
		end
	
	--elseif (cmdtype == "var") then			
	
	elseif (cmdtype == "print") then
		-- table.foreach(EA_ClassAltSpellName,
		-- function(i, v)
		--  if v == nil then v = "nil" end
		--  DEFAULT_CHAT_FRAME:AddMessage("["..i.."]EA_ClassAltSpellName["..i.."]="..EA_ClassAltSpellName[i].." v="..v)
		-- end
		-- )
		-- EAFun_CreateVersionFrame_ScrollEditBox()
		-- EA_Version_Frame_HeaderText:SetText("Test")
		-- EA_Version_Frame:Show()
		-- print ("go print")
		-- for  i, v in pairsByKeys(EA_Items) do
		--  print (i)
		--  --if v.enable then
		--  --  print ("enable T")
		--  --else
		--  --  print ("enable F")
		--  --end
		-- end
	
	elseif (cmdtype == "play") then
		local eaf = _G.ExecutionFrame
		eaf:SetAlpha(1)
		eaf:Show()
		eaf:SetAlpha(0.8)
		eaf:Show() 
	 
		EAEXF.FrameCount = 0
		EAEXF.Prefraction = 0	 
		EAEXF:AnimateOut(eaf)
		EAEXF.AlreadyAlert = true 	
	elseif (cmdtype == "createspellitemcache") then
	
		G:CreateSpellItemCache()
		
	else
		if cmdtype == "help" then MoreHelp = true end
		DEFAULT_CHAT_FRAME:AddMessage(F_EA..EA_XCMD_VER..EA_Config.Version)
		DEFAULT_CHAT_FRAME:AddMessage(EA_XCMD_CMDHELP.TITLE)
		DEFAULT_CHAT_FRAME:AddMessage(EA_XCMD_CMDHELP.OPT)
		DEFAULT_CHAT_FRAME:AddMessage(EA_XCMD_CMDHELP.HELP)
		for i, v in ipairs(EA_XCMD_CMDHELP["SHOW"]) do
			if i == 1 then
				if EA_DEBUGFLAG1 then v = v..EA_XCMD_SELFLIST..F_ON else v = v..EA_XCMD_SELFLIST..F_OFF end
				DEFAULT_CHAT_FRAME:AddMessage(v)
			elseif MoreHelp then
				DEFAULT_CHAT_FRAME:AddMessage(v)
			end
		end
		for i, v in ipairs(EA_XCMD_CMDHELP["SHOWT"]) do
			if i == 1 then
				if EA_DEBUGFLAG2 then v = v..EA_XCMD_TARGETLIST..F_ON else v = v..EA_XCMD_TARGETLIST..F_OFF end
				DEFAULT_CHAT_FRAME:AddMessage(v)
			elseif MoreHelp then
				DEFAULT_CHAT_FRAME:AddMessage(v)
			end
		end
		for i, v in ipairs(EA_XCMD_CMDHELP["SHOWC"]) do
			if i == 1 then
				if EA_DEBUGFLAG3 then v = v..EA_XCMD_CASTSPELL..F_ON else v = v..EA_XCMD_CASTSPELL..F_OFF end
				DEFAULT_CHAT_FRAME:AddMessage(v)
			elseif MoreHelp then
				DEFAULT_CHAT_FRAME:AddMessage(v)
			end
		end
		for i, v in ipairs(EA_XCMD_CMDHELP["SHOWA"]) do
			if i == 1 then
				if EA_DEBUGFLAG11 then v = v..EA_XCMD_AUTOADD_SELFLIST..F_ON else v = v..EA_XCMD_AUTOADD_SELFLIST..F_OFF end
				DEFAULT_CHAT_FRAME:AddMessage(v)
			elseif MoreHelp then
				DEFAULT_CHAT_FRAME:AddMessage(v)
			end
		end
		for i, v in ipairs(EA_XCMD_CMDHELP["SHOWE"]) do
			if i == 1 then
				if EA_DEBUGFLAG21 then v = v..EA_XCMD_ENVADD_SELFLIST..F_ON else v = v..EA_XCMD_ENVADD_SELFLIST..F_OFF end
				DEFAULT_CHAT_FRAME:AddMessage(v)
			elseif MoreHelp then
				DEFAULT_CHAT_FRAME:AddMessage(v)
			end
		end
		for i, v in ipairs(EA_XCMD_CMDHELP["LIST"]) do
			if i == 1 then
				DEFAULT_CHAT_FRAME:AddMessage(v)
			elseif MoreHelp then
				DEFAULT_CHAT_FRAME:AddMessage(v)
			end
		end
		for i, v in ipairs(EA_XCMD_CMDHELP["LOOKUP"]) do
			if i == 1 then
				DEFAULT_CHAT_FRAME:AddMessage(v)
			elseif MoreHelp then
				DEFAULT_CHAT_FRAME:AddMessage(v)
			end
		end
		for i, v in ipairs(EA_XCMD_CMDHELP["LOOKUPFULL"]) do
			if i == 1 then
				DEFAULT_CHAT_FRAME:AddMessage(v)
			elseif MoreHelp then
				DEFAULT_CHAT_FRAME:AddMessage(v)
			end
		end
	end
end
--[[------------------------------------------------------------------
-- The URLs of update
--------------------------------------------------------------------]]
function G:ShowVerURL(SiteIndex)
	local VerUrl = ""
	VerUrl = EA_XOPT_VERURL1
	if SiteIndex ~= 1 then
		VerUrl = "http://forum.gamer.com.tw/Co.php?bsn=05219&sn=5125122&subbsn=0"
	end
	DEFAULT_CHAT_FRAME:AddMessage(VerUrl)
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function EAFun_CreateVersionFrame_ScrollEditBox()
	local framewidth = EA_Version_Frame:GetWidth() - 45
	local frameheight = EA_Version_Frame:GetHeight() - 70
	local panel3 = _G["EA_Version_ScrollFrame"]
	if panel3 == nil then
		panel3 = CreateFrame("ScrollFrame", "EA_Version_ScrollFrame", EA_Version_Frame, "UIPanelScrollFrameTemplate")
	end
	local scc = _G["EA_Version_ScrollFrame_List"]
	if scc == nil then
		scc = CreateFrame("Frame", "EA_Version_ScrollFrame_List", panel3)
		panel3:SetScrollChild(scc)
		panel3:SetPoint("TOPLEFT", EA_Version_Frame, "TOPLEFT", 15, -30)
		scc:SetPoint("TOPLEFT", panel3, "TOPLEFT", 0, 0)
		panel3:SetWidth(framewidth)
		panel3:SetHeight(frameheight)
		scc:SetWidth(framewidth)
		scc:SetHeight(frameheight)
		--for WOW9.0-----------------------------------------------------------
		Lib_ZYF:SetBackdrop(EA_Version_Frame, {	bgFile="Interface/DialogFrame/UI-DialogBox-Gold-Background", 
												edgeFile="", 
												tile = false, 	
												tileSize = 1, 
												edgeSize = 1, 
												insets = { left = 0, right = 0, top = 0, bottom = 0, },
											  })		
		-------------------------------------------------------------
		panel3:SetScript("OnVerticalScroll", function()  end)
		panel3:EnableMouse(true)
		panel3:SetVerticalScroll(0)
		panel3:SetHorizontalScroll(0)
	end
	local etb1 = _G["EA_Version_ScrollFrame_EditBox"]
	if etb1 == nil then
		etb1 = CreateFrame("EditBox", "EA_Version_ScrollFrame_EditBox", scc)
		etb1:SetPoint("TOPLEFT",0,0)
		etb1:SetFontObject(EA_FONT_OBJECT)
		etb1:SetWidth(framewidth)
		etb1:SetHeight(frameheight)
		etb1:SetMultiLine()
		etb1:SetMaxLetters(0)
		etb1:SetAutoFocus(false)
	end
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
local function EAFun_ExtendExecution_4505(EAItems)
	for index1, value1 in pairsByKeys(EAItems) do
		if EAItems[index1] ~= nil then EAItems[index1].Execution = 0 end
	end
	return EAItems
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
local function EAFun_ChangeSavedVariblesFormat_4505(EAItems, EASelf)
	if EAItems == nil then EAItems = { } end
	for index1, value1 in pairsByKeys(EAItems) do
		for index2, value2 in pairsByKeys(EAItems[index1]) do
			if (EASelf) then
				EAItems[index1][index2] = {enable=value2, self=true,}
			else
				EAItems[index1][index2] = {enable=value2,}
			end
		end
	end
	return EAItems
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function G:VersionCheck()
	local EA_TocVersion = GetAddOnMetadata("EventAlertMod", "Version")
	-- local F_EA = "\124cffFFFF00EventAlertMod\124r"
	EAFun_CreateVersionFrame_ScrollEditBox()
	EA_Version_Frame_Okay:SetText(EA_XOPT_OKAY)
	if (EA_Config.Version ~= EA_TocVersion and EA_Config.Version ~= nil) then
		if (EA_Config.Version < "4.5.01" and EA_TocVersion < "4.5.04") then
			-- Ver 4.5.01 is For WOW 4.0.1+
			-- Many WOW 3.x spells are canceled or integrated,
			-- so the saved-spells should be clear, and to load the new spells.
			EA_Items = { }
			EA_AltItems = { }
			EA_TarItems = { }
			EA_ScdItems = { }
			EA_GrpItems = { }
		end
		if (EA_Config.Version < "4.5.05" and EA_TocVersion <= "4.7.02") then
			-- EventAlert SpellArray Format Change, from true/false values to parameters values
			-- so, it should formate old parameters to new
			EA_Pos = EAFun_ExtendExecution_4505(EA_Pos)
			EA_Items = EAFun_ChangeSavedVariblesFormat_4505(EA_Items, false)
			EA_AltItems = EAFun_ChangeSavedVariblesFormat_4505(EA_AltItems, false)
			EA_TarItems = EAFun_ChangeSavedVariblesFormat_4505(EA_TarItems, true)
			EA_ScdItems = EAFun_ChangeSavedVariblesFormat_4505(EA_ScdItems, false)
			EA_GrpItems = { }
		end
		EA_Config.Version = EA_TocVersion
		-- if (EA_XLOAD_NEWVERSION_LOAD ~= "") then
		-- 	EA_Version_ScrollFrame_EditBox:SetText(F_EA..EA_XCMD_VER..EA_Config.Version.."\n\n\n"..EA_XLOAD_NEWVERSION_LOAD)
		-- 	EA_Version_Frame:Show()
		-- end
		G:LoadClassSpellArray(9)
	elseif (EA_Config.Version == nil) then
		EA_Items = { }
		EA_AltItems = { }
		EA_TarItems = { }
		EA_ScdItems = { }
		EA_GrpItems = { }
		EA_Config.Version = EA_TocVersion
		-- if (EA_XLOAD_FIRST_LOAD ~= "") then
		-- 	EA_Version_ScrollFrame_EditBox:SetText(F_EA..EA_XCMD_VER..EA_Config.Version.."\n\n\n"..EA_XLOAD_FIRST_LOAD..EA_XLOAD_NEWVERSION_LOAD)
		-- 	EA_Version_Frame:Show()
		-- end
		G:LoadClassSpellArray(9)
	elseif (EAFun_GetCountOfTable(EA_Items[EA_playerClass]) <= 0) then
		G:LoadClassSpellArray(9)
	end
	if EA_Items[EA_playerClass] == nil then EA_Items[EA_playerClass] = {} end
	if EA_AltItems[EA_playerClass] == nil then EA_AltItems[EA_playerClass] = {} end
	if EA_Items[EA_CLASS_OTHER] == nil then EA_Items[EA_CLASS_OTHER] = {} end
	if EA_TarItems[EA_playerClass] == nil then EA_TarItems[EA_playerClass] = {} end
	if EA_ScdItems[EA_playerClass] == nil then EA_ScdItems[EA_playerClass] = {} end
	if EA_GrpItems[EA_playerClass] == nil then EA_GrpItems[EA_playerClass] = {} end
	-- G:LoadClassSpellArray(6)
	-- After confirm the version, set the VersionText in the EA_Options_Frame.
	EA_Options_Frame_VersionText:SetText("Ver:\124cffFFFFFF"..EA_Config.Version.."\124r")
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function insertBuffValue(tab, value)
	local isExist = false
	for pos, name in ipairs(tab) do
		if (name == value) then
			isExist = true
		end
	end
	if not isExist then tinsert(tab, value) end
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function G:removeBuffValue(tab, value)
	local tremove = table.remove
	for pos, name in ipairs(tab) do
		if (name == value) then
			tremove(tab, pos)
		end
	end
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function pairsByKeys (t, f)
	local a = {}
	local tinsert = table.insert
	local tsort = table.sort
	for n in pairs(t) do tinsert(a, n) end
	tsort(a, f)
	local i = 0 -- iterator variable
	local iter = function () -- iterator function
		i = i + 1
		if a[i] == nil then
			return nil
		else
			return a[i], t[a[i]]
		end
	end
	return iter
end
--[[------------------------------------------------------------------
--------------------------------------------------------------------]]
function EAFun_GetFormattedTime(timeLeft)
	local formattedTime = ""
	if timeLeft <= 60 then
		if (timeLeft <= EA_Config.UseFloatSec and timeLeft~=floor(timeLeft)) then
			formattedTime = tostring(format("%.1f",timeLeft))
		else
			--formattedTime = tostring(floor(timeLeft))
			formattedTime = tostring(format("%d",timeLeft))
		end
	elseif timeLeft <= 3600 then
		formattedTime = format("%d:%02d", floor(timeLeft/60), timeLeft % 60)
	else
		formattedTime = format("%2d:%2d:%02d", floor(timeLeft/3600),floor((timeLeft % 3600)/60), timeLeft % 3600)
	end
	return formattedTime
end
--------------------------------
function MyPrint(info)
	DEFAULT_CHAT_FRAME:AddMessage(info)
end
--------------------------------
function EAFun_SetCountdownStackText(eaf, EA_timeLeft, EA_count, SC_RedSecText)

	local formatTimeLeft = EAFun_GetFormattedTime(EA_timeLeft)
		
	if ((SC_RedSecText == nil) or (SC_RedSecText <= 0)) then SC_RedSecText = -1 end
	if (EA_Config.ShowTimer == true) then
		eaf.spellTimer:Show()
	else
		eaf.spellTimer:Hide()
	end
	if (eaf.useCooldown == true) then
		local eaf_cooldown = eaf.cooldown
		local eaf_cooldown_text = eaf_cooldown:GetRegions()
		if _G.OmniCC then
			--eaf_cooldown:Hide()			
			--eaf_cooldown:SetCooldown(0,0)
		end
		eaf.spellTimer:ClearAllPoints()			
		if (EA_Config.ChangeTimer == true) then					
			eaf.spellTimer:SetPoint("CENTER", eaf, "CENTER", 0, 0)
		else	
			eaf.spellTimer:SetPoint("BOTTOM", eaf, "TOP" ,0, 0)
		end						
	else
		eaf.spellTimer:ClearAllPoints()	
		if (EA_Config.ChangeTimer == true) then			
			eaf.spellTimer:SetPoint("CENTER", eaf, "CENTER", 0, 0)
		else	
			eaf.spellTimer:SetPoint("BOTTOM", eaf, "TOP" ,0, 0)
		end	
	end
	if (EA_timeLeft > 0) then
		if (EA_timeLeft < SC_RedSecText + 1) then
			if (not eaf.redsectext) then				
				eaf.spellTimer:SetFont(EA_FONTS, 1*(EA_Config.TimerFontSize + 5), "OUTLINE")
				--eaf.spellTimer:SetFont(EA_FONTS, (EA_Config.TimerFontSize*1.5), "OUTLINE")
				eaf.spellTimer:SetTextColor(1, 0, 0)
				eaf.redsectext = true
				eaf.whitesectext = false
			end
		else
			if (not eaf.whitesectext) then				
				--eaf.spellTimer:SetFont(EA_FONTS, 1*EA_Config.TimerFontSize, "OUTLINE")
				eaf.spellTimer:SetFont(EA_FONTS,EA_Config.TimerFontSize, "OUTLINE")				
				--eaf.spellTimer:SetTextColor(1, 1, 0)			--設定計時數字顏色為黃色
				eaf.spellTimer:SetTextColor(1, 1, 1)			--設定計時數字顏色為白色
				eaf.spellTimer:SetShadowColor(0, 0, 0)		    --設定計時數字陰影為黑色
				eaf.spellTimer:SetShadowOffset(2, -2)		    --設定計時數字陰影偏移量(右移2下移2)
				eaf.redsectext = false
				eaf.whitesectext = true
			end
		end		
		if (eaf.spellTimer:GetText() ~= formatTimeLeft) then 
			eaf.spellTimer:SetText(formatTimeLeft)
		end
	else
		eaf.spellTimer:SetText("")
	end
	eaf.spellStack:ClearAllPoints()
	--if (EA_count > 0) then
	if (EA_count and EA_count > 1) then
		if EA_Config.ChangeTimer==true then
			--數字右下角對齊圖示右下角(框內)
			eaf.spellStack:SetPoint("BOTTOMRIGHT", eaf, "BOTTOMRIGHT", -eaf:GetWidth() * 0.07 , eaf:GetHeight() * 0.09)
		else
			--數字右下角對齊圖示右下角(框內)
			eaf.spellStack:SetPoint("BOTTOMRIGHT", eaf, "BOTTOMRIGHT", -eaf:GetWidth() * 0.1 , eaf:GetHeight() * 0.1)
			--數字左下角對齊圖示右下角(框外)
			-- eaf.spellStack:SetPoint("BOTTOMRIGHT", eaf, "BOTTOMRIGHT", 0, 0)
		end
		--eaf.spellStack:SetTextColor(1, 1, 1)			--設定堆疊數字顏色為白色
		eaf.spellStack:SetTextColor(1, 1, 0)			--設定堆疊數字顏色為黃色
		eaf.spellStack:SetShadowColor(0, 0, 0)			--設定堆疊數字陰影為黑色
		eaf.spellStack:SetShadowOffset(2, -2)			--設定堆疊數字陰影偏移量(右移2下移2)
		eaf.spellStack:SetFont(EA_FONTS, EA_Config.StackFontSize, "OUTLINE")		
		eaf.spellStack:SetFormattedText("%d", EA_count)
	else
		eaf.spellStack:SetFormattedText("")
	end
end
-----------------------------------------------------------------
-- Speciall Frame: UpdateComboPoint, for watching the combopoint of player
function G:UpdateComboPoints()	

	if EA_flagAllHidden == true then 
		EA_Main_Frame:SetAlpha(0) 
		return 
	else
		EA_Main_Frame:SetAlpha(1) 
	end
	--EA_COMBO_POINTS = UnitPower("player",EA_SPELL_POWER_COMBO_POINT)
	EA_COMBO_POINTS = UnitPower("player",Enum.PowerType.ComboPoints)
	local iComboPoint = EA_COMBO_POINTS
	if (EA_Config.ShowFrame == true) then
		EA_Main_Frame:ClearAllPoints()
		EA_Main_Frame:SetPoint(EA_Position.Anchor, UIParent, EA_Position.relativePoint, EA_Position.xLoc, EA_Position.yLoc)
		local prevFrame = "EA_Main_Frame"
		local xOffset = 100 + EA_Position.xOffset
		local yOffset = 0 + EA_Position.yOffset
		local SfontName, SfontSize = "", 0
		local eaf = _G["EAFrameSpec_"..(EA_SpecPower.ComboPoints.frameindex[1])]
		if (eaf ~= nil) then
			if (iComboPoint > 0) then
				EA_SpecFrame_Target = true
				eaf:ClearAllPoints()
				--eaf:SetPoint(EA_Position.TarAnchor, UIParent, EA_Position.TarAnchor, EA_Position.Tar_xOffset - xOffset * 1, EA_Position.Tar_yOffset - yOffset)
				if (EA_SpecPower.LunarPower.has and EA_Config.SpecPowerCheck.LunarPower) then
					eaf:SetPoint(EA_Position.Anchor, prevFrame, EA_Position.Anchor, -4 * xOffset,  0 * yOffset)
				else
					eaf:SetPoint(EA_Position.Anchor, prevFrame, EA_Position.Anchor, -1 * xOffset,  0 * yOffset)
				end
				if (EA_Config.ShowName) then
					eaf.spellName:SetText(EA_SPELL_POWER_NAME.ComboPoints)
					--eaf.spellName:SetText(EA_XSPECINFO_COMBOPOINT)
					SfontName, SfontSize = eaf.spellName:GetFont()
					eaf.spellName:SetFont(SfontName, EA_Config.SNameFontSize)
				else
					eaf.spellName:SetText("")
				end
				--EAFun_SetCountdownStackText(eaf, iComboPoint, 0, -1)
				EAFun_SetCountdownStackText(eaf, iComboPoint, 0, -1)
				eaf:Show()
				-- for 7.0 依據盜賊天賦決定連擊點高亮值
				local ComboPointMax = UnitPowerMax("player",Enum.PowerType.ComboPoints)				
				local GlowComboPoint = ComboPointMax 				
				--G:FrameGlowShowOrHide(eaf,(iComboPoint >= GlowComboPoint))
				G:FrameGlowShowOrHide(eaf,(iComboPoint >= GlowComboPoint))
			else
				G:FrameGlowShowOrHide(eaf, false)
				EA_SpecFrame_Target = false
				eaf:Hide()
			end
			-- G:TarPositionFrames()
		end
	end
end
function G:UpdateFocus()
	local iPowerType = Enum.PowerType.Focus
	local iUnitPower = UnitPower("player", iPowerType)
	local iPetPower = UnitPower("pet", iPowerType)
	if (EA_Config.ShowFrame == true) then
		EA_Main_Frame:ClearAllPoints()
		EA_Main_Frame:SetPoint(EA_Position.Anchor, UIParent, EA_Position.relativePoint, EA_Position.xLoc, EA_Position.yLoc)
		local prevFrame = "EA_Main_Frame"
		local xOffset = 100 + EA_Position.xOffset
		local yOffset = 0 + EA_Position.yOffset
		local SfontName, SfontSize = "", 0
		--local eaf1 = _G["EAFrameSpec_1000020"]
		--local eaf2 = _G["EAFrameSpec_1000021"]
		local eaf1 = _G["EAFrameSpec_"..EA_SpecPower.Focus.frameindex[1]]
		local eaf2 = _G["EAFrameSpec_"..EA_SpecPower.Focus.frameindex[2]]
			EA_SpecFrame_Self = true
			if (eaf1 ~= nil) and (EA_Config.SpecPowerCheck.Focus) and (iUnitPower > 0) then
				eaf1:ClearAllPoints()
				eaf1:SetPoint(EA_Position.Anchor, prevFrame, EA_Position.Anchor, -1 * xOffset, -1 * yOffset)
				if (EA_Config.ShowName == true) then
					eaf1.spellName:SetText(EA_SPELL_POWER_NAME.Focus)
					SfontName, SfontSize = eaf1.spellName:GetFont()
					eaf1.spellName:SetFont(SfontName, EA_Config.SNameFontSize)
				else
					eaf1.spellName:SetText("")
				end
				eaf1.spellTimer:ClearAllPoints()
				if (EA_Config.ChangeTimer == true) then
					eaf1.spellTimer:SetPoint("CENTER", eaf2,"CENTER", 0, 0)
				else
					eaf1.spellTimer:SetPoint("BOTTOM",eaf2, "TOP", 0, 0)
				end
				eaf1.spellTimer:SetFont(EA_FONTS, EA_Config.TimerFontSize, "OUTLINE")
				eaf1.spellTimer:SetText(iUnitPower)		
				eaf1:Show()
			else
				if eaf1 then
					G:FrameGlowShowOrHide(eaf1, false)
					EA_SpecFrame_Self = false					
					eaf1:Hide()
				end
			end		
			if (eaf2 ~= nil) and (EA_Config.SpecPowerCheck.FocusPet) and (iPetPower > 0) then
				eaf2:ClearAllPoints()
				eaf2:SetPoint(EA_Position.Anchor, prevFrame, EA_Position.Anchor, -2 * xOffset, -1 * yOffset)
				if (EA_Config.ShowName == true) then
					eaf2.spellName:SetText(EA_SPELL_POWER_NAME.FocusPet)
					SfontName, SfontSize = eaf2.spellName:GetFont()
					eaf2.spellName:SetFont(SfontName, EA_Config.SNameFontSize)
				else
					eaf2.spellName:SetText("")
				end
				eaf2.spellTimer:ClearAllPoints()
				if (EA_Config.ChangeTimer == true) then
					eaf2.spellTimer:SetPoint("CENTER", eaf2,"CENTER", 0, 0)
				else
					eaf2.spellTimer:SetPoint("BOTTOM",eaf2, "TOP", 0, 0)
				end
				eaf2.spellTimer:SetFont(EA_FONTS, EA_Config.TimerFontSize, "OUTLINE")
				eaf2.spellTimer:SetText(iPetPower)	
				G:FrameGlowShowOrHide(eaf2, iPetPower >= EA_Config.HUNTER_GlowPetFocus)
				eaf2:Show()				
			else
				if eaf2 then
					G:FrameGlowShowOrHide(eaf2, false)
					EA_SpecFrame_Self = false					
					eaf2:Hide()
				end
			end							
	end
end
-- Speciall Frame: Update Runes
function G:UpdateRunes()		
	
	if (EA_playerClass ~= EA_CLASS_DK) then return end
	if not(EA_Config.SpecPowerCheck.Runes) then return end
	if not(EA_SpecPower.Runes.has) then return end
	
	G:UpdateSinglePower(Enum.PowerType.Runes)
	
	if EA_Config.ShowRunesBar == false then return end
	if (EA_Config.ShowFrame == true) then
		EA_Main_Frame:ClearAllPoints()
		EA_Main_Frame:SetPoint(EA_Position.Anchor, UIParent, EA_Position.relativePoint, EA_Position.xLoc, EA_Position.yLoc)
		local prevFrame = "EA_Main_Frame"
		local xOffset = 100 + EA_Position.xOffset
		local yOffset =  EA_Position.yOffset
		local SfontName, SfontSize = "", 0
		local eaf={}
		EA_SpecFrame_Self = true
		local RunesFrame = EA_SpecPower.Runes.frameindex
		local IconSize = EA_Config.IconSize
		local TimerFontSize = EA_Config.TimerFontSize
		local GetRuneCooldown = GetRuneCooldown
		local GetTime = GetTime
		for i = 1, MAX_RUNES do
		
			eaf[i]=_G["EAFrameSpec_"..RunesFrame[i]]
			if not(eaf[i]) then
				CreateFrames_SpecialFrames_Show(RunesFrame[i])
				eaf[i] = _G["EAFrameSpec_"..RunesFrame[i]]
			end
			if eaf[i] then
				eaf[i]:SetWidth(IconSize * 0.8)
				eaf[i]:SetHeight(IconSize * 0.8)
				if (eaf[i]:IsShown() == false)  then							
					eaf[i]:Show()
				end			
			end	
			--slot=RUNE_MAPPING[i]
			slot = i
			--iRuneType = tonumber(GetRuneType(slot))
			iRuneType = EA_RUNE_TYPE
			if (iRuneType >= 1) and (iRuneType < 4 ) then
				--eaf[i]:SetPoint(EA_Position.Anchor, prevFrame, EA_Position.Anchor, (i-MAX_RUNES-3) * xOffset * 0.6, (i-MAX_RUNES-3) * yOffset*0.6)
				eaf[i]:SetPoint(EA_Position.Anchor, prevFrame, EA_Position.Anchor, (IconSize+(i-2) * -xOffset*0.6), 1*(IconSize+(i-2) * yOffset*0.6))
				--if eaf[i].Backdrop == nil then 
					--Lib_ZYF:SetBackdrop(eaf[i],{bgFile=iconTextures[iRuneType]})
				--end
				eaf[i].texture:SetTexture(1630812)
				local coord
				if GetSpecialization then
					coord = runeSetTexCoord[GetSpecialization()]
				else
					iRuneType = tonumber(GetRuneType(slot))
					coord = runeSetTexCoord[iRuneType]
				end
				eaf[i].texture:SetTexCoord(coord.minX, coord.maxX, coord.minY, coord.maxY)	
				if (EA_Config.ShowName==true) then					
					--eaf[i].spellName:SetText(runeTypeText[iRuneType])
					--SfontName, SfontSize = eaf[i].spellName:GetFont()
					--eaf[i].spellName:SetFont(SfontName, EA_Config.SNameFontSize*0.8)
				else
					eaf[i].spellName:SetText("")
				end			
				eaf[i].spellTimer:ClearAllPoints()
				
				if (EA_Config.ChangeTimer == true) then
					eaf[i].spellTimer:SetPoint("CENTER", eaf[i], "CENTER", 0, 0)
					eaf[i].spellTimer:SetFont(EA_FONTS, 0.8*EA_Config.TimerFontSize, "OUTLINE")
				else
					eaf[i].spellTimer:SetPoint("BOTTOM", eaf[i], "TOP", 0, 0)
					eaf[i].spellTimer:SetFont(EA_FONTS, 0.9*EA_Config.TimerFontSize, "OUTLINE")
				end
				
				local EA_start, EA_duration, runeReady = GetRuneCooldown(i)
				local EA_timeLeft
				if not(EA_start) then return end
				--if not(EA_start) then break end
				if (runeReady) then
					EA_timeLeft = 0
				else
					EA_timeLeft = EA_start + EA_duration - GetTime()	
				end
				if (EA_timeLeft > EA_duration) then EA_timeLeft = EA_duration end
				--if (start>0) then
				if (EA_timeLeft > 0) then					
					EAFun_SetCountdownStackText(eaf[i],EA_timeLeft,0,-1)
				else
					EAFun_SetCountdownStackText(eaf[i],0,0,-1)
				end			
				--[[
				if not(eaf[i]:HasScript("OnUpdate")) then 
					eaf[i]:SetScript("OnUpdate", function(self,elapsedTime)
					G:TimeSinceUpdate_Runes = G:TimeSinceUpdate_Runes + elapsedTime
					if G:TimeSinceUpdate_Runes > G:UpdateInterval then
						G:UpdateRunes()
						G:TimeSinceUpdate_Runes = 0
					end
					end)
					--eaf[i]:SetScript("OnUpdate",G:UpdateRunes)
				end	
				]]--
				if eaf[i] and (eaf[i]:IsShown()==false) then
					eaf[i]:Show()
				end
				--G:PositionFrames()
			end
			--若脫戰則隱藏符文框架
			if UnitAffectingCombat("player") == false then	
				--eaf[i]:Hide()
			else
				eaf[i]:Show()
			end		
		end
	end	
end
-----------------------------------------------------------------
-- Speciall Frame: UpdateSinglePower(holy power, runic power, soul shards), for watching the power of player
function G:UpdateSinglePower(iPowerType)

	if iPowerType == nil then return end
	
	if EA_flagAllHidden == true then 
		EA_Main_Frame:SetAlpha(0) 
		return 
	else
		EA_Main_Frame:SetAlpha(1) 
	end
	
	
	
	local unit = "player"
	local _, playerClass = UnitClass(unit)
	local iUnitPower = UnitPower(unit, iPowerType)	
	--local iUnitPowerPet = UnitPower("pet", iPowerType)	
	local iPowerName = ""
	local iFrameIndex = 1000000 + iPowerType * 10	
	for i,v in ipairs(EA_XGRPALERT_POWERTYPES) do
		if iPowerType == v.value then
			iPowerName = v.text
			if GetSpecialization and iPowerType == Enum.PowerType.Runes then				
				local powerName = select(2, GetSpecializationInfo(GetSpecialization()))
				iPowerName = (powerName or "")..iPowerName
			end
			break			
		end
	end
	
	if (EA_Config.ShowFrame == true) then
		EA_Main_Frame:ClearAllPoints()
		EA_Main_Frame:SetPoint(EA_Position.Anchor, UIParent, EA_Position.relativePoint, EA_Position.xLoc, EA_Position.yLoc)
		local prevFrame = "EA_Main_Frame"
		--local xOffset = 100 + EA_Position.xOffset
		local xOffset = 100 + EA_Position.xOffset
		local yOffset = 0 + EA_Position.yOffset
		local SfontName, SfontSize = "", 0
		local eaf = _G["EAFrameSpec_"..iFrameIndex]	
		if (eaf ~= nil) then
			
			--術士靈魂碎片數量處理
			if (iPowerType == Enum.PowerType.SoulShards) then						
				iUnitPower=UnitPower(unit, Enum.PowerType.SoulShards, true)/10
			end
			
			--DK符文數量處理
			if (iPowerType == Enum.PowerType.Runes) then
				iUnitPower = 0 
				for i = 1, MAX_RUNES do
					local start, duration, runeReady = GetRuneCooldown(i)					
					if runeReady then iUnitPower = iUnitPower + 1 end
				end
			end
			
			if (iUnitPower > 0) then
				EA_SpecFrame_Self = true
				--eaf:ClearAllPoints()
				
				--能量框架位置設定
				if (iPowerType == Enum.PowerType.Energy) then		
					if (EA_playerClass == EA_CLASS_ROGUE) then
						eaf:SetPoint(EA_Position.Anchor, prevFrame, EA_Position.Anchor, -2 * xOffset, -2 * yOffset)																						
					else
						eaf:SetPoint(EA_Position.Anchor, prevFrame, EA_Position.Anchor, -2 * xOffset, -2 * yOffset)																						
					end
				else
					eaf:SetPoint(EA_Position.Anchor, prevFrame, EA_Position.Anchor, -1   * xOffset, -1 * yOffset)
					if (EA_SpecPower.Energy.has and EA_Config.SpecPowerCheck.Energy) then
						iFrameIndex2 = 1000000 + 10 * Enum.PowerType.Energy 
						eaf2 = _G["EAFrameSpec_"..iFrameIndex2]
						eaf2:SetPoint(EA_Position.Anchor, prevFrame, EA_Position.Anchor, -2 * xOffset, -2 * yOffset)
					end
				end
				
				--星能框架位置設定
				if (iPowerType == Enum.PowerType.LunarPower) then
					eaf:SetPoint(EA_Position.Anchor, prevFrame, EA_Position.Anchor, -1 * xOffset, -1 * yOffset)																						
				end
				if (EA_Config.ShowName == true) then
					eaf.spellName:SetText(iPowerName)
					SfontName, SfontSize = eaf.spellName:GetFont()
					eaf.spellName:SetFont(SfontName, EA_Config.SNameFontSize)
				else
					eaf.spellName:SetText("")
				end
				
				--符文框架位置設定
				if (iPowerType == Enum.PowerType.Runes ) then
					local coord
					if GetSpecialization then
						coord = runeSetTexCoord[GetSpecialization()]						
					else
						coord = runeSetTexCoord[GetShapeshiftForm()]												
					end
					if coord then
						eaf.texture:SetTexCoord(coord.minX, coord.maxX, coord.minY, coord.maxY)	
					
						eaf:SetPoint(EA_Position.Anchor, prevFrame, EA_Position.Anchor, -2 * xOffset, -2 * yOffset)	
					end
				end	
				
				--龍能框架位置設定
				if (iPowerType == Enum.PowerType.Essence ) then
					eaf:SetPoint(EA_Position.Anchor, prevFrame, EA_Position.Anchor, -2 * xOffset, -2 * yOffset)						
				end	
				
				--法力增加百分比顯示  					
				local ManaScale = 1
				if (EA_Config.ShowName == true) then
					
					if (iPowerType == Enum.PowerType.Mana) then
						-- iPowerName = format("%s\n(%d%%)",iPowerName,iUnitPower/UnitPowerMax(unit,Enum.PowerType.Mana)*100)						
						eaf.spellName:SetFormattedText("%s\n(%d%%)",iPowerName,iUnitPower/UnitPowerMax(unit,Enum.PowerType.Mana)*100)						
						ManaScale = 0.8								
					else                    					
						eaf.spellName:SetText(iPowerName)												
					end			
					
					SfontName, SfontSize = eaf.spellName:GetFont()
					eaf.spellName:SetFont(SfontName, EA_Config.SNameFontSize)
				else
					eaf.spellName:SetText("")
				end
				
				eaf.spellTimer:ClearAllPoints()
				if (EA_Config.ChangeTimer == true) then
					eaf.spellTimer:SetPoint("CENTER", eaf,"CENTER", 0, 0)
				else
					eaf.spellTimer:SetPoint("BOTTOM",eaf, "TOP", 0, 0)
				end
				
				
				eaf.spellTimer:SetFont(EA_FONTS, EA_Config.TimerFontSize * ManaScale, "OUTLINE")
				
				--若能量值超過10000就轉為K數顯示
				if iUnitPower > 10000 then 
					eaf.spellTimer:SetFormattedText("%dK",iUnitPower/1000)
					-- eaf.spellTimer:SetText(format("%dK",iUnitPower/1000))
				else
					eaf.spellTimer:SetText(iUnitPower)
				end
				eaf:Show()
				
				-- 能量達到指定高亮				
				if (iPowerType == Enum.PowerType.Energy) then
					
					--德魯伊兇猛撕咬50能量傷害最大化
					if playerClass == EA_CLASS_DRUID then 
						G:FrameGlowShowOrHide(eaf, (iUnitPower >= 50 ))
					end
					if playerClass == EA_CLASS_ROGUE then 
						G:FrameGlowShowOrHide(eaf, (iUnitPower >= 50 ))
					end
					
					if playerClass == EA_CLASS_MONK then 
						G:FrameGlowShowOrHide(eaf, (iUnitPower >= 50 ))
					end
				end
				
				-- 怒氣達到上限高亮				
				if (iPowerType == Enum.PowerType.Rage) then
					--若為戰士
					if (playerClass == EA_CLASS_WARRIOR) then						
						--若專精為狂怒表示有暴怒技能,80需求值高亮
						if GetSpecialization and (GetSpecialization() == 2) then														
							G:FrameGlowShowOrHide(eaf, (iUnitPower >= 80 ))							
						end
						--若為武器專精則以斬殺最高需求值40高亮
						if GetSpecialization and  (GetSpecialization() == 1) then
							--G:FrameGlowShowOrHide(eaf, (iUnitPower >= UnitPowerMax(unit, Enum.PowerType.Rage)))
							G:FrameGlowShowOrHide(eaf, (iUnitPower >= 40))
						end
						--若為防護專精則以無視苦痛需求值40高亮
						if GetSpecialization and  (GetSpecialization() == 3) then
							--G:FrameGlowShowOrHide(eaf, (iUnitPower >=UnitPowerMax(unit, Enum.PowerType.Rage)))					
							G:FrameGlowShowOrHide(eaf, (iUnitPower >= 40 ))					
						end						
					else
						G:FrameGlowShowOrHide(eaf, (iUnitPower >=UnitPowerMax(unit, Enum.PowerType.Rage)))
					end					
					if (playerClass == EA_CLASS_DRUID) then
						eaf:SetPoint(EA_Position.Anchor, prevFrame, EA_Position.Anchor, -3 * xOffset, -3 * yOffset)	
					end
				end
				
				-- 法力達到上限高亮
				if (iPowerType == Enum.PowerType.Mana) then					
					G:FrameGlowShowOrHide(eaf, (iUnitPower >= UnitPowerMax(unit, Enum.PowerType.Mana)))					
				end
				
				-- 聖騎聖能達到上限高亮
				if (iPowerType == Enum.PowerType.HolyPower) then
					G:FrameGlowShowOrHide(eaf, (iUnitPower >= UnitPowerMax(unit, Enum.PowerType.HolyPower)))					
				end
				
				-- 暗牧瘋狂值達到瘟疫50需求值高亮
				if (iPowerType == Enum.PowerType.Insanity) then														
					--G:FrameGlowShowOrHide(eaf,(iUnitPower >= UnitPowerMax(unit,Enum.PowerType.Insanity)))
					G:FrameGlowShowOrHide(eaf,(iUnitPower >= 50))					
				end
				
				--武僧真氣滿上限高亮				
				if (iPowerType == Enum.PowerType.Chi) then					
					G:FrameGlowShowOrHide(eaf,(iUnitPower >= UnitPowerMax(unit, Enum.PowerType.Chi)))				
					--G:FrameGlowShowOrHide(eaf,(iUnitPower >= 4))				
				end
				
				--死騎符能達到上限高亮
				if (iPowerType == Enum.PowerType.RunicPower) then					
					G:FrameGlowShowOrHide(eaf,(iUnitPower >= UnitPowerMax(unit, Enum.PowerType.RunicPower)))				
				end
				
				--死騎符文達到上限高亮
				if (iPowerType == Enum.PowerType.Runes) then					
					G:FrameGlowShowOrHide(eaf,(iUnitPower >= MAX_RUNES))				
				end
				
				--術士靈魂碎片達到上限高亮
				if (iPowerType == Enum.PowerType.SoulShards) then						
					G:FrameGlowShowOrHide(eaf,(iUnitPower >= UnitPowerMax(unit, Enum.PowerType.SoulShards)))
				end
				
				--秘法充能達到上限高亮
				if (iPowerType == Enum.PowerType.ArcaneCharges) then					
					G:FrameGlowShowOrHide(eaf,(iUnitPower >= UnitPowerMax(unit, Enum.PowerType.ArcaneCharges)))				
				end
				
				--星能達到星隕術需求就高亮
				if (iPowerType == Enum.PowerType.LunarPower) then
					G:FrameGlowShowOrHide(eaf,(iUnitPower >= 50))
					--G:FrameGlowShowOrHide(eaf,(iUnitPower >=UnitPowerMax(unit, Enum.PowerType.LunarPower)))				
				end
				
				--增強薩、元素薩元能達到上限高亮
				if (iPowerType == Enum.PowerType.Maelstrom) then
					G:FrameGlowShowOrHide(eaf,(iUnitPower >= UnitPowerMax(unit, Enum.PowerType.Maelstrom)))				
				end
				
				--惡魔獵人魔怒達到上限高亮
				if (iPowerType == Enum.PowerType.Fury) then						
					G:FrameGlowShowOrHide(eaf,(iUnitPower >= UnitPowerMax(unit, Enum.PowerType.Fury)))
				end
				
				--惡魔獵人魔痛達到上限高亮
				-- if (iPowerType == Enum.PowerType.Pain) then						
					-- G:FrameGlowShowOrHide(eaf,(iUnitPower >= UnitPowerMax(unit, Enum.PowerType.Pain)))
				-- end
				
				--喚能師"龍能"達到上限高亮
				if (iPowerType == Enum.PowerType.Essence) then						
					G:FrameGlowShowOrHide(eaf,(iUnitPower >= UnitPowerMax(unit, Enum.PowerType.Essence)))
				end
				
			else
				G:FrameGlowShowOrHide(eaf, false)				
				EA_SpecFrame_Self = false
				eaf:Hide()
			end
			--G:PositionFrames()
		end
	end
end
-----------------------------------------------------------------
-- Speciall Frame: UpdateLifeBloom & OnLifeBloomUpdate, for watching the currently(max-stack) lifebloom of player
function G:OnLifeBloomUpdate()
	local iFrameIndex = 33763
	local eaf = _G["EAFrameSpec_"..iFrameIndex]
	if (eaf ~= nil) then
		local EA_timeLeft = 0
		if (EA_SpecFrame_LifeBloom.ExpireTime ~= nil) then
			EA_timeLeft = EA_SpecFrame_LifeBloom.ExpireTime - GetTime()
		end
		if (EA_timeLeft > 0) then
			if (EA_Config.ShowTimer) then
				EAFun_SetCountdownStackText(eaf, EA_timeLeft, EA_SpecFrame_LifeBloom.Stack, -1)
				if EA_timeLeft < 4 then
				 	eaf.spellTimer:SetFont(EA_FONTS, EA_Config.TimerFontSize+5, "OUTLINE")
					eaf.spellTimer:SetTextColor(1, 0, 0)
				else
				 	eaf.spellTimer:SetFont(EA_FONTS, EA_Config.TimerFontSize, "OUTLINE")
					eaf.spellTimer:SetTextColor(1, 1, 1)
				end
			end
		else
			EA_SpecFrame_LifeBloom.UnitID = ""
			EA_SpecFrame_LifeBloom.UnitName = ""
			EA_SpecFrame_LifeBloom.ExpireTime = 0
			EA_SpecFrame_LifeBloom.Stack = 0
			EA_SpecFrame_Self = false
			-- eaf:SetScript("OnUpdate", nil)
			Lib_ZYF:StopOnUpdate(eaf)
			if eaf:IsVisible() then eaf:Hide() end
			--G:PositionFrames()
		end
	end
end
-----------------------------------------------------------------
function G:UpdateLifeBloom(EA_Unit)
	local iFrameIndex = 33763
	local fNewToShow = false
	local eaf = _G["EAFrameSpec_"..iFrameIndex]
	if (eaf ~= nil) then
		if (EA_Unit ~= "") then
			if (EA_Config.ShowFrame == true) then
				EA_Main_Frame:ClearAllPoints()
				EA_Main_Frame:SetPoint(EA_Position.Anchor, UIParent, EA_Position.relativePoint, EA_Position.xLoc, EA_Position.yLoc)
				local prevFrame = "EA_Main_Frame"
				local xOffset = 100 + EA_Position.xOffset
				local yOffset = 0 + EA_Position.yOffset
				local SfontName, SfontSize = "", 0
				for i=1, 40 do
					local _,  _, count, _, _, expirationTime, unitCaster, _, _, spellID = UnitBuff(EA_Unit, i)
					if (not spellID) then
						break
					end
					if (spellID == iFrameIndex and unitCaster == "player") then
						local iShiftFormID = GetShapeshiftFormID()
						fNewToShow = false
						if (iShiftFormID == nil) then
							fNewToShow = true	-- Non-Lift of tree, single lifebloom
						elseif (iShiftFormID == 2) then -- Life of tree form, multi lifebloom
							if (count > EA_SpecFrame_LifeBloom.Stack) then
								fNewToShow = true
							elseif (count == EA_SpecFrame_LifeBloom.Stack and expirationTime >= EA_SpecFrame_LifeBloom.ExpireTime) then
								fNewToShow = true
							end
						end
						if (fNewToShow) then
							EA_SpecFrame_LifeBloom.UnitID = EA_Unit
							EA_SpecFrame_LifeBloom.UnitName = UnitName(EA_Unit)
							EA_SpecFrame_LifeBloom.ExpireTime = expirationTime
							EA_SpecFrame_LifeBloom.Stack = count
						end
						break
					end
				end
				if (fNewToShow) then
					EA_SpecFrame_Self = true
					eaf:ClearAllPoints()
					eaf:SetPoint(EA_Position.Anchor, prevFrame, EA_Position.Anchor, -1 * xOffset, -1 * yOffset)
					eaf:SetWidth(EA_Config.IconSize)
					eaf:SetHeight(EA_Config.IconSize)
					if (EA_Config.ShowName == true) then
						eaf.spellName:SetText(EA_SpecFrame_LifeBloom.UnitName)
						SfontName, SfontSize = eaf.spellName:GetFont()
						eaf.spellName:SetFont(SfontName, EA_Config.SNameFontSize)
					else
						eaf.spellName:SetText("")
					end
					Lib_ZYF:FrameSetOnUpdate(eaf, G.UpdateInterval, G.OnLifeBloomUpdate)
					-- eaf:SetScript("OnUpdate", function(self,elapsedTime)
					-- G:TimeSinceUpdate_LifeBloom =G:TimeSinceUpdate_LifeBloom + elapsedTime
					-- if G:TimeSinceUpdate_LifeBloom > G:UpdateInterval then
						-- G:OnLifeBloomUpdate()
						-- G:TimeSinceUpdate_LifeBloom = 0
					-- end
					-- end)
					
					if eaf:IsShown()==false then  eaf:Show() end
				end
				--G:PositionFrames()
			end
		else
			-- print ("fNewToShow = false 1")
			EA_SpecFrame_LifeBloom.UnitID = ""
			EA_SpecFrame_LifeBloom.UnitName = ""
			EA_SpecFrame_LifeBloom.ExpireTime = 0
			EA_SpecFrame_LifeBloom.Stack = 0
			EA_SpecFrame_Self = false
			-- eaf:SetScript("OnUpdate", nil)
			Lib_ZYF:StopOnUpdate(eaf)
			if eaf:IsVisible() then eaf:Hide() end
			--G:PositionFrames()
		end
	end
end

--Update Vigor(活力)
--Call From 
function G:UpdateVigor(...)
	if ... == nil then return end 
	
	local vigor, vigorMax, vigorCount, vigorCountMax = ...
	
	if EA_flagAllHidden == true then 
		EA_Main_Frame:SetAlpha(0) 
		return 
	else
		EA_Main_Frame:SetAlpha(1) 
	end	
	
	if (EA_Config.ShowFrame == true) then
		EA_Main_Frame:ClearAllPoints()
		EA_Main_Frame:SetPoint(EA_Position.Anchor, UIParent, EA_Position.relativePoint, EA_Position.xLoc, EA_Position.yLoc)
		local prevFrame = "EA_Main_Frame"
		local xOffset = 100 + EA_Position.xOffset
		local yOffset = 0 + EA_Position.yOffset
		local SfontName, SfontSize = "", 0
		local eaf = _G["EAFrameSpec_".."362777"]				
		
		if (eaf ~= nil) then			
				
				eaf:ClearAllPoints()				
				eaf:SetPoint(EA_Position.Anchor, prevFrame, EA_Position.Anchor, -4 * xOffset,  -4 * yOffset)
				
				if (EA_Config.ShowName) then
					--顯示活力名稱及最大值
					eaf.spellName:SetText(EA_SPELL_POWER_NAME.Vigor.."\n("..vigorCountMax..")")
					SfontName, SfontSize = eaf.spellName:GetFont()
					eaf.spellName:SetFont(SfontName, EA_Config.SNameFontSize)
				else
					eaf.spellName:SetText("")
				end
				
				eaf.spellTimer:ClearAllPoints()
				eaf.spellStack:ClearAllPoints()
				if (EA_Config.ChangeTimer == true) then
				
					--活力值顯示於框架內  					
					eaf.spellTimer:SetPoint("CENTER"     , eaf, "CENTER"     ,0 , 0)
					--活力個數顯示於右下角
					eaf.spellStack:SetPoint("BOTTOMRIGHT", eaf, "BOTTOMRIGHT",-4 , 2)					
				
				else                                              
					--活力值顯示於框架外					
					eaf.spellTimer:SetPoint("BOTTOM",eaf, "TOP"   , 0, 0)
					--活力個數顯示於框架內中央
					eaf.spellStack:SetPoint("CENTER",eaf, "CENTER", 0, 0)     					
				end
				
				eaf.spellTimer:SetFont(EA_FONTS, EA_Config.TimerFontSize, "OUTLINE")
				eaf.spellStack:SetFont(EA_FONTS, EA_Config.StackFontSize, "OUTLINE")
				
				--若為0則不顯示
				eaf.spellTimer:SetText((vigor 		> 0) and vigor	 	or "")
				eaf.spellStack:SetText((vigorCount 	> 0) and vigorCount or "")
				
				eaf:Show()
				
				--精力達到上限高亮
				G:FrameGlowShowOrHide(eaf, (vigorCount == vigorCountMax))
				
		end
	end
end
-----------------------------------------------------------------
-- Speciall Frame: CheckExecution, for checking the health percent of the current target
function G:CheckExecution()
	
	local EAEXF = G.EAEXF
	
	EA_Position.Execution = tonumber(EA_Position.Execution)
	
	if (EA_Position.Execution > 0) then
		
		local iDead = UnitIsDeadOrGhost("target")
		local iEnemy = UnitCanAttack("player", "target")
		local iLevel = 3		
		if ((iDead == false) and (iEnemy == true)) then
		
			local iLvPlayer, iLvTarget = UnitLevel("player"), UnitLevel("target")		
			if ((EA_Position.PlayerLv2BOSS and iLvTarget == -1) or (iLvPlayer >= iLvTarget)) then
			
				local iHppTarget = (UnitHealth("target") * 100) / UnitHealthMax("target")
				if (iHppTarget <= EA_Position.Execution) then
			
					if (not EAEXF.AlreadyAlert) then
			
						local eaf = _G["EventAlert_ExecutionFrame"]
						eaf:SetAlpha(0.75)
						eaf:Show()						
						EAEXF.FrameCount = 0
						EAEXF.Prefraction = 0
						EAEXF:AnimateOut(eaf)
						EAEXF.AlreadyAlert = true
					end
				else
					EAEXF.AlreadyAlert = false
				end
			end
		else
			EAEXF.AlreadyAlert = false
		end
	end
end
-----------------------------------------------------------------
function G:Lookup(para1, fullmatch)
	local startTime = GetTime()
	local sFMatch = ""
	local sName = ""
	local iCount = 0
	local sSpellLink = ""
	local fGoPrint = false
	if (para1 == nil) then
		for i, v in ipairs(EA_XCMD_CMDHELP["LOOKUP"]) do
			if i == 1 then
				DEFAULT_CHAT_FRAME:AddMessage(v)
			elseif MoreHelp then
				DEFAULT_CHAT_FRAME:AddMessage(v)
			end
		end
		for i, v in ipairs(EA_XCMD_CMDHELP["LOOKUPFULL"]) do
			if i == 1 then
				DEFAULT_CHAT_FRAME:AddMessage(v)
			elseif MoreHelp then
				DEFAULT_CHAT_FRAME:AddMessage(v)
			end
		end
		return
	end
	if fullmatch then sFMatch = " / "..EA_XLOOKUP_START2 end
	DEFAULT_CHAT_FRAME:AddMessage(EA_XLOOKUP_START1..": [\124cffFFFF00"..para1.."\124r]"..sFMatch)
	DEFAULT_CHAT_FRAME:AddMessage("使用協程背景查詢中,目前在查詢速度與卡頓取得一個平衡點,會有輕微卡頓,請勿中斷或重新查詢")
	EAFun_ClearSpellScrollFrame()
	local strfind = strfind
	local DoesItemExistByID = C_Spell.DoesSpellExist
	local GetSpellInfo = GetSpellInfo
	local GetSpellLink = GetSpellLink
	local maxspellid = 1000000
	local function getAllSpell()
		for i=1, maxspellid do	
			if DoesSpellExist(i) then
				sName = (GetSpellInfo(i))
				fGoPrint = false
				if (sName ~= nil) then			
					if (fullmatch) then
						if (sName == para1) then fGoPrint = true end
					else
						if (strfind(sName, para1)) then fGoPrint = true end
					end
					if (fGoPrint) then
						sSpellLink = GetSpellLink(i)
						--if (sSpellLink ~= nil) then
							iCount = iCount + 1
							-- DEFAULT_CHAT_FRAME:AddMessage("["..tostring(iCount).."]\124cffFFFF00"..EA_XCMD_DEBUG_P2.."\124r="..tostring(i).." / \124cffFFFF00"..EA_XCMD_DEBUG_P1.."\124r="..sSpellLink)
							EAFun_AddSpellToScrollFrame(i, "")
						--end
					end		
				end						
			end
			
			--每次只比對N個法術ID就暫停並釋放控制權
			if (i % 2000) == 0 then 				
				coroutine.yield() 
			end                   			
		end
		
		EA_Version_Frame:Show()
		DEFAULT_CHAT_FRAME:AddMessage(EA_XLOOKUP_RESULT1..": \124cffFFFF00"..tostring(iCount).."\124r"..EA_XLOOKUP_RESULT2)
		print(format("查詢共花費:%d秒", GetTime()-startTime))
		
	end
	
	-- 創建一個定時器，每1/N秒執行一次 getAllSpell()
	local co = coroutine.create(getAllSpell)
	G.tickerGetSpell = C_Timer.NewTicker(1/2000, function()	
	
		-- 如果協程已經結束，取消定時器		
		if coroutine.status(co) == "dead" then 			
			G.tickerGetSpell:Cancel()
			return
		end                 
		
		-- 恢復協程的執行，繼續獲取數據
		coroutine.resume(co)
	end)

	-- 啟動協程執行
	coroutine.resume(co)
 	
	
end
-----------------------------------------------------------------
function EAFun_AddSpellToScrollFrame(spellID, OtherMessage)
	if spellID == nil then return end
	spellID = tonumber(spellID)
	if OtherMessage == nil then OtherMessage = "" end
	if EA_ShowScrollSpells[spellID] == nil then
		EA_ShowScrollSpells[spellID] = true
		local EA_name = GetSpellInfo(spellID)
		local EA_icon = GetSpellTexture(spellID)
		if EA_name == nil then EA_name = "" end
		local f1 = _G["EA_Version_ScrollFrame_Icon_"..spellID]
		if f1 == nil then
			EA_ShowScrollSpell_YPos = EA_ShowScrollSpell_YPos - 25
			local ShowScrollIcon = CreateFrame("Frame", "EA_Version_ScrollFrame_Icon_"..spellID, EA_Version_ScrollFrame_List)
			--for 7.0
			ShowScrollIcon.texture = ShowScrollIcon:CreateTexture()
			ShowScrollIcon.texture:SetAllPoints(ShowScrollIcon)
			ShowScrollIcon.texture:SetTexture(EA_icon)
			ShowScrollIcon:SetWidth(25)
			ShowScrollIcon:SetHeight(25)
			ShowScrollIcon:SetPoint("TOPLEFT", 0, EA_ShowScrollSpell_YPos)
			--ShowScrollIcon:SetBackdrop({bgFile = EA_icon})
		else
			if (not f1:IsShown()) then
				EA_ShowScrollSpell_YPos = EA_ShowScrollSpell_YPos - 25
				f1:SetPoint("TOPLEFT", 0, EA_ShowScrollSpell_YPos)
				f1:Show()
			end
		end
		local framewidth = EA_Version_Frame:GetWidth()+50
		local f2 = _G["EA_Version_ScrollFrame_EditBox_"..spellID]
		if f2 == nil then
			local ShowScrollEditBox = CreateFrame("EditBox", "EA_Version_ScrollFrame_EditBox_"..spellID, EA_Version_ScrollFrame_List)
			ShowScrollEditBox:SetPoint("TOPLEFT", 30, EA_ShowScrollSpell_YPos)
			ShowScrollEditBox:SetFontObject(EA_FONT_OBJECT)
			ShowScrollEditBox:SetWidth(framewidth)
			ShowScrollEditBox:SetHeight(25)
			ShowScrollEditBox:SetMaxLetters(0)
			ShowScrollEditBox:SetAutoFocus(false)
			ShowScrollEditBox:SetText(EA_name.." ["..spellID.."]"..OtherMessage)
			local function ShowScrollEditBoxGameToolTip()
				ShowScrollEditBox:SetTextColor(0, 1, 1)
				GameTooltip:SetOwner(ShowScrollEditBox, "ANCHOR_TOPLEFT")
				GameTooltip:SetSpellByID(spellID)
			end
			local function HideScrollEditBoxGameToolTip()
				ShowScrollEditBox:SetTextColor(1, 1, 1)
				ShowScrollEditBox:HighlightText(0,0)
				ShowScrollEditBox:ClearFocus()
				GameTooltip:Hide()
			end
			ShowScrollEditBox:SetScript("OnEnter", ShowScrollEditBoxGameToolTip)
			ShowScrollEditBox:SetScript("OnLeave", HideScrollEditBoxGameToolTip)
		else
			if (not f2:IsShown()) then
				f2:SetPoint("TOPLEFT", 30, EA_ShowScrollSpell_YPos)
				f2:Show()
			end
		end
	end
end
-----------------------------------------------------------------
function EAFun_ClearSpellScrollFrame()
	EA_Version_Frame_HeaderText:SetText(EA_XCMD_DEBUG_P0)
	-- EA_Version_ScrollFrame_EditBox:SetText("")
	EA_Version_ScrollFrame_EditBox:Hide()
	local prefixIconFrame    = "EA_Version_ScrollFrame_Icon_"
	local prefixEditBoxFrame = "EA_Version_ScrollFrame_EditBox_"
	table.foreach(EA_ShowScrollSpells,
	function(i, v)
		-- MyPrint ("Clear:["..i.."]")
		local f1 = _G[tconcat({prefixIconFrame,i})]
		if f1 ~= nil then
			f1:Hide()
			f1 = nil
		end
		local f2 = _G[tconcat({prefixEditBoxFrame,i})]
		if f2 ~= nil then
			f2:Hide()
			f2 = nil
		end
	end)
	EA_ShowScrollSpells = { }
	EA_ShowScrollSpell_YPos = 25
end
-----------------------------------------------------------------
function EAFun_GetCountOfTable(EAItems)
	local iCount = 0
	if (EAItems ~= nil) then
		for i, v in pairsByKeys(EAItems) do
			iCount = iCount + 1
		end
	end
	return iCount
end
-----------------------------------------------------------------
function EAFun_GetUnitIDByName(EA_UnitName)
	local fNotFound, iIndex = true, 1
	local sUnitID, sUnitName = "", ""
	local UnitName = UnitName
	local UnitType = UnitType
	local GetNumSubgroupMembers = GetNumSubgroupMembers
	if UnitInRaid("player") then
		iIndex = 1
		while (fNotFound and iIndex <= 40) do
			sUnitID = "raid"..iIndex
			sUnitName = UnitName(sUnitID)
			if EA_UnitName == sUnitName then fNotFound = false end
			iIndex = iIndex + 1
		end
	-- 5.1???G?NGetNumPartyMembers()????GetNumSubgroupMembers()
	elseif GetNumSubgroupMembers() > 0 then
		iIndex = 1
		while (fNotFound and iIndex <= 4) do
			sUnitID = "party"..iIndex
			sUnitName = UnitName(sUnitID)
			if EA_UnitName == sUnitName then fNotFound = false end
			iIndex = iIndex + 1
		end
	end
	if (fNotFound) then
		local UnitType={"mouseover","target","focus"}
		for i=1,#UnitType do
			if UnitName(UnitType[i])==EA_UnitName then
				return UnitType[i]
			end
		end
		return ""
	else
		return sUnitID
	end
end
-----------------------------------------------------------------
function EAFun_DealTooltips()

	local TooltipDataProcessor = TooltipDataProcessor
	
	TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Spell,function(tooltip,data) 
		-- for k,v in pairs(data) do print(k,v) end
		-- local id = select(2, tooltip:GetSpell())
		local id = data.id
		if id then
			tooltip:AddDoubleLine(tconcat({"(EAM)", EX_XCLSALERT_SPELL}), id)			
			tooltip:Show()
		end
	end)
	
	TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Macro,function(tooltip, data) 
										  
		local id = data.lines[1].tooltipID
		if id then
			tooltip:AddDoubleLine(tconcat({"(EAM)", EX_XCLSALERT_SPELL}), id)			
			tooltip:Show()
		end
	end)
	
	TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.UnitAura,function(tooltip, data) 		
		
		-- for k,v in pairs(tooltip) do print(k,v) end
		
		local id = data.id      		
		if id then
			tooltip:AddDoubleLine("(EAM)"..EX_XCLSALERT_SPELL, id)
			tooltip:Show()
		end
	end)
	
	TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item,function(tooltip, data) 
		local itemID = data.id
		if itemID then
			tooltip:AddDoubleLine("(EAM)ItemID:",itemID)
			tooltip:Show()
		end
		local name,id = GetItemSpell(itemID)
		if id then						
			tooltip:AddDoubleLine(tconcat({"(EAM)",EX_XCLSALERT_SPELL}), tconcat({id,"(",name,")"}))
			tooltip:Show()
		end
	end)
end

function EAFun_HookTooltips()

	local GameTooltip = GameTooltip
	-- hooksecurefunc(GameTooltip, "SetUnitBuff", function(self, ...)
		
		-- local id = select(10, UnitBuff(...))
		-- if id then
			-- self:AddDoubleLine("(EAM)"..EX_XCLSALERT_SPELL, id)
			-- self:Show()
		-- end
	-- end)
	-- hooksecurefunc(GameTooltip, "SetUnitDebuff", function(self, ...)
		
		-- local id = select(10, UnitDebuff(...))
		-- if id then
			-- self:AddDoubleLine("(EAM)"..EX_XCLSALERT_SPELL, id)
			-- self:Show()
		-- end
	-- end)
	hooksecurefunc(GameTooltip, "SetUnitAura", function(self, ...)
		
		local unitID, index, AuraFilter = ...
		
		local id = select(10, UnitAura(unitID, index))
		
		if id then
			self:AddDoubleLine("(EAM)"..EX_XCLSALERT_SPELL, id.."("..UnitName(unitID)..")")
			self:Show()
		end
	end)
	hooksecurefunc(GameTooltip, "SetBagItem", function(self,bag,slot)		
		local itemID = C_Container.GetContainerItemID(bag,slot)
		if itemID then
			self:AddDoubleLine("(EAM)ItemID:",itemID)			
			self:Show()
		end
		local name,id = GetItemSpell(itemID)
		if id then			
			-- self:AddDoubleLine("(EAM)"..EX_XCLSALERT_SPELL,id.."("..name..")")			
			self:AddDoubleLine(tconcat({"(EAM)",EX_XCLSALERT_SPELL}), tconcat({id,"(",name,")"}))			
			self:Show()
		end
	end)
	hooksecurefunc(GameTooltip, "SetInventoryItem", function(self,unit,invslot)		
		local itemID = GetInventoryItemID(unit,invslot)
		if itemID then
			self:AddDoubleLine("(EAM)ItemID:",itemID)			
			self:Show()
		end
		local name,id = GetItemSpell(itemID)
		if id then			
			-- self:AddDoubleLine("(EAM)"..EX_XCLSALERT_SPELL,id.."("..name..")")			
			self:AddDoubleLine(tconcat({"(EAM)",EX_XCLSALERT_SPELL}), tconcat({id,"(",name,")"}))
			self:Show()
		end
	end)
	hooksecurefunc("SetItemRef", function(link, text, button, chatFrame)
		local itemID
		itemID = tonumber(string.match(link,"item:%d+"))
		if itemID then		
			ItemRefTooltip:AddDoubleLine("(EAM)ItemID:",itemID)
			ItemRefTooltip:Show()
		end
		if string.find(link,"^spell:") then
			local id = string.sub(link,7)
			if id then
				-- ItemRefTooltip:AddDoubleLine("(EAM)"..EX_XCLSALERT_SPELL,id)
				ItemRefTooltip:AddDoubleLine(tconcat({"(EAM)", EX_XCLSALERT_SPELL}), id)
				ItemRefTooltip:Show()
			end
		else
			local name,id = GetItemSpell(itemID)			
			if id then
				-- ItemRefTooltip:AddDoubleLine("(EAM)"..EX_XCLSALERT_SPELL,id.."("..name..")")
				ItemRefTooltip:AddDoubleLine(tconcat({"(EAM)",EX_XCLSALERT_SPELL}), tconcat({id, "(", name,")"}))
				ItemRefTooltip:Show()
			end
		end
	end)
	
	
	GameTooltip:HookScript("OnTooltipSetSpell", function(self)
		local id = select(2, self:GetSpell())
		if id then
			-- self:AddDoubleLine("(EAM)"..EX_XCLSALERT_SPELL,id)
			self:AddDoubleLine(tconcat({"(EAM)", EX_XCLSALERT_SPELL}), id)			
			self:Show()
		end
	end)
end
-----------------------------------------------------------------
-- For OrderWtd, to sort the order of the buffs/debuffs.
function EAFun_SortCurrBuffs(TypeIndex, EACurrBuffs)
	
	local tinsert = table.insert
	-- local EA_AllCurrBuffs = {[1]=EA_CurrentBuffs, [2]=EA_TarCurrentBuffs, [3]=EA_ScdCurrentBuffs}
	-- local EACurrBuffs = EA_AllCurrBuffs[TypeIndex]
	local EA_SPELLINFO_ALL = {[1]=EA_SPELLINFO_SELF, [2]=EA_SPELLINFO_TARGET, [3]=EA_SPELLINFO_SCD}
	local EA_SPELLINFO = EA_SPELLINFO_ALL[TypeIndex]
	
	local TempArray = {}
	local SortArray = {}
	local OrderWtd = 1	
	local spellId 
		
	local Loopi, Loopj	
	for Loopi = 1, #EACurrBuffs do
		spellId = EACurrBuffs[Loopi]
		OrderWtd = EA_SPELLINFO[spellId].orderwtd or 1
		-- OrderWtd = EA_SPELLINFO[spellId].orderwtd
		-- if (OrderWtd == nil) then OrderWtd = 1 end
		TempArray[OrderWtd] = TempArray[OrderWtd] or {}
		-- if TempArray[OrderWtd] == nil then TempArray[OrderWtd] = {} end
		tinsert(TempArray[OrderWtd], spellId)
	 end
	 for Loopi=20, 1, -1 do
		 if TempArray[Loopi] ~= nil then
			 for Loopj=1,#TempArray[Loopi] do
				 if TempArray[Loopi][Loopj] ~= nil then
					 tinsert(SortArray, TempArray[Loopi][Loopj])
				 end
			 end
		 end
	 end
	 return SortArray
end
-----------------------------------------------------------------
-- GroupEvent: FireEventCheckHide, Check if to hide this GroupEvent
function EAFun_FireEventCheckHide(self)
	if self.GC.GroupResult then
		self:SetWidth(0)
		self:SetHeight(0)
		self.GC.GroupIconID = 0
		self.GC.GroupResult = false
		self.spellName:SetText("")
		self:Hide()
	end
end
-- GroupEvent: FireEventSubCheckResult. The Subcheck changes, so check back to upper level to conclude the final result.
function EAFun_FireEventSubCheckResult(self, iSpells, iChecks)
	local fGroupResult, fSpellResult, fCheckResult = false, true, true
	local sGroupSpellName, iGroupIconID, sGroupIconPath = "", 0, ""
	local SfontName, SfontSize = "", 0	
	-- SubCheck
	for iIndex,aValue in ipairs(self.GC.Spells[iSpells].Checks[iChecks].SubChecks) do
		if aValue.SubCheckAndOp then
			-- first subcheck must be "AND" operation
			fCheckResult = fCheckResult and aValue.SubCheckResult
		else
			fCheckResult = fCheckResult or aValue.SubCheckResult
		end
	end
	self.GC.Spells[iSpells].Checks[iChecks].CheckResult = fCheckResult
	-- Check
	for iIndex,aValue in ipairs(self.GC.Spells[iSpells].Checks) do
		if aValue.CheckAndOp then
			-- first check must be "AND" operation, too.
			fSpellResult = fSpellResult and aValue.CheckResult
		else
			fSpellResult = fSpellResult or aValue.CheckResult
		end
	end
	self.GC.Spells[iSpells].SpellResult = fSpellResult
	-- Spell
	for iIndex,aValue in ipairs(self.GC.Spells) do
		if aValue.SpellResult then
			fGroupResult = true
			sGroupSpellName = aValue.SpellName
			iGroupIconID = aValue.SpellIconID
			sGroupIconPath = aValue.SpellIconPath
			break
		end
	end
	--若該法術是當前專精內之天賦且無啟動該天賦則返回不顯示
	if (fGroupResult) then
		local isActiveTalent,talent_row,talent_col = G:IsActiveTalentBySpellID(iGroupIconID)
		if (talent_row > 0) and (talent_col > 0) then
			if isActiveTalent == false then
				EAFun_FireEventCheckHide(self)
				return
			end
		end
	end
	-- Group
	if (fGroupResult) then
		if ((not self.GC.GroupResult) or (self.GC.GroupResult and (self.GC.GroupIconID ~= iGroupIconID)))then
			self.GC.GroupIconID = iGroupIconID
			--self:SetBackdrop({bgFile = sGroupIconPath})
			--for 7.0
			if not(self.texture) then 
				self.texture = self:CreateTexture()
				self.texture:SetAllPoints(self)
			end
			self.texture:SetTexture(sGroupIconPath)
			if (self.GC.IconAlpha ~= nil) then self:SetAlpha(self.GC.IconAlpha) end
			self:SetPoint(self.GC.IconPoint, UIParent, self.GC.IconRelatePoint, self.GC.LocX, self.GC.LocY)	-- 0, -100
			self:SetWidth(self.GC.IconSize)
			self:SetHeight(self.GC.IconSize)
			self.GC.GroupResult = true
			if (EA_Config.ShowName == true) then
				self.spellName:SetText(sGroupSpellName)
				SfontName, SfontSize = self.spellName:GetFont()
				self.spellName:SetFont(SfontName, EA_Config.SNameFontSize)
			else
				self.spellName:SetText("")
			end
			self:Show()
			if (self.GC.GlowWhenTrue ~= nil) then				
				G:FrameGlowShowOrHide(self,self.GC.GlowWhenTrue)				
			end
		end
	else
		EAFun_FireEventCheckHide(self)
	end
end
-- GroupEvent: GroupFrameUnitDie. If target/focus Unit is died, then notice all UNIT_HEALTH event with this target/focus Unit.
function G:GroupFrameUnitDie_OnEvent(self, event, ...)
	local iSpells, iChecks, iSubChecks = 0, 0, 0
	local iGroupIndex = self.GC.GroupIndex
	local SubCheck = {}
	-- if (event == "UNIT_HEALTH") then
	local sUnitType = ...
	-- SPEC EVENT FIRED, To check all INDEXD-EVENTCFG about this frame(by GroupIndex).
	if (GC_IndexOfGroupFrame[event] ~= nil) then
		if (GC_IndexOfGroupFrame[event][iGroupIndex] ~= nil) then
			for iIndex, aValue in ipairs(GC_IndexOfGroupFrame[event][iGroupIndex]) do
				iSpells = GC_IndexOfGroupFrame[event][iGroupIndex][iIndex].Spells
				iChecks = GC_IndexOfGroupFrame[event][iGroupIndex][iIndex].Checks
				iSubChecks = GC_IndexOfGroupFrame[event][iGroupIndex][iIndex].SubChecks
				SubCheck = self.GC.Spells[iSpells].Checks[iChecks].SubChecks[iSubChecks]
				if (sUnitType == SubCheck.UnitType) then -- "player"
					self.GC.Spells[iSpells].Checks[iChecks].SubChecks[iSubChecks].SubCheckResult = false
					EAFun_FireEventSubCheckResult(self, iSpells, iChecks)
				end
			end
		end
	end
	-- end
end
-- GroupEvent: CurrValueCompCfgValue. The 5 ways of comparison.
function EAFun_CurrValueCompCfgValue(CompType, CurrValue, CfgValue)
	local fResult = falase
	if (CompType == 1) then		-- Curr < Cfg
		if (CurrValue < CfgValue) then fResult = true end
	elseif (CompType == 2) then	-- Curr <= Cfg
		if (CurrValue <= CfgValue) then fResult = true end
	elseif (CompType == 3) then	-- Curr = Cfg
		if (CurrValue == CfgValue) then fResult = true end
	elseif (CompType == 4) then	-- Curr >= Cfg
		if (CurrValue >= CfgValue) then fResult = true end
	elseif (CompType == 5) then	-- Curr > Cfg
		if (CurrValue > CfgValue) then fResult = true end
	elseif (CompType == 6) then	-- Curr <> Cfg		
		if (CurrValue ~= CfgValue) then fResult = true end		
	elseif (CompType == 7) then	-- Cfg = any
		fResult = true
	end
	return fResult
end
-----------------------------------------------------------------
-- GroupEvent: GroupFrameCheck. The core checking routine for GroupEvent Conditions.
function G:GroupFrameCheck_OnEvent(event, ...)
	local iSpells, iChecks, iSubChecks = 0, 0, 0
	local iGroupIndex = self.GC.GroupIndex
	local SubCheck = {}
	local iActiveTalentGroup = 0
	local fAllUnitMonitor = false
	local fShowResult = true	
	-- If this GroupCheck is Enabled / Disabled
	if (self.GC.enable ~= nil) then
		if (not self.GC.enable) then
			fShowResult = false
		end
	end
	-- If the Active-Talent should be checked
	if (fShowResult) then
		if (self.GC.ActiveTalentGroup ~= nil) then
			--5.1:GetActiveTalentGroup() -> GetActiveSpecGroup()
			--iActiveTalentGroup = GetActiveSpecGroup()
			--7.0 GetActiveSpecGroup() -> GetSpecialization()
			iActiveTalentGroup =  GetSpecialization and GetSpecialization()
			if (iActiveTalentGroup ~= self.GC.ActiveTalentGroup) then
				fShowResult = false
			end
		end
	end
	-- If the Hide-On-Leave-of-Combat should be checked
	if (fShowResult) then
		if (self.GC.HideOnLeaveCombat ~= nil) then
			if (self.GC.HideOnLeaveCombat) then
				if (not UnitAffectingCombat("player")) then
					fShowResult = false
				end
			end
		end
	end
	-- If the Hide-On-Lost-Target should be checked
	if (fShowResult) then
		if (self.GC.HideOnLostTarget ~= nil) then
			if (self.GC.HideOnLostTarget) then
				if (not UnitExists("target")) then
					fShowResult = false
				end
			end
		end
	end
	local sTempUnitType = "target"
	if ((not UnitExists(sTempUnitType)) or UnitIsCorpse(sTempUnitType) or UnitIsDeadOrGhost(sTempUnitType)) then
		G:GroupFrameUnitDie_OnEvent(self, "UNIT_HEALTH", sTempUnitType)
	end
	sTempUnitType = "focus"
	if ((not UnitExists(sTempUnitType)) or UnitIsCorpse(sTempUnitType) or UnitIsDeadOrGhost(sTempUnitType)) then
		G:GroupFrameUnitDie_OnEvent(self, "UNIT_HEALTH", sTempUnitType)
	end
	if (not fShowResult) then
		EAFun_FireEventCheckHide(self)
	else
		if (event == "ACTIVE_TALENT_GROUP_CHANGED") then
			-- If the Active-Talent should be checked
			--5.1:GetActiveTalentGroup() -> GetActiveSpecGroup()
			--7.0 GetActiveSpecGroup() -> GetSpecialization()
			iActiveTalentGroup = GetSpecialization()
			if (iActiveTalentGroup ~= self.GC.ActiveTalentGroup) then
				fShowResult = false
				EAFun_FireEventCheckHide(self)
			end
		elseif (event == "PLAYER_REGEN_ENABLED") then
			-- If the Hide-On-Leave-of-Combat should be checked
			if (self.GC.HideOnLeaveCombat ~= nil) then
				if (self.GC.HideOnLeaveCombat) then
					if (UnitAffectingCombat("player")) then
						fShowResult = false
						EAFun_FireEventCheckHide(self)
					end
				end
			end
		elseif (event == "PLAYER_TARGET_CHANGED") then
			-- If the Hide-On-Lost-Target should be checked
			if (self.GC.HideOnLostTarget ~= nil) then
				if (self.GC.HideOnLostTarget) then
					if (not UnitExists("target")) then
						fShowResult = false
						EAFun_FireEventCheckHide(self)
					end
				end
			end
		elseif (event == "UNIT_POWER_UPDATE") then
			local sUnitType, sPowerType = ...
			-- SPEC EVENT FIRED, To check all INDEXD-EVENTCFG about this frame(by GroupIndex).
			-- GC_IndexOfGroupFrame["UNIT_POWER"] = {[1]={Spells=1,Checks=1,SubChecks=1,},}
			for iIndex, aValue in ipairs(GC_IndexOfGroupFrame[event][iGroupIndex]) do
				iSpells = GC_IndexOfGroupFrame[event][iGroupIndex][iIndex].Spells
				iChecks = GC_IndexOfGroupFrame[event][iGroupIndex][iIndex].Checks
				iSubChecks = GC_IndexOfGroupFrame[event][iGroupIndex][iIndex].SubChecks
				SubCheck = self.GC.Spells[iSpells].Checks[iChecks].SubChecks[iSubChecks]
				if (sUnitType == SubCheck.UnitType or SubCheck.UnitType == "all") then -- "player"
					if (sPowerType == SubCheck.PowerType) then						
						fShowResult = true
						if (fShowResult) then
							if (SubCheck.CheckCD ~= nil) then
								local iStart, iDuration, iEnable = GetSpellCooldown(SubCheck.CheckCD)
								if (iStart <= 0) or (iStart >= 0 and iDuration <= 1.5) then
									if IsUsableSpell(SubCheck.CheckCD) then
										fShowResult = true
									end																
								else
									fShowResult = false
								end
							end
						end
						if (fShowResult) then
							local iCurrPowerValue, iCheckPowerValue = 0
							if SubCheck.PowerLessThanValue ~= nil then								
								iCurrPowerValue = UnitPower(sUnitType, SubCheck.PowerTypeNum)
								iCheckPowerValue = SubCheck.PowerLessThanValue
							elseif SubCheck.PowerLessThanPercent ~= nil then
								iCurrPowerValue = (UnitPower(sUnitType, SubCheck.PowerTypeNum) * 100) / UnitPowerMax(sUnitType, SubCheck.PowerTypeNum)
								iCheckPowerValue = SubCheck.PowerLessThanPercent
							end
							fShowResult = EAFun_CurrValueCompCfgValue(SubCheck.PowerCompType, iCurrPowerValue, iCheckPowerValue)
						end
						self.GC.Spells[iSpells].Checks[iChecks].SubChecks[iSubChecks].SubCheckResult = fShowResult
						EAFun_FireEventSubCheckResult(self, iSpells, iChecks)
					end
				end
			end
		elseif (event == "UNIT_HEALTH") then
			local sUnitType = ...
			-- SPEC EVENT FIRED, To check all INDEXD-EVENTCFG about this frame(by GroupIndex).
			for iIndex, aValue in ipairs(GC_IndexOfGroupFrame[event][iGroupIndex]) do
				iSpells = GC_IndexOfGroupFrame[event][iGroupIndex][iIndex].Spells
				iChecks = GC_IndexOfGroupFrame[event][iGroupIndex][iIndex].Checks
				iSubChecks = GC_IndexOfGroupFrame[event][iGroupIndex][iIndex].SubChecks
				SubCheck = self.GC.Spells[iSpells].Checks[iChecks].SubChecks[iSubChecks]
				if (sUnitType == SubCheck.UnitType or SubCheck.UnitType == "all") then -- "player"
					fShowResult = true
					if (fShowResult) then
						if (SubCheck.CheckCD ~= nil) then
							local iStart, iDuration, iEnable = GetSpellCooldown(SubCheck.CheckCD)
							if (iStart <= 0) or (iStart >= 0 and iDuration <= 1.5) then
								fShowResult = true
							else
								fShowResult = false
							end
						end
					end
					if (fShowResult) then
						local iCurrHealthValue, iCheckHealthValue = 0
						if SubCheck.HealthLessThanValue ~= nil then
							iCurrHealthValue = UnitHealth(sUnitType)
							iCheckHealthValue = SubCheck.HealthLessThanValue
						elseif SubCheck.HealthLessThanPercent ~= nil then
							iCurrHealthValue = (UnitHealth(sUnitType) * 100) / UnitHealthMax(sUnitType)
							iCheckHealthValue = SubCheck.HealthLessThanPercent
						end
						fShowResult = EAFun_CurrValueCompCfgValue(SubCheck.HealthCompType, iCurrHealthValue, iCheckHealthValue)
					end
					self.GC.Spells[iSpells].Checks[iChecks].SubChecks[iSubChecks].SubCheckResult = fShowResult
					EAFun_FireEventSubCheckResult(self, iSpells, iChecks)
				end
			end
		elseif (event == "UNIT_AURA") then
			local sUnitType = ...
			local sAuraFilter = ""
			-- SPEC EVENT FIRED, To check all INDEXD-EVENTCFG about this frame(by GroupIndex).
			for iIndex, aValue in ipairs(GC_IndexOfGroupFrame[event][iGroupIndex]) do
				iSpells = GC_IndexOfGroupFrame[event][iGroupIndex][iIndex].Spells
				iChecks = GC_IndexOfGroupFrame[event][iGroupIndex][iIndex].Checks
				iSubChecks = GC_IndexOfGroupFrame[event][iGroupIndex][iIndex].SubChecks
				SubCheck = self.GC.Spells[iSpells].Checks[iChecks].SubChecks[iSubChecks]
				if (sUnitType == SubCheck.UnitType or SubCheck.UnitType == "all") then -- "player"
					fShowResult = true
					if (fShowResult) then
						if (SubCheck.CheckCD ~= nil) then
							local iStart, iDuration, iEnable = GetSpellCooldown(SubCheck.CheckCD)
							if (iStart <= 0) or (iStart >= 0 and iDuration <= 1.5) then
								fShowResult = true
							else
								fShowResult = false
							end
						end
					end
					if (fShowResult) then
						sAuraFilter = ""
						if (SubCheck.CastByPlayer ~= nil) then
							if (SubCheck.CastByPlayer) then
								sAuraFilter = "|PLAYER"
							end
						end
						if (SubCheck.CheckAuraExist ~= nil) then
							fShowResult = false
							local sSpellName = GetSpellInfo(SubCheck.CheckAuraExist)
							local sCurrSpellName,  _, iStack, _, _, iExpireTime = AuraUtil.FindAuraByName(sSpellName,sUnitType, "HELPFUL"..sAuraFilter)
							if sCurrSpellName ~= nil then
								fShowResult = true
							else
								sCurrSpellName, _, iStack, _, _, iExpireTime = AuraUtil.FindAuraByName(sSpellName,sUnitType, "HARMFUL"..sAuraFilter)
								if sCurrSpellName ~= nil then
									fShowResult = true
								end
							end
							-- ToDo: If Exists, Then Check seconds, stacks
							-- Modify: Show When Stack "OR" Remain Time match config value
							if (fShowResult) then
								if (SubCheck.StackCompType ~= nil) then
									fShowResult1 = EAFun_CurrValueCompCfgValue(SubCheck.StackCompType, iStack, SubCheck.StackLessThanValue)
								end							
								if (SubCheck.TimeCompType ~= nil) then
									local iLeftTime = iExpireTime - GetTime()
									fShowResult2 = EAFun_CurrValueCompCfgValue(SubCheck.TimeCompType, iLeftTime, SubCheck.TimeLessThanValue)
								end
								fShowResult = fShowResult1 and fShowResult2								
							end
						end
						if (SubCheck.CheckAuraNotExist ~= nil) then
							fShowResult = false
							local sSpellName = GetSpellInfo(SubCheck.CheckAuraNotExist)
							local sCurrSpellName = AuraUtil.FindAuraByName(sSpellName,sUnitType, "HELPFUL"..sAuraFilter)
							if sCurrSpellName == nil then
								sCurrSpellName = AuraUtil.FindAuraByName(sSpellName,sUnitType, "HARMFUL"..sAuraFilter)
								if sCurrSpellName == nil then
									fShowResult = true
								end
							end
						end
					end
					self.GC.Spells[iSpells].Checks[iChecks].SubChecks[iSubChecks].SubCheckResult = fShowResult
					EAFun_FireEventSubCheckResult(self, iSpells, iChecks)
				end
			end
		elseif (event == "UNIT_COMBO_POINTS") then
		end
	end
end
function G:IsActiveTalentBySpellID(Chk_spellID)
	local r=0
	local c=0
	local talent_row_max = 7
	local talent_col_max = 3
	local playerSpecGroup = GetActiveSpecGroup()
	local talent_row = 0
	local talent_col = 0
	local isActiveTalentSpellID = false
	for r = 1,talent_row_max do
		for c = 1,talent_col_max do
			local _,_,_,talentSelected,_,spellID = GetTalentInfo(r,c,playerSpecGroup)
			if Chk_spellID == spellID then
				talent_row = r
				talent_col = c				
				if talentSelected then
					isActiveTalentSpellID = true
				end
			end
		end
	end
	return isActiveTalentSpellID,talent_row,talent_col
end
-----------------------------------------------------------------				
--[[
	Death Knight 
	250 - Blood 血魄
	251 - Frost 冰霜
	252 - Unholy 穢邪
	Druid 
	102 - Balance 平衡
	103 - Feral Combat 野性戰鬥
	104 - Guardian 守護者
	105 - Restoration 恢復
	Hunter 
	253 - Beast Mastery 獸王
	254 - Marksmanship 射擊
	255 - Survival 生存
	Mage 
	62 - Arcane 秘法
	63 - Fire 火焰
	64 - Frost 冰霜
	Monk 
	268 - BrewMaster 釀酒(坦)
	269 - WindWalker 風行(近戰DD)
	270 - MistWeaver 織霧(治療)
	Paladin 
	65 - Holy ???t 神聖
	66 - Protection 防護
	70 - Retribution 懲戒
	Priest 
	256 Discipline 戒律
	257 Holy  神聖
	258 Shadow  暗影
	Rogue 
	259 - Assassination 刺殺 
	260 - Combat 戰鬥
	261 - Subtlety 敏銳
	Shaman 
	262 - Elemental 元素
	263 - Enhancement 增強
	264 - Restoration 恢復
	Warlock 
	265 - Affliction 痛苦
	266 - Demonology 惡魔
	267 - Destruction 毀滅
	Warrior
	71 - Arms 武器
	72 - Furry 狂暴
	73 - Protection 防護
--]]
function G:PlayerSpecPower_Update()
	local EA_SpecPower = EA_SpecPower
	local p,tblPower
	local pairs = pairs 
	for p,tblPower in pairs(EA_SpecPower) do
		if (tblPower) then
			tblPower.has = false
		end
	end
	--local id,_,_,icon,_,_ = GetSpecializationInfo(GetActiveSpecGroup())
	local id = 0
	local icon = "NONE"
	local powerType = 0
	local powerTypeString = "NONE"
	local pClass = "NONE"
	--取得當前職業專精索引(1~3或4)
	local CurrentSpecCode = GetSpecialization and GetSpecialization() 
	
	--若無職業專精索引表示尚未啟用任一專精
	--若有，則將此索引傳入GetSpecializationInfo()來取得全職業專精唯一代碼
	if CurrentSpecCode then id,_,_,icon,_,_ = GetSpecializationInfo(CurrentSpecCode) end
	
	--取得玩家當前形態的特殊資源
	powerType, powerTypeString = UnitPowerType("player")
	
	--取得玩家職業
	_,pClass = UnitClass("player")
	
	--取得玩家姿態或形態
	local shapeindex = GetShapeshiftForm()
	local shapeID = GetShapeshiftFormID()
	--若玩家為法師、牧師、術士、德魯伊、聖騎、薩滿表示有法力值
	if 	(pClass == EA_CLASS_MAGE) 		or
		(pClass == EA_CLASS_WARLOCK) 	or
		(pClass == EA_CLASS_DRUID)		or
		(pClass == EA_CLASS_PALADIN) 	or
		(pClass == EA_CLASS_PRIEST)		or
		(pClass == EA_CLASS_EVOKER) 	or
		(pClass == EA_CLASS_SHAMAN)		or
		--WOW 4.0開始獵人取消法力值, 以集中值代替
		(pClass == EA_CLASS_HUNTER and G.WOW_VERSION < 40000)
	then 
		EA_SpecPower.Mana.has = true 
	end
	
	--若玩家為獵人表示有快樂值
	-- if (pClass == EA_CLASS_HUNTER) then
		-- EA_SpecPower.Happiness.has = true
	-- end
	
	--若玩家為戰士表示有怒氣
	if (pClass == EA_CLASS_WARRIOR) then EA_SpecPower.Rage.has = true 	end
	
	--若玩家為德魯伊表示有怒氣
	if (pClass == EA_CLASS_DRUID) 	then EA_SpecPower.Rage.has = true	end
	
	--若玩家為獵人且版本大於等於4.0表示有集中值
	if (pClass == EA_CLASS_HUNTER and G.WOW_VERSION >= 40000) then	
		EA_SpecPower.Focus.has = true
	end
	--若玩家為盜賊表示有能量
	if (pClass == EA_CLASS_ROGUE) then 	EA_SpecPower.Energy.has = true end
	
	--若玩家為德魯伊表示有能量
	if (pClass == EA_CLASS_DRUID) then	EA_SpecPower.Energy.has = true	end
	
	--若玩家為風行武僧表示有能量
	if (pClass == EA_CLASS_MONK) then
		--釀酒或風行擁有能量條
		if (id == 268) or (id==269) then 
			EA_SpecPower.Energy.has = true
		else
			EA_SpecPower.Energy.has = false
		end
		--7.0只有風僧有真氣
		if (id == 269) then EA_SpecPower.Chi.has = true end
	end
	
	--若玩家為死騎，則表示有符文及符能
	if (pClass == EA_CLASS_DK) then
		EA_SpecPower.RunicPower.has = true
		EA_SpecPower.Runes.has = true
		if (id == 250 ) then EA_RUNE_TYPE = RUNETYPE_BLOOD end
		if (id == 251 ) then EA_RUNE_TYPE = RUNETYPE_FROST end
		if (id == 252 ) then EA_RUNE_TYPE = RUNETYPE_UNHOLY end				
	end
	
	--7.0開始三系術士資源均統一為靈魂碎片
	if (id == 265) then  EA_SpecPower.SoulShards.has = true	end
	if (id == 266) then EA_SpecPower.SoulShards.has = true 	end
	if (id == 267) then EA_SpecPower.SoulShards.has = true 	end	
	
	--若玩家為德魯伊且專精是平衡，則表示有星能
	if (id == 102) then 
		EA_SpecPower.LunarPower.has = true
	end
	
	--若玩家為聖騎，則表示有聖能
	if (pClass == EA_CLASS_PALADIN) then 
		EA_SpecPower.HolyPower.has = true
	end
	
	--若玩家為盜賊表示擁有連擊點數
	if (pClass == EA_CLASS_ROGUE) then
		EA_SpecPower.ComboPoints.has = true
	end
	
	--若玩家為德魯伊表示擁有連擊點數
	if (pClass == EA_CLASS_DRUID) then
		EA_SpecPower.ComboPoints.has = true 
	end
	
	--若玩家為恢復德魯伊表示有生命之花
	if (id == 105) then 
		EA_SpecPower.LifeBloom.has = true 
	end
	
	--若玩家為暗影牧師表示有暗影能量
	if (id == 258) then	
		EA_SpecPower.Insanity.has = true 
	end
	
	--若玩家為秘法表示有秘法充能
	if (id == 62) then
		EA_SpecPower.ArcaneCharges.has = true 
	end
	
	--若玩家為增強薩或元素薩表示有元能(漩渦值)
	if (id == 262) or (id == 263) then
		EA_SpecPower.Maelstrom.has = true 
	end	
	
	--若玩家為惡魔獵人表示有魔怒,魔痛
	if (pClass == EA_CLASS_DEMONHUNTER) then 		
		if (id == 577) or (id == 581) then
			EA_SpecPower.Fury.has = true 
		end				
	end
	
	--若玩家為喚能師表示有龍能
	if (pClass == EA_CLASS_EVOKER) then 		
		EA_SpecPower.Essence.has = true 
	end
	
	--若已學會飛龍騎術表示有活力值
	if G:IsLearnSpell(376777) then		
		EA_SpecPower.Vigor.has = true
	end
	G:SpecialFrame_Update()	
	
end

--當前角色是否已學會該法術技能
function G:IsLearnSpell(spellID)
	return GetSpellInfo(select(1, GetSpellInfo(spellID))) 
end

function G:SpecialFrame_Update()
	local type  = type
	local pairs = pairs
	local SpecPowerCheck = EA_Config.SpecPowerCheck
	local k,tblPower
	local k2,f
	
	for k,tblPower in pairs(EA_SpecPower) do
		--if (type(tblPower)=="table") and (EA_Config.SpecPowerCheck[k]) and (tblPower.has) then
		if (type(tblPower)=="table") then
			if(tblPower.frameindex) then
				for k2,f in pairs(tblPower.frameindex) do					
					if ( f and (SpecPowerCheck[k]) and (tblPower.has) ) then						
						CreateFrames_SpecialFrames_Show(f)				
					else
						CreateFrames_SpecialFrames_Hide(f)
					end
				end
			end			
		end		
	end
	--G:PositionFrames()
end
--取得法術ID在指定單位身上的BUFF索引
function G:GetBuffIndexOfSpellID(unit, SID)
	
	local UnitBuff = UnitBuff
	
	local 	name, icon, count, debuffType, duration, expirationTime, unitCaster, 
			isStealable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff, 
			_, nameplateShowAll, timeMod, value1, value2, value3 
			
	local i
	for i=1,40 do
			
			name, icon, count, debuffType, duration, expirationTime, unitCaster, 
			isStealable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff, 
			_, nameplateShowAll, timeMod, value1, value2, value3 = UnitBuff(unit,i)
			
			if (SID == spellID)	then 
				return(i)
			end
	end
	return(nil)
end
--取得法術ID在指定單位身上的DEBUFF索引
function G:GetDebuffIndexOfSpellID(unit,SID)

	local 	UnitDebuff = UnitDebuff
	
	local 	name, icon, count, debuffType, duration, expirationTime, 
			unitCaster, isStealable, nameplateShowPersonal, spellID, 
			canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod, 
			value1, value2, value3
			
	local 	i	
	for i=1,40 do
		name, icon, count, debuffType, duration, expirationTime, 
		unitCaster, isStealable, nameplateShowPersonal, spellID, 
		canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod, 
		value1, value2, value3  = UnitDebuff(unit,i)
		
		if (SID == spellID)	then 
			return(i)
		end
	end
	return(nil)
end
--在指定框架增加一個隨鼠標顯示的當前光環內容說明
function G:FrameAppendAuraTip(eaf, unit, SID, gsiIsDebuff)
	if EA_Config.ICON_APPEND_SPELL_TIP==false then		
		eaf:EnableMouse(false)
		eaf:SetScript("OnEnter",nil)
		eaf:SetScript("OnLeave",nil)
		return
	end
	local index
	if not(gsiIsDebuff) then
		index=G:GetBuffIndexOfSpellID(unit,SID)
	else		
		index=G:GetDebuffIndexOfSpellID(unit,SID)			
	end	
	if (index) then
		eaf:EnableMouse(true)
		eaf:SetScript("OnEnter",function()
									GameTooltip:SetOwner(eaf,"ANCHOR_RIGHT")
									if not(gsiIsDebuff) then
										GameTooltip:SetUnitBuff(unit,index)
									else
										GameTooltip:SetUnitDebuff(unit,index)
									end
								end
					)
		eaf:SetScript("OnLeave",function()
									GameTooltip:Hide()
								end
				)							
	end
end
--在指定框架增加一個隨鼠標顯示的技能說明
function G:FrameAppendSpellTip(eaf,spellID)
	if EA_Config.ICON_APPEND_SPELL_TIP==false then		
		eaf:EnableMouse(false)
		eaf:SetScript("OnEnter",nil)
		eaf:SetScript("OnLeave",nil)
		return
	end
	eaf:EnableMouse()
	eaf:SetScript("OnEnter",function()
							GameTooltip:SetOwner(eaf,"ANCHOR_RIGHT")
							GameTooltip:SetSpellByID(spellID)
							end
				)
	eaf:SetScript("OnLeave",function()
							GameTooltip:Hide()
							end
				)				
end
-----------------------------------------------------------------
function G:RemoveAllScdCurrentBuff()
	local GetSpellInfo = GetSpellInfo
	local GetSpellTexture = GetSpellTexture
	local tonumber = tonumber
	local SpellName, SpellIcon, HasSpell
	local eaf
	local spellID
	local i,k,v 
	
	for i,v in ipairs(EA_ScdCurrentBuffs) do
		SpellName,SpellIcon = GetSpellInfo(v),GetSpellTexture(v)
		HasSpell=GetSpellInfo(SpellName)
		if HasSpell==nil then
			eaf = _G[tconcat({"EAScdFrame_",v})]
			spellID = tonumber(v)
			-- eaf:Hide()//
			G:removeBuffValue(EA_ScdCurrentBuffs, spellID)
			-- removeBuffValue(EA_ScdCurrentBuffs,v)
			-- eaf:SetScript("OnUpdate", nil)			
			Lib_ZYF:StopOnUpdate(eaf)

		end
	end
end

function G:RemoveSingleSCDCurrentBuff(spellID)
		local SpellName, SpellIcon = GetSpellInfo(spellID), GetSpellTexture(spellID)
		local HasSpell=GetSpellInfo(SpellName)
		--if HasSpell==nil then
			local eaf = _G["EAScdFrame_"..spellID]
			local spellID = tonumber(spellID)
			eaf:Hide()
			G:removeBuffValue(EA_ScdCurrentBuffs, spellID)
			Lib_ZYF:StopOnUpdate(eaf)			
		--end	
end
-----------------------------------------------------------------
function ShowAllScdCurrentBuff()
			
	if EA_flagAllHidden == true then 
		EA_Main_Frame:SetAlpha(0) 
		return 
	else
		EA_Main_Frame:SetAlpha(1) 
	end
	
	local GetSpellInfo = GetSpellInfo
	local GetSpellTexture = GetSpellTexture
		
	local eaf
	local i
	local spellID
	
	for i,spellID in ipairs(EA_ScdCurrentBuffs) do
	
		eaf = _G[tconcat({"EAScdFrame_",spellID})]
		
		eaf:Show()
		
		if eaf.cooldown then eaf.cooldown:Show() end
		
	end
end
-----------------------------------------------------------------
function HideAllScdCurrentBuff()
		
	local GetSpellInfo = GetSpellInfo
	local GetSpellTexture = GetSpellTexture
	local ipairs = ipairs
	local i
	local spellID
	local eaf
	for i, spellID in ipairs(EA_ScdCurrentBuffs) do
		
		eaf = _G[tconcat({"EAScdFrame_",spellID})]		
		
		eaf:Hide()
		if eaf.cooldown then 
			eaf.cooldown:SetCooldown(0,0)
			eaf.cooldown:Hide()
		end
	end
end
-----------------------------------------------------------------
function FrameShowOrHide(f,boolShow)
	if boolShow then
		f:Show()
	else
		f:Hide()
	end
end
-----------------------------------------------------------------
--ButtonGlow_Start(frame[, color[, frequency]]])
-- Starts glow over target frame with set parameters:
--
--frame - target frame to set glowing
--color - {r,g,b,a}, color of particles and opacity, from 0 to 1. Defaul value is {0.95, 0.95, 0.32, 1}
--frequency - frequency. Default value is 0.125
--
--ButtonGlow_Stop(frame)
--Stops glow over target frame
function G:FrameGlowShowOrHide(eaf, boolShow)
	
	if eaf==nil then return end
	
	local GlowStart = LibStub("LibCustomGlow-1.0").ButtonGlow_Start
	local GlowStop  = LibStub("LibCustomGlow-1.0").ButtonGlow_Stop
	
	if boolShow then
		
		if (eaf.overgrow==nil) or (eaf.overgrow==false) then			
			--LibStub("LibCustomGlow-1.0").PixelGlow_Start(eaf,{0.95,0.95,0.32,1.0},8,0.125,8,4,0,0,true)
			GlowStart(eaf, {0.95, 0.95, 0.5, 1}, 1/8)
			eaf.overgrow = true		
		end
	else
		if (eaf.overgrow) then
			--LibStub("LibCustomGlow-1.0").PixelGlow_Stop(eaf)
			GlowStop(eaf)
			eaf.overgrow = false
		end
	end
end
-----------------------------------------------------------------
function EA_IfPrint(flag,...)
	if (flag) then
		print(...)
	end
end




EA_EventList_COMBAT_LOG_EVENT_UNFILTERED = {
		["SPELL_AURA_REFRESH"]			= G.COMBAT_LOG_EVENT_SPELL_AURA_REFRESH,
		["SPELL_SUMMON"]				= G.COMBAT_LOG_EVENT_SPELL_SUMMON,
		["SPELL_CAST_SUCCESS"]			= G.COMBAT_LOG_EVENT_SPELL_CAST_SUCCESS,
}
-----------------------------------------------------------------

-----------------------------------------------------------------

EA_SpecPower = {
				Mana 			= 	{
									powerId = Enum.PowerType.Mana,
									powerType = "MANA",									
									func = G.UpdateSinglePower,									
									has,
									frameindex = {1000000 + 10 * Enum.PowerType.Mana},
									
									},
				Rage 			= 	{										    
									powerId = Enum.PowerType.Rage,
									powerType = "RAGE",
									func = G.UpdateSinglePower,									
									has,
									frameindex = {1000000 + 10 * Enum.PowerType.Rage},
									},
				Focus 			= 	{
									powerId = Enum.PowerType.Focus,
									powerType = "FOCUS",
									--func=G:UpdateSinglePower,									
									func = G.UpdateFocus,
									has,
									frameindex = {
										1000000 + 10 * Enum.PowerType.Focus, 
										1000000 + 10 * Enum.PowerType.Focus + 1,
										},
									},
				Energy	 		= 	{
									powerId = Enum.PowerType.Energy,
									powerType = "ENERGY",
									func = G.UpdateSinglePower,
									has,
									frameindex = {1000000 + 10 * Enum.PowerType.Energy},
									},
				-- Happiness	 		= 	{
									-- powerId = Enum.PowerType.Happiness,
									-- powerType = "HAPPINESS",
									-- func = G.UpdateSinglePower,
									-- has,
									-- frameindex = {1000000 + 10 * Enum.PowerType.Happiness},
									-- },
				ComboPoints		=   {
									powerId = Enum.PowerType.ComboPoints,
									powerType = "COMBO_POINTS",
									func = G.UpdateComboPoints,
									has,
									frameindex = {1000000 + 10 * Enum.PowerType.ComboPoints},
									--frameindex = {1000000},
									},		
				Runes 			= 	{
									powerId = Enum.PowerType.Runes,
									powerType = "RUNES",
									func = G.UpdateRunes,									
									--func = G.UpdateSinglePower,
									has,
									frameindex={
												[0] = 1000000 + 10 * Enum.PowerType.Runes + 0,
												[1] = 1000000 + 10 * Enum.PowerType.Runes + 1,
												[2] = 1000000 + 10 * Enum.PowerType.Runes + 2,
												[3] = 1000000 + 10 * Enum.PowerType.Runes + 3,
												[4] = 1000000 + 10 * Enum.PowerType.Runes + 4,
												[5] = 1000000 + 10 * Enum.PowerType.Runes + 5,
												[6] = 1000000 + 10 * Enum.PowerType.Runes + 6,												
												},									
									},
				RunicPower		= 	{
									powerId = Enum.PowerType.RunicPower,
									powerType = "RUNIC_POWER",
									func = G.UpdateSinglePower,									
									has,
									frameindex = {1000000 + 10 * Enum.PowerType.RunicPower},
									},
				SoulShards		= 	{
									powerId = Enum.PowerType.SoulShards,
									powerType = "SOUL_SHARDS",
									func = G.UpdateSinglePower,									
									has,
									frameindex = {1000000 + 10 * Enum.PowerType.SoulShards},
									},
				LunarPower			= 	{
									powerId = Enum.PowerType.LunarPower,									
									powerType = "LUNAR_POWER",
									func = G.UpdateSinglePower,									
									has,
									frameindex = {1000000 + 10 * Enum.PowerType.LunarPower},
									},
				HolyPower		= 	{
									powerId = Enum.PowerType.HolyPower,
									powerType = "HOLY_POWER",
									func = G.UpdateSinglePower,									
									has,
									frameindex = {1000000 + 10 * Enum.PowerType.HolyPower},
									},
				Maelstrom		= 	{
									powerId = Enum.PowerType.Maelstrom,
									powerType = "MAELSTROM",
									func = G.UpdateSinglePower,									
									has,
									frameindex = {1000000 + 10 * Enum.PowerType.Maelstrom},
									},
				Chi				= 	{
									powerId = Enum.PowerType.Chi,
									powerType = "CHI",
									func = G.UpdateSinglePower,
									has,
									frameindex = {1000000 + 10 * Enum.PowerType.Chi},
									},
				Insanity		= 	{
									powerId = Enum.PowerType.Insanity,									
									powerType = "INSANITY",
									func = G.UpdateSinglePower,									
									has,
									frameindex = {1000000 + 10 * Enum.PowerType.Insanity},
									},
				ArcaneCharges		= 	{
									powerId = Enum.PowerType.ArcaneCharges,
									powerType = "ARCANE_CHARGES",
									func = G.UpdateSinglePower,									
									has,
									frameindex = {1000000 + 10 * Enum.PowerType.ArcaneCharges},
									},			
				Fury			= 	{
									powerId = Enum.PowerType.Fury,
									powerType = "FURY",
									func = G.UpdateSinglePower,									
									has,
									frameindex = {1000000 + 10 * Enum.PowerType.Fury},
									},
				Pain			= 	{
									powerId = Enum.PowerType.Pain,
									powerType = "PAIN",
									func=G.UpdateSinglePower,									
									has,
									frameindex = {1000000 + 10 * Enum.PowerType.Pain},
									},		
				Essence			= 	{
									powerId = Enum.PowerType.Essence,
									powerType = "ESSENCE",
									func=G.UpdateSinglePower,									
									has,
									frameindex = {1000000 + 10 * Enum.PowerType.Essence},
									},											
				Vigor			= 	{
									powerId,
									powerType = "",
									func = G.UpdateVigor,									
									has,
									frameindex = {362777},
									},
									
				LifeBloom		= 	{
									powerId,
									powerType = "",
									func = G.UpdateLifeBloom,									
									has,
									frameindex = {33763},
									},
									
				}