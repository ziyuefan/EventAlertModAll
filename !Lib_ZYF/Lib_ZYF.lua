----------------------------------------------------
-- Assign addon space to local G var.  
-- For sync addon space to each lua fils
-----------------------------------------------------
local _
local _G = _G
local addonName, G = ... 
_G[addonName] = _G[addonName] or G
-----------------------------------

---------
if Lib_ZYF then 
	return 
else
	Lib_ZYF = {}
end

---------
local print = print
local type = type
local pairs = pairs
local ipairs = ipairs 
local tonumber = tonumber
local strmatch = string.match
local CreateFrame = CreateFrame 
local GetLocale = GetLocale
local GetSpellDescription = GetSpellDescription

---------停止某個定時更新的frame,並清除frame
function Lib_ZYF:ClrOnUpdate(frame)
---------
	if frame then
		frame:SetScript("OnUpdate",nil)
		frame = nil		
	end
end

--------停止某個定時更新的frame
function Lib_ZYF:StopOnUpdate(frame)
---------
	if frame then
		frame:SetScript("OnUpdate",nil)	
	end
end

---------設定定時更新某個函式
function Lib_ZYF:SetOnUpdate(sec, callback, ...)
---------
	local arg = ...
	local DummyFrame = CreateFrame("Frame","ZYFOnUpdate_"..sec.."_"..GetTime())
	local SinceUpdateTime = 0
	local flagRunning = false
	
	DummyFrame:SetScript("OnUpdate",function(self, elapsedTime)
		SinceUpdateTime = SinceUpdateTime + elapsedTime
		
		if SinceUpdateTime >= sec then 
			if flagRunning == false then
				if (type(callback) == "function")  then
					flagRunning_SetOnUpdate = true
					callback(arg)
					flagRunning_SetOnUpdate = false
				end
			end
			SinceUpdateTime = 0
		end
	end)
	return DummyFrame
end
---------指定FRAME定時更新某個函式
function Lib_ZYF:FrameSetOnUpdate(frame, sec, callback, ...)
---------
	if frame == nil then return end
	
	local SinceUpdateTime = 0
	local arg = ...
	local flagRunning = false
	
	frame:SetScript("OnUpdate", function(self, elapsedTime)
		SinceUpdateTime = SinceUpdateTime + elapsedTime
	
		if SinceUpdateTime >= sec then 			
			if flagRunning == false then
				if type(callback) == "function" then
					flagRunning = true
					callback(frame, arg)
					flagRunning = false
				end
				SinceUpdateTime = 0
			end
		end
	end)
	return frame
end
---------設定定時更新某個函式幾次
function Lib_ZYF:SetOnUpdateTimes(sec, times, callback, ...)
---------
	local arg = ...
	local DummyFrame = CreateFrame("Frame","ZYFOnUpdateTimes_"..sec.."_"..times.."_"..GetTime())
	local SinceUpdateTime = 0
	local UpdateTimes = 0	
	local flagRunning = false
	
	DummyFrame:SetScript("OnUpdate", function(self, elapsedTime)
		SinceUpdateTime = SinceUpdateTime + elapsedTime
		
		if SinceUpdateTime >= sec then 			
			if flagRunning == false then
				if type(callback) == "function" then
					flagRunning = true
					callback(arg)
					flagRunning = false
				end
				SinceUpdateTime = 0
			
				UpdateTimes = UpdateTimes + 1
				if UpdateTimes >= times then
					Lib_ZYF:ClrOnUpdate(DummyFrame)
				end
			end
		end
	end)
	return DummyFrame
end
---------指定FRAME定時更新某個函式幾次
function Lib_ZYF:FrameSetOnUpdateTimes(frame, sec, times,callback, ...)
---------
	if frame == nil then return end
	
	local SinceUpdateTime = 0
	local UpdateTimes = 0
	local arg = ...
	local flagRunning = false
	
	frame:SetScript("OnUpdate" ,function(self, elapsedTime)
		SinceUpdateTime = SinceUpdateTime + elapsedTime
		
		if flagRunning == false then
			if SinceUpdateTime >= sec then 			
				if (type(callback) == "function") and (flagRunning == false) then
					flagRunning = true
					callback(frame, arg)
					flagRunning = false
				end
				SinceUpdateTime = 0
			
				UpdateTimes = UpdateTimes + 1
				if UpdateTimes >= times then
					self:StopOnUpdate(frame)
				end
			end
		end
	end)
	return frame
