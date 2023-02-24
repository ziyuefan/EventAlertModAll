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
function EventAlert_Icon_Options_Frame_OnLoad()
	-- UIPanelWindows["EA_Icon_Options_Frame"] = {area = "center", pushable = 0}
	Lib_ZYF:SetBackdrop(EA_Icon_Options_Frame, {bgFile="interface/dialogframe/ui-dialogbox-gold-background", 
											   edgeFile="interface/dialogframe/ui-dialogbox-gold-border", 
											   tile = true, 	
											   tileSize = 32, 
											   edgeSize = 32, 
											   insets = { left = 11, right = 12, top = 11, bottom = 11, },
											  })
	-- Lib_ZYF:SetBackdropColor(EA_Icon_Options_Frame, 1, 1, 1, 2/1)
	-- Lib_ZYF:SetBackdropBorderColor(EA_Icon_Options_Frame, 1, 1, 1, 1)
end

function EventAlert_Icon_Options_Frame_Init()
	EA_Icon_Options_Frame_LockFrame:SetChecked(EA_Config.LockFrame)
	EA_Icon_Options_Frame_ShareSettings:SetChecked(EA_Config.ShareSettings)
	EA_Icon_Options_Frame_IconSize:SetValue(EA_Config.IconSize)
	EA_Icon_Options_Frame_IconXOffset:SetValue(EA_Position.xOffset)
	EA_Icon_Options_Frame_IconYOffset:SetValue(EA_Position.yOffset)
	EA_Icon_Options_Frame_IconRedDebuff:SetValue((EA_Position.RedDebuff * 100) - 50)
	EA_Icon_Options_Frame_IconGreenDebuff:SetValue((EA_Position.GreenDebuff * 100) - 50)
	EA_Icon_Options_Frame_IconExecution:SetValue(EA_Position.Execution)
	EA_Icon_Options_Frame_PlayerLv2BOSS:SetChecked(EA_Position.PlayerLv2BOSS)
	EA_Icon_Options_Frame_SCD_UseCooldown:SetChecked(EA_Position.SCD_UseCooldown)
	EA_Icon_Options_Frame_SpecFlag_HolyPower:SetChecked(EA_Config.SpecPowerCheck.HolyPower)
	EA_Icon_Options_Frame_SpecFlag_RunicPower:SetChecked(EA_Config.SpecPowerCheck.RunicPower)
	EA_Icon_Options_Frame_SpecFlag_Runes:SetChecked(EA_Config.SpecPowerCheck.Runes)
	EA_Icon_Options_Frame_SpecFlag_SoulShards:SetChecked(EA_Config.SpecPowerCheck.SoulShards)
	EA_Icon_Options_Frame_SpecFlag_LunarPower:SetChecked(EA_Config.SpecPowerCheck.LunarPower)
	EA_Icon_Options_Frame_SpecFlag_ComboPoints:SetChecked(EA_Config.SpecPowerCheck.ComboPoints)
	EA_Icon_Options_Frame_SpecFlag_LifeBloom:SetChecked(EA_Config.SpecPowerCheck.LifeBloom)
	EA_Icon_Options_Frame_SpecFlag_Chi:SetChecked(EA_Config.SpecPowerCheck.Chi)
	EA_Icon_Options_Frame_SpecFlag_Energy:SetChecked(EA_Config.SpecPowerCheck.Energy)
	EA_Icon_Options_Frame_SpecFlag_Rage:SetChecked(EA_Config.SpecPowerCheck.Rage)
	EA_Icon_Options_Frame_SpecFlag_Focus:SetChecked(EA_Config.SpecPowerCheck.Focus)
	EA_Icon_Options_Frame_SpecFlag_Insanity:SetChecked(EA_Config.SpecPowerCheck.Insanity)
	--EA_Icon_Options_Frame_SpecFlag_DemonicFury:SetChecked(EA_Config.SpecPowerCheck.DemonicFury)
	--EA_Icon_Options_Frame_SpecFlag_BurningEmbers:SetChecked(EA_Config.SpecPowerCheck.BurningEmbers)
	EA_Icon_Options_Frame_SpecFlag_ArcaneCharges:SetChecked(EA_Config.SpecPowerCheck.ArcaneCharges)
	EA_Icon_Options_Frame_SpecFlag_Maelstrom:SetChecked(EA_Config.SpecPowerCheck.Maelstrom)
	EA_Icon_Options_Frame_SpecFlag_Fury:SetChecked(EA_Config.SpecPowerCheck.Fury)
	EA_Icon_Options_Frame_SpecFlag_Mana:SetChecked(EA_Config.SpecPowerCheck.Mana)	
	EA_Icon_Options_Frame_SpecFlag_Happiness:SetChecked(EA_Config.SpecPowerCheck.Happiness)
	-- EA_Icon_Options_Frame_SpecFlag_Pain:SetChecked(EA_Config.SpecPowerCheck.Pain)
	EA_Icon_Options_Frame_SpecFlag_FocusPet:SetChecked(EA_Config.SpecPowerCheck.FocusPet)
	EA_Icon_Options_Frame_SpecFlag_Essence:SetChecked(EA_Config.SpecPowerCheck.Essence)
	EA_Icon_Options_Frame_SpecFlag_Vigor:SetChecked(EA_Config.SpecPowerCheck.Vigor)
