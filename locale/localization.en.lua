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

if GetLocale() == "enUS" then

EA_SPELL_POWER_NAME = {
	Health = "Health",
	Mana = "Mana",
	Happiness = "Happiness",
	Energy = "Energy",
	Rage = "Rage",
	Focus = "Focus",
	FocusPet = "Pet Focus",
	RunicPower = "Runic Power",
	Runes = "Runes",
	Pain = "Pain",
	Fury = "Fury",
	ComboPoints = "Combo Points",
	LunarPower = "Lunar Power",
	HolyPower = "Holy Power",
	ArcaneCharges = "Arcane Charges",
	Insanity = "Insanity",
	Maelstrom = "Maelstrom",
	SoulShards = "Soul Shards",
	Chi = "Chi",
	DemonicFury = "Demonic Fury",
	BurningEmbers = "Burning Embers",
	LifeBloom = "Lifebloom",
	Essence = "Essence",
	Vitality = "Vitality",
}

EA_TTIP_SPECFLAG_CHECK = {}
for k,v in pairs(EA_SPELL_POWER_NAME) do
	EA_TTIP_SPECFLAG_CHECK[k] = "Enable/disable, display in primary buff frame: "..v
end

EA_XGRPALERT_POWERTYPE = "Power Type:"
EA_XGRPALERT_POWERTYPES = {}
for k,v in pairs(EA_SPELL_POWER_NAME) do
	EA_XGRPALERT_POWERTYPES[#EA_XGRPALERT_POWERTYPES + 1]={}
	EA_XGRPALERT_POWERTYPES[#EA_XGRPALERT_POWERTYPES].text = v
	EA_XGRPALERT_POWERTYPES[#EA_XGRPALERT_POWERTYPES].value = Enum.PowerType[k]
end

EA_TTIP_DOALERTSOUND = "Whether to play sound when an event occurs."
EA_TTIP_ALERTSOUNDSELECT = "Select the sound to play when an event occurs."
EA_TTIP_LOCKFRAME = "Lock the alert frame to prevent it from being moved by mouse drag."
EA_TTIP_SHARESETTINGS = "All professions share the same frame position settings."
EA_TTIP_SHOWFRAME = "Show/Hide the alert frame when an event occurs."
EA_TTIP_SHOWNAME = "Show/Hide the name of the spell when an event occurs."
EA_TTIP_SHOWFLASH = "Show/Hide the full screen flash when an event occurs."
EA_TTIP_SHOWTIMER = "Show/Hide the remaining time of the spell when an event occurs."
EA_TTIP_CHANGETIMER = "Change the font size and position of the remaining time of the spell."
EA_TTIP_ICONSIZE = "Change the size of the icon displayed in the alert."
-- EA_TTIP_ICONSPACE = "Change the spacing between icons in the alert."
-- EA_TTIP_ICONDROPDOWN = "Change the direction of the expanded icons in the alert."
EA_TTIP_ALLOWESC = "Change whether the alert frame can be closed by the ESC key. (Note: UI needs to be reloaded)"
EA_TTIP_ALTALERTS = "Enable/Disable additional events triggered by EventAlertMod (non-buff/debuff events)."

	 EA_TTIP_ICONXOFFSET = "Adjust the horizontal spacing of the reminder frame."
EA_TTIP_ICONYOFFSET = "Adjust the vertical spacing of the reminder frame."
EA_TTIP_ICONREDDEBUFF = "Adjust the red depth of the self debuff icon."
EA_TTIP_ICONGREENDEBUFF = "Adjust the green depth of the target debuff icon."
EA_TTIP_ICONEXECUTION = "Adjust the health percentage for boss execute period. (0% to turn off execute reminder)"
EA_TTIP_PLAYERLV2BOSS = "Apply boss-level execute reminder for players who are 2 levels higher (e.g. 5-man instance bosses)."
EA_TTIP_SCD_USECOOLDOWN = "Use cooldown shadow for skill cooldown (requires UI reload to take effect)."
EA_TTIP_TAR_NEWLINE = "Adjust whether to display the target debuff on a separate line."
EA_TTIP_TAR_ICONXOFFSET = "Adjust the horizontal spacing between the target debuff line and the reminder frame."
EA_TTIP_TAR_ICONYOFFSET = "Adjust the vertical spacing between the target debuff line and the reminder frame."
EA_TTIP_TARGET_MYDEBUFF = "Adjust whether to display only the debuffs cast by the player on the target debuff line."
EA_TTIP_SPELLCOND_STACK = "Toggle to show/hide the frame only when the spell stack is greater than or equal to a certain number (minimum value is 2)."
EA_TTIP_SPELLCOND_SELF = "Toggle to show/hide only the spells cast by the player, to avoid monitoring the same spells cast by others."
EA_TTIP_SPELLCOND_OVERGROW = "Toggle to highlight the frame when the spell stack is greater than or equal to a certain number (minimum value is 1)."
EA_TTIP_SPELLCOND_REDSECTEXT = "Toggle to display the remaining seconds in larger red font when it is less than or equal to a certain number of seconds (minimum value is 1)."
EA_TTIP_SPELLCOND_ORDERWTD = "Toggle to set the priority of the display order. The larger the number, the higher the priority to display it in the innermost circle (can be set from 1 to 20)."

EA_TTIP_GRPCFG_ICONALPHA = "Change the transparency of the icon."
EA_TTIP_GRPCFG_TALENT = "Only applicable when in this specialization."
EA_TTIP_GRPCFG_HIDEONLEAVECOMBAT = "Hide icon when leaving combat."
EA_TTIP_GRPCFG_HIDEONLOSTTARGET = "Hide icon when there is no target."
EA_TTIP_GRPCFG_GLOWWHENTRUE = "Highlight icon when conditions are met."

EA_XOPT_ICONPOSOPT = "Icon position & class-specific resources."
EA_XOPT_SHOW_ALTFRAME = "Show the main reminder frame."
EA_XOPT_SHOW_BUFFNAME = "Show the name of the spell."
EA_XOPT_SHOW_TIMER = "Show the countdown timer."
EA_XOPT_SHOW_OMNICC = "Show the timer within the frame."
EA_XOPT_SHOW_FULLFLASH = "Show full-screen flash reminder."
EA_XOPT_PLAY_SOUNDALERT = "Play sound alert."
EA_XOPT_ESC_CLOSEALERT = "Close alert with ESC."
EA_XOPT_SHOW_ALTERALERT = "Show additional reminder."
EA_XOPT_SHOW_CHECKLISTALERT = "Enable."
EA_XOPT_SHOW_CLASSALERT = "Class-specific buff/debuff reminders."
EA_XOPT_SHOW_OTHERALERT = "Cross-class buff/debuff reminders."
EA_XOPT_SHOW_TARGETALERT = "Target-specific buff/debuff reminders."
EA_XOPT_SHOW_SCDALERT = "Class-Specific CD Alert"
EA_XOPT_SHOW_GROUPALERT = "Class-Specific Condition Alert"
EA_XOPT_OKAY = "Close"
EA_XOPT_SAVE = "Save"
EA_XOPT_CANCEL = "Cancel"
EA_XOPT_VERURLTEXT = "EAM Release URL:\ngithub.com/ziyuefan/EventAlertModAll/"
EA_XOPT_VERBTN1 = "GitHub"
EA_XOPT_VERURL1 = "https://github.com/ziyuefan/EventAlertModAll/"
EA_XOPT_SPELLCOND_STACK = "Stacks >= to show frame:"
EA_XOPT_SPELLCOND_SELF = "Restrict to spells cast by player only"
EA_XOPT_SPELLCOND_OVERGROW = "Stacks >= to highlight:"
EA_XOPT_SPELLCOND_REDSECTEXT = "Countdown <= to show red text:"
EA_XOPT_SPELLCOND_ORDERWTD = "Priority weight (1-20):"

EA_XICON_LOCKFRAME = "Lock Example Frame"
EA_XICON_LOCKFRAMETIP = "Uncheck to move Alert Frame or reset frame position"
EA_XICON_SHARESETTING = "Share Frame Position Setting"
EA_XICON_ICONSIZE = "Icon Size"
-- EA_XICON_ICONSIZE2 = "Target Icon Size"
-- EA_XICON_ICONSIZE3 = "CD Icon Size"
EA_XICON_LARGE = "Large"
EA_XICON_SMALL = "Small"
EA_XICON_HORSPACE = "Horizontal Spacing"
EA_XICON_VERSPACE = "Vertical Spacing"
-- EA_XICON_ICONSPACE1 = "Self Icon Spacing"
-- EA_XICON_ICONSPACE2 = "Target Icon Spacing"
-- EA_XICON_ICONSPACE3 = "CD Icon Spacing"
EA_XICON_MORE = "More"
EA_XICON_LESS = "Less"
EA_XICON_REDDEBUFF = "Self Debuff Icon Red Intensity"
EA_XICON_GREENDEBUFF = "Target Debuff Icon Green Intensity"
EA_XICON_DEEP = "Deep"
EA_XICON_LIGHT = "Light"
-- EA_XICON_DIRECTION = "Expansion Direction"
-- EA_XICON_DIRUP = "Up"
-- EA_XICON_DIRDOWN = "Down"
-- EA_XICON_DIRLEFT = "Left"
-- EA_XICON_DIRRIGHT = "Right"
EA_XICON_TAR_NEWLINE = "Display target debuffs in a new line"
EA_XICON_TAR_HORSPACE = "Horizontal spacing with alert frame"
EA_XICON_TAR_VERSPACE = "Vertical spacing with alert frame"
EA_XICON_TOGGLE_ALERTFRAME = "Move Frame"
EA_XICON_RESET_FRAMEPOS = "Reset Frame Position"
EA_XICON_SELF_BUFF = "Self Buff"
EA_XICON_SELF_SPBUFF = "Self Debuff (1)\nor special frame"
EA_XICON_SELF_DEBUFF = "Self Debuff"
EA_XICON_TARGET_BUFF = "Target Buff"
EA_XICON_TARGET_SPBUFF = "Target Buff (1)\nor special frame"
EA_XICON_TARGET_DEBUFF = "Target Debuff"
EA_XICON_SCD = "Skill Cooldown"
EA_XICON_EXECUTION = "Alert for Boss-level Target Execution"
EA_XICON_EXEFULL = "100%"
EA_XICON_EXECLOSE = "Close"
EA_XICON_SCD_USECOOLDOWN = "Use countdown shadow for cooldowns (requires UI reload)"

EX_XCLSALERT_SELALL = "Select All"
EX_XCLSALERT_CLRALL = "Clear All"
EX_XCLSALERT_LOADDEFAULT = "Default"
EX_XCLSALERT_REMOVEALL = "Delete All"
EX_XCLSALERT_SPELL = "Spell ID:"
EX_XCLSALERT_ADDSPELL = "Add"
EX_XCLSALERT_DELSPELL = "Delete"
EX_XCLSALERT_HELP1 = "The above list is sorted by [Spell ID]."
EX_XCLSALERT_HELP2 = "If you want to check the Spell ID, it is recommended to enter the /eam help command."
EX_XCLSALERT_HELP3 = "Understand the various commands for [Query Spells] in the game."
EX_XCLSALERT_HELP4 = "The additional reminder area is the condition skill that is not of the Buff type."
EX_XCLSALERT_HELP5 = "For example, when the enemy's health enters the execute phase or is used after parrying."
EX_XCLSALERT_HELP6 = "It will not display Buffs, but can use skills."
EX_XCLSALERT_SPELLURL = "http://www.wowhead.com/spells"

EA_XTARALERT_TARGET_MYDEBUFF = "Only show player's debuffs"

EA_XGRPALERT_ICONALPHA = "Icon Transparency"
EA_XGRPALERT_GRPID = "Group ID:"
EA_XGRPALERT_TALENT1 = "Talent 1"
EA_XGRPALERT_TALENT2 = "Talent 2"
EA_XGRPALERT_TALENT3 = "Talent 3"
EA_XGRPALERT_TALENT4 = "Talent 4"
EA_XGRPALERT_HIDEONLEAVECOMBAT = "Hide when out of combat"
EA_XGRPALERT_HIDEONLOSTTARGET = "Hide when no target"
EA_XGRPALERT_GLOWWHENTRUE = "Glow when condition met"
EA_XGRPALERT_TALENTS = "All Talents"
EA_XGRPALERT_NEWSPELLBTN = "Add Spell"
EA_XGRPALERT_NEWCHECKBTN = "Add Parent Condition"
EA_XGRPALERT_NEWSUBCHECKBTN = "Add Child Condition"
EA_XGRPALERT_SPELLNAME = "Spell Name:"
EA_XGRPALERT_SPELLICON = "Spell Icon:"
EA_XGRPALERT_TITLECHECK = "Parent Condition:"
EA_XGRPALERT_TITLESUBCHECK = "Child Condition:"
EA_XGRPALERT_TITLEORDERUP = "Move Up"
EA_XGRPALERT_TITLEORDERDOWN = "Move Down"

EA_XGRPALERT_LOGICS = {
	[1]={text="And", value=1},
	[2]={text="Or", value=0},
	}

EA_XGRPALERT_EVENTTYPE = "Event Type:"

EA_XGRPALERT_EVENTTYPES = {
	[1]={text="Unit Power Changes", value="UNIT_POWER_UPDATE"},
	[2]={text="Unit Health Changes", value="UNIT_HEALTH"},
	[3]={text="Unit Buff/Debuff Changes", value="UNIT_AURA"},
	[4]={text="Combo Point Changes", value="UNIT_COMBO_POINTS"}, }

EA_XGRPALERT_UNITTYPE = "Target:"

EA_XGRPALERT_UNITTYPES = {
	[1]={text="Player", value="player"},
	[2]={text="Target", value="target"},
	[3]={text="Focus", value="focus"},
	[4]={text="Pet", value="pet"},
	[5]={text="Boss1", value="boss1"},
	[6]={text="Boss2", value="boss2"},
	[7] = {text="Boss3", value="boss3"},
	[8] = {text="Boss4", value="boss4"},
	[9] = {text="Party1", value="party1"},
	[10] = {text="Party2", value="party2"},
	[11] = {text="Party3", value="party3"},
	[12] = {text="Party4", value="party4"},
	[13] = {text="Raid1", value="raid1"},
	[14] = {text="Raid2", value="raid2"},
	[15] = {text="Raid3", value="raid3"},
	[16] = {text="Raid4", value="raid4"},
	[17] = {text="Raid5", value="raid5"},
	[18] = {text="Raid6", value="raid6"},
	[19] = {text="Raid7", value="raid7"},
	[20] = {text="Raid8", value="raid8"},
	[21] = {text="Raid9", value="raid9"},
}

EA_XGRPALERT_CHECKCD = "Check spell CD:"
EA_XGRPALERT_HEALTH = "Health:"

EA_XGRPALERT_COMPARES = {
	[1] = {text="<", value=1},
	[2] = {text="<=", value=2},
	[3] = {text="=", value=3},
	[4] = {text=">=", value=4},
	[5] = {text=">", value=5},
	[6] = {text="<>", value=6},
	[7] = {text="*", value=7}, --any
}
EA_XGRPALERT_COMPARETYPES = {
	[1] = {text="Value", value=1},
	[2] = {text="Percentage", value=2},
}
EA_XGRPALERT_CHECKAURA = "Buff/Debuff:"
EA_XGRPALERT_CHECKAURAS = {
	[1] = {text="Exist", value=1},
	[2] = {text="NotExist", value=2},
}
EA_XGRPALERT_AURATIME = "Time:"
EA_XGRPALERT_AURASTACK = "Stacks:"
EA_XGRPALERT_CASTBYPLAYER = "Casted by player only"
EA_XGRPALERT_COMBOPOINT = "Combo points:"

EA_XLOOKUP_START1 = "Search Spell Name"
EA_XLOOKUP_START2 = "Exact match"
EA_XLOOKUP_RESULT1 = "Search Result"
EA_XLOOKUP_RESULT2 = " matches"
EA_XLOAD_LOAD = "\124cffFFFF00EventAlertMod\124r:Spell monitoring and trigger alert, loaded version:\124cff00FFFF"

EA_XLOAD_FIRST_LOAD = "\124cffFF0000First time loading EventAlertMod, loading default parameters\124r.\n\n"..
"Please use \124cffFFFF00/eam opt\124r for parameter settings, spell monitoring, and position adjustment.\n\n"

EA_XLOAD_NEWVERSION_LOAD = "Please use \124cffFFFF00/eam help\124r for detailed command instructions.\n\n\n"..
"\124cff00FFFF- Main Update Items -\124r\n\n"..
"*New Feature: Event prompt function with multiple judgment conditions in a group.\n\n"..
"The currently supported detected events are:\n"..
"1. 'Object' 'energy', when 'greater than or equal to' or 'less than or equal to' a certain 'value or ratio' is triggered\n"..
"2. 'Object' 'health', when 'greater than or equal to' or 'less than or equal to' a certain 'value or ratio' is triggered\n"..
"3. 'Object' 'Buff/Debuff', when 'specific spell ID' is included (can be filtered by layer or seconds), or when 'specific spell ID' is not included is triggered\n"..
"4. 'Player' 'combo points' for 'target', when 'greater than or equal to' or 'less than or equal to' a certain 'value' is triggered\n"..
"All of the above conditions can be filtered by AND or OR, one or more conditions are used for filtering.\n"..
"When the filtering result is true, the specified icon is prompted.\n"..
"" -- END OF NEWVERSION

EA_XCMD_VER = " \124cff00FFFFBy Whitep@¹pÅì\124r Version: "
EA_XCMD_DEBUG = " Mode: "
EA_XCMD_SELFLIST = " Display self Buff/Debuff: "
EA_XCMD_TARGETLIST = " Display target Debuff: "
EA_XCMD_CASTSPELL = " Display spell ID: "
EA_XCMD_AUTOADD_SELFLIST = " Automatically add self all auras: "
EA_XCMD_ENVADD_SELFLIST = " Automatically add self environmental auras: "
EA_XCMD_DEBUG_P0 = "Triggered Spell List"
EA_XCMD_DEBUG_P1 = "Spell"
EA_XCMD_DEBUG_P2 = "Spell ID"
EA_XCMD_DEBUG_P3 = "Stack"
EA_XCMD_DEBUG_P4 = "Duration"

EA_XCMD_CMDHELP = {
["TITLE"] = "\124cffFFFF00EventAlertMod\124r \124cff00FF00Command\124r Instructions(/eventalertmod or /eam):",
["OPT"] = "\124cff00FF00/eam options(or opt)\124r - Show/Hide main settings window.",
["HELP"] = "\124cff00FF00/eam help\124r - Show further command instructions.",
["SHOW"] = {
"\124cff00FF00/eam show [sec]\124r -",
"Start/Stop, continuously list >Player< all Buff/Debuff's spell ID, and the spells duration is within sec seconds",
},
["SHOWT"] = {
"\124cff00FF00/eam showtarget(or showt) [sec]\124r -",
"Start/Stop, continuously list >Target< all Debuff's spell ID, and the spells duration is within sec seconds",
},
["SHOWC"] = {
"\124cff00FF00/eam showcast(or showc)\124r -",
"Start/Stop, list the spell ID after a successful cast",
},

["SHOWA"] = {
"\124cff00FF00/eam showautoadd (or showa) [sec]\124r -",
"Start/stop automatically monitoring all Buff/Debuff spells on the >player< and add them to the watch list. Spells with a duration of within sec seconds (default is 60 seconds)",
},
["SHOWE"] = {
"\124cff00FF00/eam showenvadd (or showe) [sec]\124r -",
"Start/stop automatically monitoring all Buff/Debuff spells on the >player< (excluding those from raid and party members) and add them to the watch list. Spells with a duration of within sec seconds (default is 60 seconds)",
},
["LIST"] = {
"\124cff00FF00/eam list\124r - Show trigger spell list",
"Show/hide the output of the commands: show, showc, showt, lookup, and lookupfull",
},
["LOOKUP"] = {
"\124cff00FF00/eam lookup (or l) name\124r - Search for partial spell name",
"Search for all spells in the game and list all spell IDs that [partially match] the search name",
},
["LOOKUPFULL"] = {
"\124cff00FF00/eam lookupfull (or lf) name\124r - Search for complete spell name",
"Search for all spells in the game and list all spell IDs that [completely match] the search name",
},
}

end