end
---------設定幾秒後執行某個函式一次
function Lib_ZYF:SetOnUpdateOnce(sec, callback, ...)
---------
	local arg = ...
	local DummyFrame = CreateFrame("Frame","ZYFOnUpdateOnce_"..GetTime())
	local SinceUpdateTime = 0   	
	
	DummyFrame:SetScript("OnUpdate",function(self,elapsedTime)
		SinceUpdateTime = SinceUpdateTime + elapsedTime
		
		if SinceUpdateTime >= sec then 			
			if type(callback) == "function" then
				callback(arg)
			end
			SinceUpdateTime = 0
			self:ClrOnUpdate(DummyFrame)
		end
	end)
	return DummyFrame
end

---------指定FRAME幾秒後執行某個函式一次
function Lib_ZYF:FrameSetOnUpdateOnce(frame, sec,callback,...)
---------
	if frame == nil then return end
	
	local arg = ...
	local SinceUpdateTime = 0
	
	frame:SetScript("OnUpdate",function(self,elapsedTime)
		SinceUpdateTime = SinceUpdateTime + elapsedTime
		
		if SinceUpdateTime >= sec then 			
			if type(callback) == "function" then
				callback(frame, arg)
			end
			SinceUpdateTime = 0
			self:StopOnUpdate(frame)
		end
	end)
	return frame