end

function EventAlert_Icon_Options_Frame_ToggleAlertFrame()
	if EA_Anchor_Frame1:IsVisible() then
		EA_Anchor_Frame1:Hide()
		EA_Anchor_Frame2:Hide()
		EA_Anchor_Frame3:Hide()
		EA_Anchor_Frame4:Hide()
		EA_Anchor_Frame5:Hide()
		EA_Anchor_Frame6:Hide()
		EA_Anchor_Frame7:Hide()
		EA_Anchor_Frame8:Hide()
		EA_Anchor_Frame9:Hide()
		EA_Anchor_Frame10:Hide()
	else
		if (EA_Config.ShowFrame == true) then
			EA_Anchor_Frame1:Show()
			EventAlert_Icon_Options_Frame_PaintAlertFrame()
		end

		if (EA_Config.ShowFlash == true) then
			UIFrameFadeIn(LowHealthFrame, 1, 0, 1)
			UIFrameFadeOut(LowHealthFrame, 2, 1, 0)
		end

		EventAlert_Icon_Options_Frame_ToggleNewLineAnchor()
		if (EA_Config.DoAlertSound == true) then
			PlaySoundFile(EA_Config.AlertSound)
		end
	end
end


function EventAlert_Icon_Options_Frame_SetAlertFrameText(eaf, spellName, toSetTextAndShow)
	if (eaf ~= nil) then
		if (toSetTextAndShow) then
			if (EA_Config.ShowName == true) then
				eaf.spellName:SetText(spellName)				
			else
				eaf.spellName:SetText("")
			end
		end

		eaf.spellTimer:ClearAllPoints()
		if (EA_Config.ShowTimer == true) then
			if (EA_Config.ChangeTimer == true) then
				eaf.spellTimer:SetPoint("CENTER", eaf, "CENTER", 0, 0)
				eaf.spellTimer:SetFont(EA_FONTS, EA_Config.TimerFontSize, "OUTLINE")
				if (toSetTextAndShow) then eaf.spellTimer:SetText("TIME\nLEFT") end
			else
				eaf.spellTimer:SetPoint("BOTTOM", eaf, "TOP", 0, 0)
				eaf.spellTimer:SetFont(EA_FONTS, EA_Config.TimerFontSize, "OUTLINE")
				if (toSetTextAndShow) then eaf.spellTimer:SetText("TIME LEFT") end
			end
		else
			if (toSetTextAndShow) then eaf.spellTimer:SetText("") end
		end

		eaf:SetWidth(EA_Config.IconSize)
		eaf:SetHeight(EA_Config.IconSize)
		if (toSetTextAndShow) then eaf:Show() end
	end
end

