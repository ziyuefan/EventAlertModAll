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
if GetLocale() == "koKR" then 

EA_SPELL_POWER_NAME = {
Health = "생명",
Mana = "마나",
Happiness = "기쁨 값",
Energy = "에너지",
Rage = "분노",
Focus = "집중",
FocusPet = "애완동물 집중",
RunicPower = "룬 마력",
Runes = "룬",
Pain = "고통",
Fury = "분노",
ComboPoints = "연계 점수",
LunarPower = "달 에너지",
HolyPower = "신성한 힘",
ArcaneCharges = "비전 충전",
Insanity = "광기",
Maelstrom = "혼돈 에너지",
SoulShards = "영혼 조각",
Chi = "기",
DemonicFury = "악마의 분노",
BurningEmbers = "불꽃 잔여",
LifeBloom = "생명의 꽃",
Essence = "용의 기운",
Vitality = "활력",
}

EA_TTIP_SPECFLAG_CHECK = {}
for k,v in pairs(EA_SPELL_POWER_NAME) do
EA_TTIP_SPECFLAG_CHECK[k] = v .. "을(를) 자신의 버프 프레임에 표시"
end

EA_XGRPALERT_POWERTYPE = "에너지 유형:"
EA_XGRPALERT_POWERTYPES = {}
for k,v in pairs(EA_SPELL_POWER_NAME) do
EA_XGRPALERT_POWERTYPES[#EA_XGRPALERT_POWERTYPES + 1] = {}
EA_XGRPALERT_POWERTYPES[#EA_XGRPALERT_POWERTYPES].text = v
EA_XGRPALERT_POWERTYPES[#EA_XGRPALERT_POWERTYPES].value = Enum.PowerType[k]
end

EA_TTIP_DOALERTSOUND = "이벤트 발생 시 소리 알림 여부"
EA_TTIP_ALERTSOUNDSELECT = "이벤트 발생 시 재생될 소리 선택"
EA_TTIP_LOCKFRAME = "알림 프레임 고정하여 이동 방지"
EA_TTIP_SHARESETTINGS = "모든 직업에서 공유되는 프레임 위치 설정"
EA_TTIP_SHOWFRAME = "이벤트 발생 시 알림 프레임 표시/숨기기"
EA_TTIP_SHOWNAME = "이벤트 발생 시 주문 이름 표시/숨기기"
EA_TTIP_SHOWFLASH = "이벤트 발생 시 화면 전체 반짝임 표시/숨기기"
EA_TTIP_SHOWTIMER = "이벤트 발생 시 주문 지속시간 표시/숨기기"
EA_TTIP_CHANGETIMER = "주문 지속시간 폰트 크기 및 위치 변경"
EA_TTIP_ICONSIZE = "알림 아이콘 크기 변경"
-- EA_TTIP_ICONSPACE = "알림 아이콘 간격 변경."
-- EA_TTIP_ICONDROPDOWN = "提示 아이콘 확장 방향 변경."
EA_TTIP_ALLOWESC = "ESC 키를 사용하여 팝업 창을 닫을 수 있는지 여부 변경. (참고: UI를 다시 로드해야 함)"
EA_TTIP_ALTALERTS = "EventAlertMod의 추가 이벤트 트리거 알림(강화/약화 효과가 아님) 켜기/끄기."

EA_TTIP_ICONXOFFSET = "알림 창의 수평 간격 조정."
EA_TTIP_ICONYOFFSET = "알림 창의 수직 간격 조정."
EA_TTIP_ICONREDDEBUFF = "Debuff 아이콘의 빨간 색상 강도 조정."
EA_TTIP_ICONGREENDEBUFF = "대상 Debuff 아이콘의 녹색 색상 강도 조정."
EA_TTIP_ICONEXECUTION = "보스 체력 백분율에 따른 처형 단계 조정(0%는 처형 알림 끄기)"
EA_TTIP_PLAYERLV2BOSS = "플레이어 레벨보다 2레벨 높은 보스(5인 던전 보스 등)에게도 보스 레벨의 처형 알림 적용"
EA_TTIP_SCD_USECOOLDOWN = "스킬 쿨타임 사용 대기시간을 표시하는 그림자 효과 사용(재시작하여 적용)"
EA_TTIP_TAR_NEWLINE = "대상 Debuff를 별도의 줄에 표시할지 여부 조정"
EA_TTIP_TAR_ICONXOFFSET = "대상 Debuff 줄과 알림 창의 수평 간격 조정"
EA_TTIP_TAR_ICONYOFFSET = "대상 Debuff 줄과 알림 창의 수직 간격 조정"
EA_TTIP_TARGET_MYDEBUFF = "대상 Debuff 줄에서 플레이어가 시전한 Debuff만 표시할지 여부 조정"
EA_TTIP_SPELLCOND_STACK = "주문 스택이 몇 층 이상일 때 프레임을 표시할지 여부 켜기/끄기\n(최소 입력 가능 값은 2부터 시작)"
EA_TTIP_SPELLCOND_SELF = "플레이어가 시전한 주문만 모니터링하여 다른 플레이어가 시전한 동일한 주문을 방지하기 위해 켜기/끄기"
EA_TTIP_SPELLCOND_OVERGROW = "주문 스택이 몇 층 이상일 때 강조 표시하여 켜기/끄기\n(최소 입력 가능 값은 1부터 시작)"
EA_TTIP_SPELLCOND_REDSECTEXT = "카운트 다운 시간이 몇 초 이하일 때"
EA_TTIP_SPELLCOND_ORDERWTD = "온/오프, 표시 순서 우선 순위 설정, 숫자가 클수록 내부 원에서 우선적으로 표시됨(1에서 20까지 입력 가능)"
EA_TTIP_GRPCFG_ICONALPHA = "아이콘 투명도 변경"
EA_TTIP_GRPCFG_TALENT = "이 전문화에만 적용"
EA_TTIP_GRPCFG_HIDEONLEAVECOMBAT = "전투 종료 후 아이콘 숨기기"
EA_TTIP_GRPCFG_HIDEONLOSTTARGET = "대상 없을 시 아이콘 숨기기"
EA_TTIP_GRPCFG_GLOWWHENTRUE = "조건 충족 시 아이콘 강조"

EA_XOPT_ICONPOSOPT = "아이콘 위치 및 직업 특수 에너지"
EA_XOPT_SHOW_ALTFRAME = "기본 프레임 표시"
EA_XOPT_SHOW_BUFFNAME = "주문 이름 표시"
EA_XOPT_SHOW_TIMER = "카운트다운 시간 표시"
EA_XOPT_SHOW_OMNICC = "프레임 안에 시간 표시"
EA_XOPT_SHOW_FULLFLASH = "전체 화면 번쩍임 알림 표시"
EA_XOPT_PLAY_SOUNDALERT = "소리 알림 재생"
EA_XOPT_ESC_CLOSEALERT = "ESC로 알림 닫기"
EA_XOPT_SHOW_ALTERALERT = "추가 알림 표시"
EA_XOPT_SHOW_CHECKLISTALERT = "사용"
EA_XOPT_SHOW_CLASSALERT = "직업 - 버프 및 디버프 알림"
EA_XOPT_SHOW_OTHERALERT = "다른 직업 - 버프 및 디버프 알림"
EA_XOPT_SHOW_TARGETALERT = "대상 - 버프 및 디버프 알림"
EA_XOPT_SHOW_SCDALERT = "직업 - 기술 재사용 대기시간 알림"
EA_XOPT_SHOW_GROUPALERT = "직업 - 조건 기술 알림"
EA_XOPT_OKAY = "닫기"
EA_XOPT_SAVE = "저장"
EA_XOPT_CANCEL = "취소"
EA_XOPT_VERURLTEXT = "EAM 배포 주소:\ngithub.com/ziyuefan/EventAlertModAll/"
EA_XOPT_VERBTN1 = "GitHub"
EA_XOPT_VERURL1 = "https://github.com/ziyuefan/EventAlertModAll/"
EA_XOPT_SPELLCOND_STACK = "주문 중첩이 >= 몇층일 때 프레임 표시:"
EA_XOPT_SPELLCOND_SELF = "플레이어가 시전한 주문에만 제한"
EA_XOPT_SPELLCOND_OVERGROW = "주문 중첩이 >= 몇층일 때 강조 표시:"
EA_XOPT_SPELLCOND_REDSECTEXT = "카운트다운 시간이 <= 몇초일 때 빨간"
EA_XOPT_SPELLCOND_ORDERWTD = "순서 우선 비중 표시(1-20):"
EA_XICON_LOCKFRAME = "프레임 잠금"
EA_XICON_LOCKFRAMETIP = "알림 프레임 이동 또는 위치 재설정을 원할 경우 '프레임 잠금' 체크를 해제하십시오."
EA_XICON_SHARESETTING = "프레임 위치 공유 설정"
EA_XICON_ICONSIZE = "아이콘 크기"
-- EA_XICON_ICONSIZE2 = "대상 아이콘 크기"
-- EA_XICON_ICONSIZE3 = "쿨다운 아이콘 크기"
EA_XICON_LARGE = "크게"
EA_XICON_SMALL = "작게"
EA_XICON_HORSPACE = "수평 간격"
EA_XICON_VERSPACE = "수직 간격"
-- EA_XICON_ICONSPACE1 = "자신 아이콘 간격"
-- EA_XICON_ICONSPACE2 = "대상 아이콘 간격"
-- EA_XICON_ICONSPACE3 = "쿨다운 아이콘 간격"
EA_XICON_MORE = "많이"
EA_XICON_LESS = "적게"
EA_XICON_REDDEBUFF = "자신의 Debuff 아이콘 색상 깊이"
EA_XICON_GREENDEBUFF = "대상의 Debuff 아이콘 색상 깊이"
EA_XICON_DEEP = "깊게"
EA_XICON_LIGHT = "연하게"
-- EA_XICON_DIRECTION = "확장 방향"
-- EA_XICON_DIRUP = "위"
-- EA_XICON_DIRDOWN = "아래"
-- EA_XICON_DIRLEFT = "왼쪽"
-- EA_XICON_DIRRIGHT = "오른쪽"
EA_XICON_TAR_NEWLINE = "대상 Debuff를 새 줄로 표시"
EA_XICON_TAR_HORSPACE = "알림 프레임과 수평 간격"
EA_XICON_TAR_VERSPACE = "알림 프레임과 수직 간격"
EA_XICON_TOGGLE_ALERTFRAME = "프레임 이동"
EA_XICON_RESET_FRAMEPOS = "프레임 위치 재설정"
EA_XICON_SELF_BUFF = "자신 버프"
EA_XICON_SELF_SPBUFF = "자신 DeBuff(1)\n또는 특수 프레임"
EA_XICON_SELF_DEBUFF = "자신 Debuff"
EA_XICON_TARGET_BUFF = "대상 버프"
EA_XICON_TARGET_SPBUFF = "대상 버프(1)\n또는 특수 프레임"
EA_XICON_TARGET_DEBUFF = "대상 Debuff"
EA_XICON_SCD = "스킬 쿨다운"
EA_XICON_EXECUTION = "보스 타겟 체력 퍼센트 알림"
EA_XICON_EXEFULL = "100%"
EA_XICON_EXECLOSE = "닫기"
EA_XICON_SCD_USECOOLDOWN = "쿨다운 사용 후 음"
EX_XCLSALERT_SELALL = "전체 선택"
EX_XCLSALERT_CLRALL = "전체 선택 해제"
EX_XCLSALERT_LOADDEFAULT = "기본값"
EX_XCLSALERT_REMOVEALL = "전체 삭제"
EX_XCLSALERT_SPELL = "주문 ID:"
EX_XCLSALERT_ADDSPELL = "추가"
EX_XCLSALERT_DELSPELL = "삭제"
EX_XCLSALERT_HELP1 = "위 목록은 [주문 ID]를 기준으로 정렬됩니다."
EX_XCLSALERT_HELP2 = "주문 ID를 찾으시려면 /eam help 명령어를 입력하세요."
EX_XCLSALERT_HELP3 = "게임에서 [주문 검색]에 대한 다양한 명령어를 알아보세요."
EX_XCLSALERT_HELP4 = "Buff 유형이 아닌 조건식 기술에 대한 추가적인 팁"
EX_XCLSALERT_HELP5 = "예 : 적 체력이 처형 구간에 진입하거나, 방패 막기 이후 사용"
EX_XCLSALERT_HELP6 = "Buff를 추가하지 않지만 사용할 수 있는 기술입니다."
EX_XCLSALERT_SPELLURL = "http://www.wowhead.com/spells"

EA_XTARALERT_TARGET_MYDEBUFF = "플레이어가 시전한 디버프만 대상"

EA_XGRPALERT_ICONALPHA = "아이콘 투명도"
EA_XGRPALERT_GRPID = "그룹 ID:"
EA_XGRPALERT_TALENT1 = "전문화 1"
EA_XGRPALERT_TALENT2 = "전문화 2"
EA_XGRPALERT_TALENT3 = "전문화 3"
EA_XGRPALERT_TALENT4 = "전문화 4"
EA_XGRPALERT_HIDEONLEAVECOMBAT = "전투 종료시 숨기기"
EA_XGRPALERT_HIDEONLOSTTARGET = "대상 없을 때 숨기기"

EA_XGRPALERT_GLOWWHENTRUE = "조건 충족시 강조"

EA_XGRPALERT_TALENTS = "전문화 무관"
EA_XGRPALERT_NEWSPELLBTN = "주문 추가"
EA_XGRPALERT_NEWCHECKBTN = "상위 조건 추가"
EA_XGRPALERT_NEWSUBCHECKBTN = "하위 조건 추가"
EA_XGRPALERT_SPELLNAME = "주문 이름:"
EA_XGRPALERT_SPELLICON = "주문 아이콘:"
EA_XGRPALERT_TITLECHECK = "상위 조건:"
EA_XGRPALERT_TITLESUBCHECK = "하위 조건:"
EA_XGRPALERT_TITLEORDERUP = "우선순위 상승"
EA_XGRPALERT_TITLEORDERDOWN = "우선순위 하락"
EA_XGRPALERT_LOGICS = {
[1]={text="그리고", value=1},
[2]={text="또는", value=0}, }
EA_XGRPALERT_EVENTTYPE = "이벤트 유형:"
EA_XGRPALERT_EVENTTYPES = {
[1]={text="대상 에너지 변화", value="UNIT_POWER_UPDATE"},
[2]={text="대상 체력 변화", value="UNIT_HEALTH"},
[3]={text="대상 버프/디버프 변화", value="UNIT_AURA"},
[4]={text="연계 점수 변화", value="UNIT_COMBO_POINTS"}, }
EA_XGRPALERT_UNITTYPE = "대상 유형:"
EA_XGRPALERT_UNITTYPES = {
[1]={text="플레이어", value="player"},
[2]={text="대상", value="target"},
[3]={text="주시 대상", value="focus"},
[4]={text="소환수", value="pet"},
[5]={text="보스1", value="boss1"},
[6]={text="보스2", value="boss2"},
[7]={text="보스3", value="boss3"},
[8]={text="보스4", value="boss4"},
[9]={text="파티원1", value="party1"},
[10]={text="파티원2", value="party2"},
[11]={text="파티원3", value="party3"},
[12]={text="파티원4", value="party4"},
[13]={text="공격대원1", value="raid1"},
[14]={text="공격대원2", value="raid2"},
[15]={text="공격대원3", value="raid3"},
[16]={text="공격대원4", value="raid4"},
[17]={text="공격대원5", value="raid5"},
[18]={text="공격대원6", value="raid6"},
[19]={text="공격대원7", value="raid7"},
[20]={text="공격대원8", value="raid8"},
[21]={text="공격대원9", value="raid9"},
}

EA_XGRPALERT_CHECKCD = "스킬 CD 확인:"
EA_XGRPALERT_HEALTH = "체력:"
EA_XGRPALERT_COMPARES = {
[1]={text="<", value=1},
[2]={text="<=", value=2},
[3]={text="=", value=3},
[4]={text=">=", value=4},
[5]={text=">", value=5},
[6]={text="<>", value=6},
[7]={text="*", value=7}, -- 어떤 것이든
}
EA_XGRPALERT_COMPARETYPES = {
[1]={text="숫자", value=1},
[2]={text="백분율", value=2},
}
EA_XGRPALERT_CHECKAURA = "강화/약화 효과:"
EA_XGRPALERT_CHECKAURAS = {
[1]={text="있음", value=1},
[2]={text="없음", value=2},
}
EA_XGRPALERT_AURATIME = "시간:"
EA_XGRPALERT_AURASTACK = "중첩:"
EA_XGRPALERT_CASTBYPLAYER = "플레이어 시전한 경우"
EA_XGRPALERT_COMBOPOINT = "연계 점수:"
EA_XLOOKUP_START1 = "주문 이름 검색"
EA_XLOOKUP_START2 = "전체 일치"
EA_XLOOKUP_RESULT1 = "주문 검색 결과"
EA_XLOOKUP_RESULT2 = "개 일치"
EA_XLOAD_LOAD = "\124cffFFFF00EventAlertMod\124r: 주문 모니터링 트리거 알림, 로드된 버전: \124cff00FFFF"

EA_XGRPALERT_CHECKCD = "스킬 쿨타임 확인:"

EA_XGRPALERT_HEALTH = "체력:"
EA_XGRPALERT_COMPARES = {
[1]={text="<", value=1},
[2]={text="<=", value=2},
[3]={text="=", value=3},
[4]={text=">=", value=4},
[5]={text=">", value=5},
[6]={text="<>", value=6},
[7]={text="*", value=7}, --any
}
EA_XGRPALERT_COMPARETYPES = {
[1]={text="값", value=1},
[2]={text="백분율", value=2},
}
EA_XGRPALERT_CHECKAURA = "버프/디버프 확인:"
EA_XGRPALERT_CHECKAURAS = {
[1]={text="존재", value=1},
[2]={text="부재", value=2},
}
EA_XGRPALERT_AURATIME = "시간:"
EA_XGRPALERT_AURASTACK = "스택:"
EA_XGRPALERT_CASTBYPLAYER = "플레이어만 시전"
EA_XGRPALERT_COMBOPOINT = "연계 점수:"

EA_XLOOKUP_START1 = "스킬 이름 검색"
EA_XLOOKUP_START2 = "정확히 일치"
EA_XLOOKUP_RESULT1 = "검색 결과"
EA_XLOOKUP_RESULT2 = "개 일치"
EA_XLOAD_LOAD = "\124cffFFFF00EventAlertMod\124r: 스킬 모니터링 트리거 알림이 로드됨, 버전:\124cff00FFFF"

EA_XLOAD_FIRST_LOAD = "\124cffFF0000 EventAlertMod 효과 트리거 팁 UI를 처음으로 로드하고 기본 매개변수를로드합니다. \124r.\n\n"..
"매개변수 설정, 주문 모니터링, 위치 조정을위한 \124cffFFFF00/eam opt\124r를 사용하십시오.\n\n"

EA_XLOAD_NEWVERSION_LOAD = "\124cffFFFF00/eam help\124r를 사용하여 자세한 명령어 지침을 확인하십시오.\n\n\n"..
"\124cff00FFFF- 주요 업데이트 항목 -\124r\n\n"..
"*기능 추가: 그룹 단위의 다중 판단 조건 이벤트 트리거 기능.\n\n"..
"현재 감지 이벤트 지원:\n"..
"1. '대상'의 '에너지', '이상 또는 이하'시 특정 '값 또는 비율' 트리거\n"..
"2. '대상'의 '체력', '이상 또는 이하'시 특정 '값 또는 비율' 트리거\n"..
"3. '대상'의 'Buff/Debuff', '특정 주문 ID가 포함'될 경우 (층 수 또는 초 단위로 필터링 가능), 또는 '특정 주문 ID가 포함되지 않은' 경우 트리거\n"..
"4. '플레이어'가 '대상'에 대해 '연속 횟수'가 특정 '값 이상 또는 이하'시 트리거\n"..
"위 모든 조건은 AND 또는 OR로 사용할 수 있으며 하나 이상의 조건으로 필터링 할 수 있습니다.\n"..
"필터링 결과가 참이면 지정된 패턴을 알립니다.\n"..
"" -- END OF NEWVERSION

EA_XCMD_VER = " \124cff00FFFF By Whitep@雷鱗\124r 버전: "
EA_XCMD_DEBUG = " 모드: "
EA_XCMD_SELFLIST = " 자신의 Buff/Debuff 표시: "
EA_XCMD_TARGETLIST = " 대상의 Debuff 표시: "
EA_XCMD_CASTSPELL = " 시전 주문 ID 표시: "
EA_XCMD_AUTOADD_SELFLIST = " 자동으로 자신의 전체 상승/하강 효과 추가: "
EA_XCMD_ENVADD_SELFLIST = " 자동으로 자신의 환경 상승/하강 효과 추가: "
EA_XCMD_DEBUG_P0 = "트리거 주문 목록"
EA_XCMD_DEBUG_P1 = "주문"
EA_XCMD_DEBUG_P2 = "주문 ID"
EA_XCMD_DEBUG_P3 = "층"
EA_XCMD_DEBUG_P4 = "지속 시간 (초)"

EA_XCMD_CMDHELP = {
["TITLE"] = "\124cffFFFF00EventAlertMod\124r \124cff00FF00명령어\124r 설명(/eventalertmod or /eam):",
["OPT"] = "\124cff00FF00/eam options(또는 opt)\124r - 메인 설정 창 표시/숨기기.",
["HELP"] = "\124cff00FF00/eam help\124r - 추가 명령어 설명 표시.",
["SHOW"] = {
"\124cff00FF00/eam show [sec]\124r -",
">플레이어<가 가진 모든 버프/디버프의 주문 ID를 지속적으로 열거합니다. 그리고 지속 시간이 sec초 이내인 주문",
},
["SHOWT"] = {
"\124cff00FF00/eam showtarget(또는 showt) [sec]\124r -",
">대상<이 가진 모든 디버프의 주문 ID를 지속적으로 열거합니다. 그리고 지속 시간이 sec초 이내인 주문",
},
["SHOWC"] = {
"\124cff00FF00/eam showcast(또는 showc)\124r -",
"주문 시전에 성공한 후 시전한 주문 ID를 나열합니다.",
},
["SHOWA"] = {
"\124cff00FF00/eam showautoadd(또는 showa) [sec]\124r -",
">플레이어<가 가진 모든 버프/디버프의 주문을 자동으로 모니터링 목록에 추가합니다. 그리고 지속 시간이 sec초(기본값은 60초) 이내인 주문",
},
["SHOWE"] = {
"\124cff00FF00/eam showenvadd(또는 showe) [sec]\124r -",
">플레이어<가 가진 버프/디버프의 주문(단, 공격대 및 파티원에서 온 것은 제외)을 자동으로 모니터링 목록에 추가합니다. 그리고 지속 시간이 sec초(기본값은 60초) 이내인 주문",
},
["LIST"] = {
"\124cff00FF00/eam list\124r - 트리거 주문 목록 표시",
"show, showc, showt, lookup, lookupfull 명령어의 출력 결과 표시/숨기기",
},
["LOOKUP"] = {
"\124cff00FF00/eam lookup(또는 l) 검색어\124r - 일부 검색어로 주문 ID를 검색합니다.",
"게임에서 사용 가능한 모든 주문을 검색하고 검색어와 일치하는 주문 ID를 열거합니다.",
},

["LOOKUPFULL"] = {
"\124cff00FF00/eam lookupfull(또는 lf) 이름\124r - 전체 이름으로 주문 ID 검색",
"모든 주문을 검색하고 이름과 정확히 일치하는 주문 ID를 모두 나열합니다.",
},
}
end