end
---------設定事件要執行的函式
Lib_ZYF.Events = {}
function Lib_ZYF:SetEvent(event, callback, ...)
---------
	local arg = ...	
	local t = Lib_ZYF		
	local f = CreateFrame("Frame","ZYFCombatEvent_"..GetTime())
	f:RegisterEvent(event)
	f:SetScript("OnEvent",callback,arg)
	--Lib_ZYF.Events[#Lib_ZYF.Events + 1] = f
	table.insert(t.Events, f)
	return f
end

---------設定戰鬥事件要執行的函式(模擬RegisterCombatEvent)
Lib_ZYF.CombatEvents = {}
function Lib_ZYF:SetCombatLogEvent(subEvent,callback,...)
---------
	local arg = ...
	local idx	
	local t = Lib_ZYF		
	t.CombatEvents[subEvent] = t.CombatEvents[subEvent] or {}
	
	--idx = #Lib_ZYF.CombatEvents[subEvent] + 1
	--self.CombatEvents[subEvent][idx] = callback
	table.insert(t.CombatEvents[subEvent], callback)
	
end
---------
Lib_ZYF:SetEvent("COMBAT_LOG_EVENT_UNFILTERED", function()
---------		
		local 	t = Lib_ZYF		
		local 	tmp = CombatLogGetCurrentEventInfo()	
		local 	timestp, event, hideCaster, 
				surGUID, surName, surFlags, surRaidFlags, 
				dstGUID, dstName, dstFlags, dstRaidFlags, 
				spellID, spellName = tmp	
		
		if t.CombatEvents[event] then
			for i, func in ipairs(t.CombatEvents[event]) do 
				if func and type(func) == "function" then 
					-- func(CombatLogGetCurrentEventInfo())
					func(tmp)
				end				
			end
		end
	end)

---------------------------------------------
--定時更新玩家座標並儲存,供其他函式取用
---------------------------------------------
Lib_ZYF.map = {}
Lib_ZYF.map.ID = nil
Lib_ZYF.map.PosObject = nil
Lib_ZYF.map.PositionX = 0
Lib_ZYF.map.PositionY = 0
Lib_ZYF.map.subZoneText = ""
Lib_ZYF.map.zoneText = ""
function Lib_ZYF:UpdatePlayerPosition()

	local t = Lib_ZYF
	--local t = self
	
	t.map.subZoneText = _G.GetSubZoneText() or ""
	t.map.zoneText = _G.GetRealZoneText() or ""
	
	t.map.ID = _G.C_Map.GetBestMapForUnit("player")
	if (t.map.ID == nil) then
		return
	end
	
	t.map.PosObject = _G.C_Map.GetPlayerMapPosition(t.map.ID, "player" )
	if (t.map.PosObject) then        
		t.map.PositionX, t.map.PositionY = t.map.PosObject:GetXY()
		--print(Lib_ZYF.zoneText,":",Lib_ZYF.subZoneText,format("(%.1f",Lib_ZYF.mapPositionX*100),format(", %.1f)",Lib_ZYF.mapPositionY*100))
	end

	if (t.map.PositionX == nil) then
		t.map.PositionX = 0
	end
	if (t.map.PositionY == nil) then
		t.map.PositionY = 0
	end
	
end	
---------------------------------------------
--每10秒儲存一次玩家當前座標及區域資訊	
---------------------------------------------
Lib_ZYF:SetOnUpdate(10, Lib_ZYF.UpdatePlayerPosition)

---------------------------------------------
--依據儲存的資訊回傳座標
---------------------------------------------
function Lib_ZYF:GetPlayerPosition()
	local t = Lib_ZYF
	--local t = self
	return {t.map.PositionX, t.map.PositionY}	
end

---------------------------------------------
--依據儲存的資訊回傳當前地區
---------------------------------------------
function Lib_ZYF:GetPlayerZone()
	local t = Lib_ZYF
	--local t = self
	return t.map.zoneText
end

---------------------------------------------
--依據儲存的資訊回傳當前子區域
---------------------------------------------
function Lib_ZYF:GetPlayerSubZone()
	local t = Lib_ZYF
	--local t = self
	return t.map.subZoneText
end

---------------------------------------------
-- SetBackdrop for Shadowland version 
---------------------------------------------
function Lib_ZYF:SetBackdrop(frame, backdropInfo)
	
	if backdropInfo == nil then
		frame.Backdrop = nil
		return nil
	end
	local frameLevel = (frame:GetFrameLevel() > 1) and frame:GetFrameLevel() or 2
	
	if frame.Backdrop == nil then
		frame.Backdrop = CreateFrame("Frame", nil,frame, "BackdropTemplate")		
		frame.Backdrop:SetFrameLevel(frameLevel - 1)		
		frame.Backdrop:SetAllPoints()
	end
		
	frame.Backdrop.backdropInfo = backdropInfo
	frame.Backdrop:ApplyBackdrop()
	
	if frame.Backdrop then return frame.Backdrop end
end

function Lib_ZYF:SetBackdropColor(frame,r,g,b,a)
	local frameLevel = (frame:GetFrameLevel() > 1) and frame:GetFrameLevel() or 2
	if frame.Backdrop == nil then
		frame.Backdrop = CreateFrame("Frame", nil, frame, "BackdropTemplate")
		frame.Backdrop:SetFrameLevel(frameLevel - 1)
		frame.Backdrop:SetAllPoints()
	end		
	frame.Backdrop:SetBackdropColor(r, g, b, a)	
	if frame.Backdrop then return frame.Backdrop end
end

function Lib_ZYF:SetBackdropBorderColor(frame,r,g,b,a)
	local frameLevel = (frame:GetFrameLevel() > 1) and frame:GetFrameLevel() or 2
	if frame.Backdrop == nil then
		frame.Backdrop = CreateFrame("Frame", nil, frame, "BackdropTemplate")
		frame.Backdrop:SetFrameLevel(frameLevel - 1)
		frame.Backdrop:SetAllPoints()
	end		
	frame.Backdrop:SetBackdropBorderColor(r, g, b, a)	
	if frame.Backdrop then return frame.Backdrop end
end

function Lib_ZYF:ReleaseBackdrop(frame)
	if frame.Backdrop then
		frame.Backdrop = nil
	else
		print("Frame "..frame:GetName().." have no backdrop")
	end
end

---------------------------------------------
-- Get Spell Time From GetSpellDescription()
---------------------------------------------
Lib_ZYF.SpellDurationByDesc = {}
Lib_ZYF.SpellDurationByDesc["zhTW"] = {
	{pattern = "在%d+%p?%d*秒",		mul=1},
	{pattern = "持續%d+%p?%d*秒",	mul=1},
	{pattern = "%d+%p?%d*秒內",		mul=1},
	{pattern = "效力%d+%p?%d*秒",	mul=1},
	
	{pattern = "在%d+%p?%d*分", 		mul=60},
	{pattern = "持續%d+%p?%d*分",	mul=60},
	{pattern = "%d+%p?%d*分內", 		mul=60},
	{pattern = "效力%d+%p?%d*分", 	mul=60},
	
	{pattern = "在%d+%p?%d*小時", 	mul=3600},
	{pattern = "持續%d+%p?%d*小時",	mul=3600},
	{pattern = "%d+%p?%d*小時內", 	mul=3600},
	{pattern = "效力%d+%p?%d*小時", 	mul=3600},
}
Lib_ZYF.SpellDurationByDesc["zhCN"] = {
	{pattern = "在%d+%p?%d*秒", 		mul=1},
	{pattern = "持续%d+%p?%d*秒",	mul=1},
	{pattern = "%d+%p?%d*秒内",		mul=1},
	{pattern = "效力%d+%p?%d*秒",	mul=1},
	
	{pattern = "在%d+%p?%d*分",		mul=60},
	{pattern = "持续%d+%p?%d*分",	mul=60},
	{pattern = "%d+%p?%d*分内",		mul=60},
	{pattern = "效力%d+%p?%d*分", 	mul=60},
	
	{pattern = "在%d+%p?%d*小时",	mul=3600},
	{pattern = "持续%d+%p?%d*小时",	mul=3600},
	{pattern = "%d+%p?%d*小时内",	mul=3600},	
	{pattern = "效力%d+%p?%d*小時", 	mul=3600},
}
Lib_ZYF.SpellDurationByDesc["enUS"] = {
	{pattern = "for %d+%p?%d* sec",			mul=1},
	{pattern = "lasts %d+%p?%d* sec",		mul=1},
	{pattern = "for up to %d+%p?%d* sec",	mul=1},
	
	{pattern = "for %d+%p?%d* min",			mul=60},
	{pattern = "lasts %d+%p?%d* min",		mul=60},
	{pattern = "for up to %d+%p?%d* min",	mul=60},
	
	{pattern = "for%d+%p?%d* hour",			mul=3600},
	{pattern = "lasts%d+%p?%d* hour",		mul=3600},
	{pattern = "for up to %d+%p?%d* hour",	mul=3600},	
}
Lib_ZYF.SpellDurationByDesc["koKR"] = {
	{pattern = "for %d+%p?%d* sec",			mul=1},
	{pattern = "lasts %d+%p?%d* sec",		mul=1},
	{pattern = "for up to %d+%p?%d* sec",	mul=1},
	
	{pattern = "for %d+%p?%d* min",			mul=60},
	{pattern = "lasts %d+%p?%d* min",		mul=60},
	{pattern = "for up to %d+%p?%d* min",	mul=60},
	
	{pattern = "for%d+%p?%d* hour",			mul=3600},
	{pattern = "lasts%d+%p?%d* hour",		mul=3600},
	{pattern = "for up to %d+%p?%d* hour",	mul=3600},	
}

function Lib_ZYF:GetSpellDurationByDesc(spellID)	
	local t = Lib_ZYF
	--local t = self
	
	local spellDescription = GetSpellDescription(spellID)			
	local strSpellDuration
	local numSpellDuration			
	local SpellDurationByDesc = t.SpellDurationByDesc[GetLocale()]
	
	local p
		
	for _, p in ipairs(SpellDurationByDesc) do 
		strSpellDuration = strmatch(spellDescription, p.pattern)				
		if strSpellDuration then		
			numSpellDuration = tonumber(strmatch(strSpellDuration,"%d+%p?%d*")) * p.mul
			return numSpellDuration			
		end
	end			
	return 0
end		

----------------------------------------------
-- 
----------------------------------------------

----------------------------------------------
-- 
----------------------------------------------

----------------------------------------------
-- 
----------------------------------------------