function EventAlert_Icon_Options_Frame_PaintAlertFrame()
	if EA_Anchor_Frame1 ~= nil then
		if EA_Anchor_Frame1:IsVisible() then
			local xOffset = 100 + EA_Position.xOffset
			local yOffset = 0 + EA_Position.yOffset

			EA_Anchor_Frame1:ClearAllPoints()
			EA_Anchor_Frame1:SetPoint(EA_Position.Anchor, EA_Position.xLoc, EA_Position.yLoc)
			EA_Anchor_Frame2:ClearAllPoints()
			EA_Anchor_Frame2:SetPoint("CENTER", EA_Anchor_Frame1, xOffset, yOffset)
			EA_Anchor_Frame3:ClearAllPoints()
			EA_Anchor_Frame3:SetPoint("CENTER", EA_Anchor_Frame1, -1 * xOffset, yOffset)
			Lib_ZYF:SetBackdropColor(EA_Anchor_Frame3,1.0, EA_Position.RedDebuff, EA_Position.RedDebuff)
			--EA_Anchor_Frame3:SetVertexColor(1.0, EA_Position.RedDebuff, EA_Position.RedDebuff)
			EA_Anchor_Frame4:ClearAllPoints()
			EA_Anchor_Frame4:SetPoint("CENTER", EA_Anchor_Frame3, -1 * xOffset, yOffset)
			Lib_ZYF:SetBackdropColor(EA_Anchor_Frame4,1.0, EA_Position.RedDebuff, EA_Position.RedDebuff)
			--EA_Anchor_Frame4:SetVertexColor(1.0, EA_Position.RedDebuff, EA_Position.RedDebuff)

			if EA_Position.Tar_NewLine then
				-- DEFAULT_CHAT_FRAME:AddMessage("\124cffFFFF00EventAlert2\124r EA_Position.Tar_NewLine = True")
				EA_Anchor_Frame5:ClearAllPoints()
				EA_Anchor_Frame5:SetPoint(EA_Position.TarAnchor, EA_Position.Tar_xOffset, EA_Position.Tar_yOffset)
				Lib_ZYF:SetBackdropColor(EA_Anchor_Frame5,EA_Position.GreenDebuff, 1.0, EA_Position.GreenDebuff)
				EA_Anchor_Frame6:ClearAllPoints()
				EA_Anchor_Frame6:SetPoint("CENTER", EA_Anchor_Frame5, xOffset, yOffset)
				--EA_Anchor_Frame6:SetBackdropColor(EA_Position.GreenDebuff, 1.0, EA_Position.GreenDebuff)
				Lib_ZYF:SetBackdropColor(EA_Anchor_Frame6,EA_Position.GreenDebuff, 1.0, EA_Position.GreenDebuff)
				EA_Anchor_Frame7:ClearAllPoints()
				EA_Anchor_Frame7:SetPoint("CENTER", EA_Anchor_Frame5, -1 * xOffset, yOffset)
				EA_Anchor_Frame8:ClearAllPoints()
				EA_Anchor_Frame8:SetPoint("CENTER", EA_Anchor_Frame7, -1 * xOffset, yOffset)
			else
				-- DEFAULT_CHAT_FRAME:AddMessage("\124cffFFFF00EventAlert2\124r EA_Position.Tar_NewLine = False")
				EA_Anchor_Frame5:ClearAllPoints()
				EA_Anchor_Frame5:SetPoint("CENTER", EA_Anchor_Frame1, -1 * xOffset, -1 * yOffset)
				Lib_ZYF:SetBackdropColor(EA_Anchor_Frame5,EA_Position.GreenDebuff, 1.0, EA_Position.GreenDebuff)
				EA_Anchor_Frame6:ClearAllPoints()
				EA_Anchor_Frame6:SetPoint("CENTER", EA_Anchor_Frame5, -1 * xOffset, -1 * yOffset)
				Lib_ZYF:SetBackdropColor(EA_Anchor_Frame6,EA_Position.GreenDebuff, 1.0, EA_Position.GreenDebuff)
				EA_Anchor_Frame7:ClearAllPoints()
				EA_Anchor_Frame7:SetPoint("CENTER", EA_Anchor_Frame6, -1 * xOffset, -1 * yOffset)
				EA_Anchor_Frame8:ClearAllPoints()
				EA_Anchor_Frame8:SetPoint("CENTER", EA_Anchor_Frame7, -1 * xOffset, -1 * yOffset)
			end

			EA_Anchor_Frame9:ClearAllPoints()
			EA_Anchor_Frame9:SetPoint("CENTER", UIParent, EA_Position.ScdAnchor, EA_Position.Scd_xOffset, EA_Position.Scd_yOffset)
			EA_Anchor_Frame10:ClearAllPoints()
			EA_Anchor_Frame10:SetPoint("CENTER", EA_Anchor_Frame9, xOffset, yOffset)

			EventAlert_Icon_Options_Frame_SetAlertFrameText(EA_Anchor_Frame1,  EA_XICON_SELF_BUFF.."(1)", true)
			EventAlert_Icon_Options_Frame_SetAlertFrameText(EA_Anchor_Frame2,  EA_XICON_SELF_BUFF.."(2)", true)
			EventAlert_Icon_Options_Frame_SetAlertFrameText(EA_Anchor_Frame3,  EA_XICON_SELF_SPBUFF, true)
			EventAlert_Icon_Options_Frame_SetAlertFrameText(EA_Anchor_Frame4,  EA_XICON_SELF_DEBUFF.."(2)", true)
			EventAlert_Icon_Options_Frame_SetAlertFrameText(EA_Anchor_Frame5,  EA_XICON_TARGET_DEBUFF.."(1)", true)
			EventAlert_Icon_Options_Frame_SetAlertFrameText(EA_Anchor_Frame6,  EA_XICON_TARGET_DEBUFF.."(2)", true)
			EventAlert_Icon_Options_Frame_SetAlertFrameText(EA_Anchor_Frame7,  EA_XICON_TARGET_SPBUFF, true)
			EventAlert_Icon_Options_Frame_SetAlertFrameText(EA_Anchor_Frame8,  EA_XICON_TARGET_BUFF.."(2)", true)
			EventAlert_Icon_Options_Frame_SetAlertFrameText(EA_Anchor_Frame9,  EA_XICON_SCD.."(1)", true)
			EventAlert_Icon_Options_Frame_SetAlertFrameText(EA_Anchor_Frame10, EA_XICON_SCD.."(2)", true)
			EA_Anchor_Frame3.spellName:SetPoint("BOTTOM", 0, -30)
			EA_Anchor_Frame7.spellName:SetPoint("BOTTOM", 0, -30)
		end
	end

	--支援聖騎聖能
	if (EA_playerClass == EA_CLASS_PALADIN) then
		-- Paladin Holy Power
		if (EA_Config.SpecPowerCheck.HolyPower) then
			EventAlert_Icon_Options_Frame_SetAlertFrameText(_G["EAFrameSpec_"..(1000000 + 10 * Enum.PowerType.HolyPower)], "", false)  
		end		
		-- Paladin Mana
		if (EA_Config.SpecPowerCheck.Mana) then
			EventAlert_Icon_Options_Frame_SetAlertFrameText(_G["EAFrameSpec_"..(1000000 + 10 * Enum.PowerType.Mana)], "", false)			
		end
		
	--支援DK符文及符能
	elseif (EA_playerClass == EA_CLASS_DK) then
		-- Death Knight Runic
		if (EA_Config.SpecPowerCheck.RunicPower) then
			EventAlert_Icon_Options_Frame_SetAlertFrameText(_G["EAFrameSpec_"..(1000000 + 10 * Enum.PowerType.RunicPower)], "", false)
		end
		-- Death Knight Runes
		if (EA_Config.SpecPowerCheck.Runes) then
			-- EventAlert_Icon_Options_Frame_SetAlertFrameText(_G["EAFrameSpec_"..(1000000 + 10 * Enum.PowerType.Runes)], "", false)
		end
		
	-- 支援德魯伊連擊點數、怒氣、能量、星能、生命之花
	elseif (EA_playerClass == EA_CLASS_DRUID) then
	
		-- Druid Mana
		if (EA_Config.SpecPowerCheck.Mana) then
			EventAlert_Icon_Options_Frame_SetAlertFrameText(_G["EAFrameSpec_"..(1000000 + 10 * Enum.PowerType.Mana)], "", false)			
		end
		
		-- Druid Combo Point
		if (EA_Config.SpecPowerCheck.ComboPoints) then
			EventAlert_Icon_Options_Frame_SetAlertFrameText(_G["EAFrameSpec_"..(1000000 + 10 * Enum.PowerType.ComboPoints)], "", false)
		end
		
		-- Druid Energy
		if (EA_Config.SpecPowerCheck.Energy) then
			EventAlert_Icon_Options_Frame_SetAlertFrameText(_G["EAFrameSpec_"..(1000000 + 10 * Enum.PowerType.Energy)], "", false)
		end
		
		-- Druid Rage
		if (EA_Config.SpecPowerCheck.Rage) then
			EventAlert_Icon_Options_Frame_SetAlertFrameText(_G["EAFrameSpec_"..(1000000 + 10 * Enum.PowerType.Rage)], "", false)
		end
		
		-- Druid Lunar Power
		if (EA_Config.SpecPowerCheck.LunarPower) then
			EventAlert_Icon_Options_Frame_SetAlertFrameText(_G["EAFrameSpec_"..(1000000 + 10 * Enum.PowerType.LunarPower)], "", false)
			-- Durid Eclipse
			-- EventAlert_Icon_Options_Frame_SetAlertFrameText(EAFrameSpec_10081, "", false)  
			-- Durid Eclipse Orange
			-- EventAlert_Icon_Options_Frame_SetAlertFrameText(EAFrameSpec_10082, "", false)                                          			
		end
		
		-- Druid LifeBloom
		if (EA_Config.SpecPowerCheck.LifeBloom) then
			EventAlert_Icon_Options_Frame_SetAlertFrameText(EAFrameSpec_33763, "", false)  
		end
		
		-- 支援活力值Vigor
		if EA_Config.SpecPowerCheck.Vigor then
			EventAlert_Icon_Options_Frame_SetAlertFrameText(EAFrameSpec_Vigor, "", false)  
		end
		
	-- 支援盜賊能量及連擊點數
	elseif (EA_playerClass == EA_CLASS_ROGUE) then
		-- Rogue Combo Points
		if (EA_Config.SpecPowerCheck.ComboPoints) then
			EventAlert_Icon_Options_Frame_SetAlertFrameText(_G["EAFrameSpec_"..(1000000 + 10 * Enum.PowerType.ComboPoints)], "", false)
		end
		
		-- Rogue Energy
		if (EA_Config.SpecPowerCheck.Energy) then
			EventAlert_Icon_Options_Frame_SetAlertFrameText(_G["EAFrameSpec_"..(1000000 + 10 * Enum.PowerType.Energy)], "", false)
		end
		
	-- 支援三系術士
	elseif (EA_playerClass == EA_CLASS_WARLOCK) then 
		-- Warlock Soul Shards
		if (EA_Config.SpecPowerCheck.SoulShards) then
			EventAlert_Icon_Options_Frame_SetAlertFrameText(_G["EAFrameSpec_"..(1000000 + 10 * Enum.PowerType.SoulShards)], "", false)
		end
			
		-- Warlock Burning Embers
		if (EA_Config.SpecPowerCheck.BurningEmbers) then
			EventAlert_Icon_Options_Frame_SetAlertFrameText(_G["EAFrameSpec_"..(1000000 + 10 * Enum.PowerType.BurningEmbers)], "", false)
		end
			
		-- Warlock Demonic Fury
		if (EA_Config.SpecPowerCheck.DemonicFury) then
			EventAlert_Icon_Options_Frame_SetAlertFrameText(_G["EAFrameSpec_"..(1000000 + 10 * Enum.PowerType.DemonicFury)], "", false)			
		end
		
	--  支援武僧真氣
	elseif (EA_playerClass == EA_CLASS_MONK) then
		-- Monk Light Force (Chi)
		if (EA_Config.SpecPowerCheck.Chi) then
			EventAlert_Icon_Options_Frame_SetAlertFrameText(_G["EAFrameSpec_"..(1000000 + 10 * Enum.PowerType.Chi)], "", false)			
		end
		
		-- Monk Mana
		if (EA_Config.SpecPowerCheck.Mana) then
			EventAlert_Icon_Options_Frame_SetAlertFrameText(_G["EAFrameSpec_"..(1000000 + 10 * Enum.PowerType.Mana)], "", false)			
		end
		
	--  支援暗牧暗影寶珠(瘋狂)
	elseif (EA_playerClass == EA_CLASS_PRIEST) then	
		-- Shadwo Priest Insanity
		if (EA_Config.SpecPowerCheck.Insanity) then		
			EventAlert_Icon_Options_Frame_SetAlertFrameText(_G["EAFrameSpec_"..(1000000 + 10 * Enum.PowerType.Insanity)], "", false)			
		end
		
		-- Shadwo Priest Mana
		if (EA_Config.SpecPowerCheck.Mana) then
			EventAlert_Icon_Options_Frame_SetAlertFrameText(_G["EAFrameSpec_"..(1000000 + 10 * Enum.PowerType.Mana)], "", false)			
		end
		
		
	--  支援戰士怒氣
	elseif (EA_playerClass == EA_CLASS_WARRIOR) then 
		-- Warrior Rage
		if (EA_Config.SpecPowerCheck.Rage) then
			EventAlert_Icon_Options_Frame_SetAlertFrameText(_G["EAFrameSpec_"..(1000000 + 10 * Enum.PowerType.Rage)], "", false)			
		end		
	
	--  支援獵人集中值
	elseif (EA_playerClass == EA_CLASS_HUNTER) then 
		-- Hunter Focus
		if (EA_Config.SpecPowerCheck.Focus) then
			EventAlert_Icon_Options_Frame_SetAlertFrameText(_G["EAFrameSpec_"..(1000000 + 10 * Enum.PowerType.Focus)], "", false)						
		end
		-- Hunter Pet Focus
		if (EA_Config.SpecPowerCheck.PetFocus) then
			EventAlert_Icon_Options_Frame_SetAlertFrameText(_G["EAFrameSpec_"..(1000000 + 10 * Enum.PowerType.Focus + 1)], "", false)			
		end
		
	--  支援秘法充能
	elseif (EA_playerClass == EA_CLASS_MAGE) then 
		-- Mage Arcane Charges
		if (EA_Config.SpecPowerCheck.ArcaneCharges) then			
			EventAlert_Icon_Options_Frame_SetAlertFrameText(_G["EAFrameSpec_"..(1000000 + 10 * Enum.PowerType.ArcaneCharges)], "", false)			
		end
		
	--  支援增強薩元素薩的元能(漩渦)
	elseif (EA_playerClass == EA_CLASS_SHAMAN) then 
		-- Shaman Maelstrom
		if (EA_Config.SpecPowerCheck.Maelstrom) then
			EventAlert_Icon_Options_Frame_SetAlertFrameText(_G["EAFrameSpec_"..(1000000 + 10 * Enum.PowerType.Maelstrom)], "", false)			
		end
		
	--  支援惡魔獵人魔怒
	elseif (EA_playerClass == EA_CLASS_DEMONHUNTER) then 
		-- Demonhunter Fury
		if (EA_Config.SpecPowerCheck.Fury) then
			EventAlert_Icon_Options_Frame_SetAlertFrameText(_G["EAFrameSpec_"..(1000000 + 10 * Enum.PowerType.Fury)], "", false)								
		end
		-- Demonhunter Pain
		if (EA_Config.SpecPowerCheck.Pain) then			
			-- EventAlert_Icon_Options_Frame_SetAlertFrameText(_G["EAFrameSpec_"..(1000000 + 10 * Enum.PowerType.Pain)], "", false)											
		end	
	
	--  支援喚能師龍能
	elseif (EA_playerClass == EA_CLASS_EVOKER) then 
		-- Evoker's Essence
		if (EA_Config.SpecPowerCheck.Essence) then
			EventAlert_Icon_Options_Frame_SetAlertFrameText(_G["EAFrameSpec_"..(1000000 + 10 * Enum.PowerType.Essence)], "", false)										
		end		
		
	end
end


function EventAlert_Icon_Options_Frame_AdjustTimerFontSize()
	
	-- local fontSize = EA_Config.BaseFontSize
	
	-- if (EA_Config.ChangeTimer == true) then	--若計時顯示在框架內
		-- -- 若使用了小數點倒數
		-- if (EA_Config.UseFloatSec > 0) then
			-- EA_Config.TimerFontSize = fontSize * 0.8		--框架內倒數大小比例(有小數點)
		-- else
			-- EA_Config.TimerFontSize = fontSize	 			--框架內倒數大小比例(無小數點)
		-- end
		-- EA_Config.StackFontSize = fontSize * 1/1.5			--堆疊計數大小比例
	-- else	--若計時顯示在框架外
		-- EA_Config.TimerFontSize = fontSize * 1.25			--框架外倒數大小比例
		-- EA_Config.StackFontSize = fontSize * 1/1.5 * 1.25	--堆疊計數大小比例
	-- end
	
	
	
	-- EA_Config.SNameFontSize = fontSize * 1/2			--名稱大小比例
	--if EA_Config.SNameFontSize < 10 then EA_Config.SNameFontSize = 10 end

	--EventAlert_PositionFrames()
	--EventAlert_TarPositionFrames()
	--EventAlert_ScdPositionFrames()
	--EventAlert_SpecialFrame_Update()
end

function EventAlert_Icon_Options_Frame_ResetFrame()
	if (EA_Config.LockFrame == true) then
		-- DEFAULT_CHAT_FRAME:AddMessage("EventAlert: You must unlock the alert frame in order to move it or reset it's position.")
		DEFAULT_CHAT_FRAME:AddMessage("\124cffFFFF00EventAlertMod\124r: "..EA_XICON_LOCKFRAMETIP)
	else
		EA_Position.Anchor = "CENTER"
		EA_Position.relativePoint = "CENTER"
		EA_Position.xLoc = 0
		EA_Position.yLoc = -140
		EA_Position.xOffset = 0
		EA_Position.yOffset = 0
		EA_Position.RedDebuff = 0.5
		EA_Position.GreenDebuff = 0.5

		EA_Position.Tar_NewLine = true
		EA_Position.TarAnchor = "CENTER"
		EA_Position.TarrelativePoint = "CENTER"
		EA_Position.Tar_xOffset = 0
		EA_Position.Tar_yOffset = -220
		-- EA_Icon_Options_Frame_Tar_NewLine:SetChecked(EA_Position.Tar_NewLine)

		EA_Position.ScdAnchor = "CENTER"
		EA_Position.Scd_xOffset = 0
		EA_Position.Scd_yOffset = 80

		EA_Anchor_Frame1:ClearAllPoints()
		EA_Anchor_Frame1:SetPoint(EA_Position.Anchor, EA_Position.xLoc, EA_Position.yLoc)
		EA_Anchor_Frame1:Hide()

		EA_Icon_Options_Frame_IconXOffset:SetValue(EA_Position.xOffset)
		EA_Icon_Options_Frame_IconYOffset:SetValue(EA_Position.yOffset)
		EA_Icon_Options_Frame_IconRedDebuff:SetValue((EA_Position.RedDebuff * 100) - 50)
		EA_Icon_Options_Frame_IconGreenDebuff:SetValue((EA_Position.GreenDebuff * 100) - 50)
		EventAlert_Icon_Options_Frame_ToggleNewLineAnchor()
		EventAlert_Icon_Options_Frame_ToggleAlertFrame()
		-- EventAlert_Icon_Options_Frame_ToggleAlertFrame()
	end
end


function EventAlert_Icon_Options_Frame_MouseDown(button)
	if button == "LeftButton" then
		-- EA_Icon_Options_Frame:StartMoving()
	end
end

function EventAlert_Icon_Options_Frame_MouseUp(button)
	if button == "LeftButton" then
		-- EA_Icon_Options_Frame:StopMovingOrSizing()
	end
end

function EventAlert_Icon_Options_Frame_ToggleNewLineAnchor()
	if (EA_Position.Tar_NewLine) then
		EA_Anchor_Frame5:SetScript("OnMouseDown", EventAlert_Icon_Options_Frame_Anchor_OnMouseDown2)
		EA_Anchor_Frame5:SetScript("OnMouseUp", EventAlert_Icon_Options_Frame_Anchor_OnMouseUp2)
		EA_Anchor_Frame6:SetScript("OnMouseDown", EventAlert_Icon_Options_Frame_Anchor_OnMouseDown2)
		EA_Anchor_Frame6:SetScript("OnMouseUp", EventAlert_Icon_Options_Frame_Anchor_OnMouseUp2)
		EA_Anchor_Frame7:SetScript("OnMouseDown", EventAlert_Icon_Options_Frame_Anchor_OnMouseDown2)
		EA_Anchor_Frame7:SetScript("OnMouseUp", EventAlert_Icon_Options_Frame_Anchor_OnMouseUp2)
		EA_Anchor_Frame8:SetScript("OnMouseDown", EventAlert_Icon_Options_Frame_Anchor_OnMouseDown2)
		EA_Anchor_Frame8:SetScript("OnMouseUp", EventAlert_Icon_Options_Frame_Anchor_OnMouseUp2)
	else
		EA_Anchor_Frame5:SetScript("OnMouseDown", EventAlert_Icon_Options_Frame_Anchor_OnMouseDown)
		EA_Anchor_Frame5:SetScript("OnMouseUp", EventAlert_Icon_Options_Frame_Anchor_OnMouseUp)
		EA_Anchor_Frame6:SetScript("OnMouseDown", EventAlert_Icon_Options_Frame_Anchor_OnMouseDown)
		EA_Anchor_Frame6:SetScript("OnMouseUp", EventAlert_Icon_Options_Frame_Anchor_OnMouseUp)
		EA_Anchor_Frame7:SetScript("OnMouseDown", EventAlert_Icon_Options_Frame_Anchor_OnMouseDown)
		EA_Anchor_Frame7:SetScript("OnMouseUp", EventAlert_Icon_Options_Frame_Anchor_OnMouseUp)
		EA_Anchor_Frame8:SetScript("OnMouseDown", EventAlert_Icon_Options_Frame_Anchor_OnMouseDown)
		EA_Anchor_Frame8:SetScript("OnMouseUp", EventAlert_Icon_Options_Frame_Anchor_OnMouseUp)
	end
end

function EventAlert_Icon_Options_Frame_Anchor_OnMouseDown()
	if (EA_Config.LockFrame == true) then
		DEFAULT_CHAT_FRAME:AddMessage("\124cffFFFF00EventAlertMod\124r: "..EA_XICON_LOCKFRAMETIP)
	else
		EA_Anchor_Frame1:StartMoving()
	end
end

function EventAlert_Icon_Options_Frame_Anchor_OnMouseUp()
	EA_Anchor_Frame1:StopMovingOrSizing()
	local EA_point, _, EA_relativePoint, EA_xOfs, EA_yOfs = EA_Anchor_Frame1:GetPoint()
	EA_Position.Anchor = EA_point
	EA_Position.relativePoint = EA_relativePoint
	EA_Position.xLoc = EA_xOfs
	EA_Position.yLoc = EA_yOfs
	-- DEFAULT_CHAT_FRAME:AddMessage("\124cffFFFF00EventAlert2\124r EA_yOfs: "..EA_yOfs)
end

function EventAlert_Icon_Options_Frame_Anchor_OnMouseDown2()
	if (EA_Config.LockFrame == true) then
		DEFAULT_CHAT_FRAME:AddMessage("\124cffFFFF00EventAlertMod\124r: "..EA_XICON_LOCKFRAMETIP)
	else
		EA_Anchor_Frame5:StartMoving()
	end
end

function EventAlert_Icon_Options_Frame_Anchor_OnMouseUp2()
	EA_Anchor_Frame5:StopMovingOrSizing()
	local EA_point, UIParent, EA_relativePoint, EA_x4Ofs, EA_y4Ofs = EA_Anchor_Frame5:GetPoint()
	EA_Position.TarAnchor = EA_point
	EA_Position.TarrelativePoint = EA_relativePoint
	EA_Position.Tar_xOffset = EA_x4Ofs
	EA_Position.Tar_yOffset = EA_y4Ofs
end

function EventAlert_Icon_Options_Frame_Anchor_OnMouseDown3()
	if (EA_Config.LockFrame == true) then
		DEFAULT_CHAT_FRAME:AddMessage("\124cffFFFF00EventAlertMod\124r: "..EA_XICON_LOCKFRAMETIP)
	else
		EA_Anchor_Frame9:StartMoving()
	end
end

function EventAlert_Icon_Options_Frame_Anchor_OnMouseUp3()
	local halfIconSize = EA_Config.IconSize / 2
	EA_Anchor_Frame9:StopMovingOrSizing()
	local EA_point, UIParent, EA_relativePoint, EA_x6Ofs, EA_y6Ofs = EA_Anchor_Frame9:GetPoint()
	-- DEFAULT_CHAT_FRAME:AddMessage("EA_point="..EA_point.." EA_relativePoint="..EA_relativePoint.." EA_x6Ofs="..EA_x6Ofs.." EA_y6Ofs="..EA_y6Ofs)
	if EA_point == "TOP" then EA_y6Ofs = EA_y6Ofs - halfIconSize end
	if EA_point == "BOTTOM" then EA_y6Ofs = EA_y6Ofs + halfIconSize end
	if EA_point == "LEFT" then EA_x6Ofs = EA_x6Ofs + halfIconSize end
	if EA_point == "RIGHT" then EA_x6Ofs = EA_x6Ofs - halfIconSize end
	if EA_point == "TOPLEFT" then
		EA_x6Ofs = EA_x6Ofs + halfIconSize
		EA_y6Ofs = EA_y6Ofs - halfIconSize
	end
	if EA_point == "TOPRIGHT" then
		EA_x6Ofs = EA_x6Ofs - halfIconSize
		EA_y6Ofs = EA_y6Ofs - halfIconSize
	end
	if EA_point == "BOTTOMLEFT" then
		EA_x6Ofs = EA_x6Ofs + halfIconSize
		EA_y6Ofs = EA_y6Ofs + halfIconSize
	end
	if EA_point == "BOTTOMRIGHT" then
		EA_x6Ofs = EA_x6Ofs - halfIconSize
		EA_y6Ofs = EA_y6Ofs + halfIconSize
	end
	EA_Position.ScdAnchor = EA_relativePoint
	EA_Position.Scd_xOffset = EA_x6Ofs
	EA_Position.Scd_yOffset = EA_y6Ofs
end


-- function EventAlert_Icon_Options_Frame_DirectSelect_OnLoad(DropDown, DropTypeIndex)
-- 	local function MyDropDownClick(self)
-- 		EventAlert_Icon_Options_Frame_DirectSelect_OnClick(self, DropDown, DropTypeIndex)
-- 	end
-- 
-- 	local function MyDropDownInit()
-- 		local selectedValue = UIDropDownMenu_GetSelectedValue(DropDown)
-- 		if selectedValue == nil then selectedValue = 0 end
-- 		local function AddItem(text, value)
-- 			local info = {}
-- 			info.text = text
-- 			info.func = MyDropDownClick
-- 			info.value = value
-- 			info.checked = false
-- 			if (info.value == selectedValue) then
-- 				info.checked = true
-- 			end
-- 			-- info.checked = checked
-- 			UIDropDownMenu_AddButton(info)
-- 		end
-- 		AddItem(EA_XICON_DIRLEFT, 1)
-- 		AddItem(EA_XICON_DIRRIGHT, 2)
-- 		AddItem(EA_XICON_DIRUP, 3)
-- 		AddItem(EA_XICON_DIRDOWN, 4)	
-- 	end
-- 
-- 	UIDropDownMenu_Initialize(DropDown, MyDropDownInit)
-- 	if (DropTypeIndex == 1) then
-- 		UIDropDownMenu_SetSelectedID(DropDown,  EA_Position.IconDropDown1)
-- 	elseif (DropTypeIndex == 2) then
-- 		UIDropDownMenu_SetSelectedID(DropDown,  EA_Position.IconDropDown2)
-- 	elseif (DropTypeIndex == 3) then
-- 		UIDropDownMenu_SetSelectedID(DropDown,  EA_Position.IconDropDown3)
-- 	end
-- end
-- 
-- function EventAlert_Icon_Options_Frame_DirectSelect_OnClick(self, DropDown, DropTypeIndex)
-- 	local SelValue = self.value
-- 	if SelValue == nil then SelValue = 0 end
-- 	UIDropDownMenu_SetSelectedValue(DropDown, SelValue)
-- 	if (DropTypeIndex == 1) then
-- 		EA_Position.IconDropDown1 = SelValue
-- 	elseif (DropTypeIndex == 2) then
-- 		EA_Position.IconDropDown2 = SelValue
-- 	elseif (DropTypeIndex == 3) then
-- 		EA_Position.IconDropDown3 = SelValue
-- 	end
-- end
