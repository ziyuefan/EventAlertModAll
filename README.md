# [ChangLog](https://github.com/ziyuefan/EventAlertModAll/blob/main/README.md#changlog "ChangLog")
# [CommandLine](https://github.com/ziyuefan/EventAlertModAll/blob/main/README.md#command-line "CommandLine")
# [ScreenShot](https://github.com/ziyuefan/EventAlertModAll/blob/main/README.md#screenshot-2 "ScreenShot")

---
#### [Retail  DF    ]2023.03.23
#### [Classic WOTLKC]2023.03.23
- DF:更新版號到10.0.7
- 大幅度將函數與變數從全域空間(_G)移動到插件專屬空間階層(_G.EventAlertMod),以減少互相干擾
- 修正一些小bug1. 
---
#### [Retail  DF    ]2023.02.24
#### [Classic WOTLKC]2023.02.24
- DF:增加活力(精力Vigor)提示
- DF:修復滑鼠提示無法顯示MACRO的法術ID
---
#### [Retail  DF    ]2023.02.18
#### [Classic WOTLKC]2023.02.18
- 物品法術快取表的建立改以協程方式獲取,以避免卡頓
- DF: 支援喚能師(Evoker)職業、支援龍能(Essence)顯示
---
#### [Retail  DF    ]2022.12.22
#### [Classic WOTLKC]2022.12.22
- 修復比重排序
---
#### [Retail  DF    ]2022.11.18
#### [Classic WOTLKC]2022.11.18
- DF:修復鼠標提示法術ID與物品ID顯示
- DF:移除 /eam basefontsize 指令
- DF:增加 /eam StackFontSize nSize 指令以改變堆疊層數大小(不分大小寫,亦可以/eam sfs nSize代替)
- DF:增加 /eam TimerFontSize nSize 以改變計時數字大小(不分大小寫,亦可以/eam tfs nSize代替)
- DF:增加 /eam SNameFontSize nSize 以改變法術名稱大小(不分大小寫,亦可以/eam nfs nSize代替)
- WOTLKC:測試相容性OK
---
#### [Classic WOTLKC]2022.10.28
#### [Retail  DF    ]2022.10.28
- DF:異動Button及CheckButton使用模板,以使正常顯示
- DF:移除XML內未用屬性避免WARNING報錯
- WOTLKC: 相容性測試OK
---
#### [Classic WOTLKC]2022.10.18
#### [Retail  SL    ]2022.10.18
- 冷卻模組暫時不再偵測背包物品冷卻以增進效能(背包物品的冷卻將偵測不到)
---
#### [Classic WOTLKC]2022.10.01
- 修復相關專精函數造成WLK版本之錯誤,並與SL版本相容
---
#### [Classic WOTLKC]2022.09.27
- 修復BUFF顯示
---
#### [Classic WOTLKC] 2022.09.26
- 以SL 9.2.5 版本之EAM重新作為WOTLKC之基礎版本
- 修復DK符文顯示,符文圖示以當前領域為主
- 修復DK符能顯示
---
#### [Classic WOTLKC] 2022.08.22
- TOC 架構更新, 版本更新
---
#### [Classic TBC] 2021.06.25
- 回覆寵物集中值顯示
- 優化法力顯示
- 修復物品法術冷卻之卡頓
- 物品法術快取不再由玩家建立,改為每次釋出新版本更新快取
---
#### [Classic TBC] 2021.06.22
- 防止使用專精相關API而導致報錯
---
#### [Classic TBC] 2021.05.22
- 移除事件:ACTIVE_GROUP_TALENT
- 加入事件:UNIT_SPELLCAST_SUCCEEDED,並改變為符合版本規定之參數順序
---
#### [Classic TBC] 2021.05.21
- 基於SL 2021.04.14 進行修改TBC版本,故繼承該版本及之前特性
- 增加顯示法力值,並顯示法力百分比
---
#### [SL] 2021.06.26
- 優化效能,減少卡頓
---
#### [SL] 2021.04.14
- 改善物品冷卻顯示正確性(比對優先級:已裝備物品(Inventory) > 背包物品(Bag) > 第一次建立的資料庫(EA_SPELL_ITEM))
- 針對工程附魔硝基推進器的ID做特別處理(GetItemSpell取得皆為55004,但使用觸發皆為54861)
- 於物品滑鼠提示內的法術ID增加顯示法術名稱
---
#### [SL] 2020.12.26
- 惡魔獵人復仇專精與災虐專精統一使用魔怒(Fury)資源,魔痛(Pain)已不再使用
- 條件技能內請勿再使用魔痛
- 德魯伊時將連擊點數放第一格,能量放第二格,怒氣放第三格
- 德魯伊平衡專精時將星能改放在第一格,連擊點數放第四格
- 修正切換專精時連擊點數資源不更新的問題
- ShowAuraValueWhenOver預設值改為10
---
#### [SL] 2020.11.17
- 變更法術細部設定背景透明度,使其不與其他框架干擾
- 修正法術細部設定法術文字綠色背景問題
- 修正:啟用ESC關閉提示功能時,ESC無法關閉框架問題,另技能提醒的部份仍不受ESC關閉,
且ESC將成為顯示開關,按一次關、按一次開, 並可戰鬥中開關
---
#### [SL] 2020.11.03
- 修正DK符文報錯
---
#### [SL] 2020.11.01
- 變更DK符文圖案,使其符合版本
- 符文數量會顯示專精,例如:穢邪符文、冰霜符文、血魄符文
- 字型基礎大小值改為自訂, 不再跟隨圖示大小縮放可輸入 /eam BaseFontSize nSize 
自訂大小而計時、堆疊、名稱將以這個基礎值做框外或框內等比例縮放有興趣者可以到
EventAlert_IconOptions.lua 找函數EventAlert_Icon_Options_Frame_AdjustTimerFontSize
自行修改,首次執行預設值為26
- 斬殺動畫...調整, 並且可以/eam play 播放
- 新增及增加Minimap齒輪的滑鼠提示輔助說明
---
#### [SL] 2020.10.26
- 修復連擊點高亮, 並一律以最大值高亮(依專精天賦可能不同)
- 修復獵人寵物集中值高亮,並預設50高亮,
   可配合手動施放寵物傷害技能時,最大化傷害.
- FontObject(EA_FONT_OBJECT) 儘可能以"TextStatusBarText"為主,否則以"ChatFontNoramal"為主
- Font (EA_Fonts) 拉取系統預設值 STANDARD_TEXT_FONT,以/dump STANDARD_TEXT_FONT 可能因語系出現不同標準字型檔
- 以上兩項可於 EventAlertMod_InitVar.lua進行修改
- 將大部分框架層級由HIGH降至MEDIUM ,嘗試減少與其他框架遮擋現象
- 圖示大小每次滑動調整值由5改為1
- 當偵測OmniCC被載入且EAM也啟用倒數陰影功能時, 強制關閉EAM的倒數陰影,避免被OmniCC攔截顯示造成干擾
---
#### [SL] 2020.10.18
- 變更秘法充能圖案
- 修正術士報錯
- DK 增加可用符文數量顯示,若達6個可用符文則高亮
- DK 可透過/eam ShowRunesBar 切換顯示符文列
---
#### [SL] 2020.10.17
- 修復真氣顯示
- 修復坦DH資源顯示(魔痛)
- 暗牧瘋狂值達到瘟疫需求值50高亮
- 狂戰怒氣達到暴怒需求值80高亮
- 武戰怒氣達到斬殺最大傷害需求值40高亮
- 防戰怒氣達到無視苦痛需求值40高亮
- 平衡德魯伊星能達到星隕術需求值50高亮
- 加大字體(須調整圖示大小才會跟著調整字體大小)
---
#### [SL] 2020.10.04
- 包裝GetSpellDurationByDesc() 到 Lib_ZYF
---
#### [SL] 2020.08.23
- 修復術士靈魂碎片及碎塊顯示問題
- 修復能力框架內不顯示數字
---
#### [SL] 2020.08.22
- 修改非光環式地面效果的比對PATTERN使之可以在PTR比對到  例如:116011(主動力之符文)、342130(被動力之符文)
(註:這類效果需要在自身增減益輸入施法ID,而非BUFF ID,須特別注意)
---
#### [SL] 2020.08.16
- 更新TOC版本號到9.0(90001)
- 因應暴雪對backdrop的操作異動做相關修改使顯示正常
- LibButtonGLow的高亮函式壞掉,改用LibCustomGLow的LibStub("LibCustomGlow-1.0").ButtonGlow_Start(eaf)及
LibStub("LibCustomGlow-1.0").ButtonGlow_Stop(eaf)
- 其他忘記改了啥東西
---
#### [BFA] 2019.06.27
- 更新版本號到8.2
- 修復:由於播放音效API不再支援PATH形式,所以產生錯誤目前全都到https://wow.tools/files/ 找到對應ID代入
---
#### [BFA] 2019.06.07
- 修正:武僧真氣顯示(LIGHTFORCE均改為CHI)
---
#### [BFA] 2018.11.24
- 修正:/eam iconappespelltip 選項功能,使其可以正常開關滑鼠提示,也允許滑鼠點擊穿透
---
#### [BFA] 2018.11.05
- 群組條件技能提示增加條件滿足時高亮的選項
- 若屬於天賦技能,但未點出,則不會進行判斷與顯示(以第一組子條件的法術ID以及當前專精作為依據)
---
#### [BFA] 2018.10.12
- 修復:自身與目標debuff 不顯示紅色與綠色的問題
- 修復:技能冷卻模組圖示閃爍問題
- 優化:建立物品法術對應快取表不再嚴重卡頓(但仍然有一點小卡)並會提示建立快取進度,
建議耐心等待快取建立完成.(為了避免嚴重卡頓而分攤到250秒內完成,所以會比之前等待時間更久)
- 技能冷卻增加剩餘秒數紅字提示之設定(請於齒輪內設定)
- 剩餘秒數紅字提示放大10%大小依(依框內或框外之倒數數字放大)
- 非光環式技能持續時間增加了一個比對正則式, 讓烏鴉獵殺可以被判定到
---
#### [BFA] 2018.10.02
- 修復非光環式技能會顯示到自身以外玩家的問題
- 修復堆疊數字閃爍問題(可在EventAlert_IconOption.lua內找到
EventAlert_Icon_Options_Frame_AdjustTimerFontSize來修改比例)
---
#### [BFA] 2018.09.29
- PositionFrame(), TarPositionFrame(0, ScdPositionFrame()不再一有事件就更新,
改以每0.1秒定時更新圖示,以求大幅降低cpu使用率, 從而避免團戰時大量事件引起的LAG
---
#### [BFA] 2018.09.03
- 加強非光環式持續效果正確性
---
#### [BFA] 2018.08.29
- 支援無光環之技能持續秒數,請在本職業提示模組輸入"技能法術ID",程式會自動抓取技能提示內的持續時間,
若抓取不到,請查閱修改localization.tw.lua內的EA_XCMD_SPELL_DURATION_PATTERN1,
EA_XCMD_SPELL_DURATION_PATTERN2的正則表達式例如暴風雪(190356),鏡像(55342),
冰霜之球(84714),力之符文(116011)等等
P.S.116011是符文持續時間,116014是在符文有效範圍內才會出現的BUFF
---
#### [BFA] 2018.08.25
- 新增指令 /eam NewLineByIconCount (2~n)
冷卻模組部份,每隔多少圖示自動跳到下一列
- 新增指令 /eam UpdateInterval
控制OnUpdate頻率,超過0.1秒則小數點顯示會不正常, 但是較不會延遲
- 一些特殊指令會在設定圖示的滑鼠提示顯示
---
#### [LEG] 2017.09.01
- 修正- 修復主選單設置無法保存問題
- 修正- 修復7.3 PlaySound函數因引用參數類型改變造成的錯誤
- 毀滅術士的碎片會顯示到小數點
---
#### [LEG] 2017.07.09
- 增加招喚圖騰型法術監控，在自身BUFF內輸入招喚型施法法術ID
例如力之符文、薩滿圖騰、屈心魔等等
- /eam showc 若啟用，增加顯示招喚型法術ID
---
#### [LEG] 2017.07.01
- 加入邪DK黑暗仲裁者支援
- 黃色字體改回白色字體
- 修復冷卻計時錯誤
- 修復在技能冷卻結束時提示不消失的狀態下(/eam scdremovewhencooldown 等於false 時),部份技能卻在冷卻在完成消失的BUG
---
#### [LEG] 2017.06.29
- 修復因加入物品CD功能而導致技能CD失常的現象
---
#### [LEG] 2017.06.26
- 再次調整.toc檔內引用UIDropDownMenu相關檔案的順序(XML必須比LUA檔更早引用,且LibStub必須更早引用)
- BUFF,DEBUFF 額外數值(value1~3) 若超過1萬則以萬為單位顯示
---
#### [LEG] 2017.06.23
- 針對力之符文(116014)做特別處理(SPELL_SUMMON事件紀錄開始時間,EventAlert_Buffs_Update函式強迫寫入持續時間10秒)
- 修正UIDropDownMenu調用不完全的問題(toc加入另外兩個lua的路徑)   
---
#### [LEG] 2017.06.21
- 針對taint 問題調用 UIDropDownMenu修正用函式庫及新版的 LibButtonGlow1.0 函式庫來降低taint的產生
- 技能冷卻增加了物品冷卻，但是不可以輸入物品ID(Item ID),只能輸入施放的法術ID萊建立，
可使用/eam showc 來查詢，然而物品的CD若是"使用型"則可以透過GetSpellBaseCooldown(法術ID)來查詢
,程式會自動判別,但若是特定條件觸發且有內置CD的則需要玩家手動輸入固定值，目前用比較不方便的作法就
是在法術ID的輸入格式後面以分號(;)隔開輸入冷卻秒數。例如:
賽弗斯的祕密就輸入208052;30
吸收盾項鍊 207452;30
輸入後若無法馬上作用請/rl或/reload 重載UI
若曾經建立過該法術ID但沒有輸入過秒數或秒數錯誤，則請先刪除，再重新建立。之後再找時間改善
- 計數文字改為黃色並且加上陰影
- 堆疊文字加大並加上陰影
---
#### [LEG] 2017.06.19
- 修復冷卻模塊排序前置作業存取到空的表格產生的nil 存取錯誤
---
#### [LEG] 2017.06.16
- 技能冷卻模塊現在可以設定比重排序了(其他4項暫時無效果，建議不要設定)
- 條件式群組技能將連擊點由"連擊點異動類"移到"對象能量異動類"
- 修復條件式群組技能連擊點失效問題
- 修復條件式群組技能第三個專精無法勾選問題
- 修復跨職業增減益區由物品觸發的增減益無法顯示的錯誤。
- 修復在星界能量轉換到UpdateSinglePower函數處理後仍有程式碼片段引用舊函數UpdateLunarPower 所導致的錯誤。
- 星能變更了一個圖案，使其較有"星"的感覺。
- 調整職業資源高亮邏輯:狂怒戰士怒氣配合暴怒技能，85以上高亮，若天賦有點大屠殺，則70以上高亮
- 調整職業資源高亮邏輯:暗牧瘋狂值，若天賦點了殘遺虛無，則65以上就高亮。
- 調整職業資源高亮邏輯:平衡德星能達到星湧術40星能需求就高亮
---
#### [LEG] 2016.08.27
- EA_Config2 內的變數將只成為首次安裝的預設值，之後的所有變更將存入EA_Config存檔並作為下次載入之來源。簡單說，每次更版時，將保留屬於玩家自己的設定。遊戲內可以輸入 EA_Config.變數名稱=指定內容 的格式來變更並儲存。
- 設置圖標增加了控制變數 OPTION_ICON, 並在/eam minimap 切換顯示的同時也變更該變數 以作為下次載入依據。
- 增加參數 /eam showeaconfig, /eam showeaposition 來顯示玩家設置內容
- 修正簡體版、英文版本地化文件內容錯誤造成星界能量無法顯示
- 獵人寵物集中值改到圖形介面內做勾選式開關，並移除HUNTER_ShowPetFocus變數
- 修復即使勾選僅顯示玩家施放之選項仍會顯示他人增減益的錯誤(self變數未正確儲存)   (有問題的BUFF/DEBUFF ID 必須刪除重建)
- 顯示value,value,value3 的功能以一個下限值EA_Config.ShowAuraValueWhenOver來決定是否顯示。目前預設下限值為1000
- *[未完成]*:自身/目標的BUFF/DEBUFF倒數N秒高亮提示
- *[未完成]*:嘗試將特殊資源與自身BUFF分開
- *[未完成]*:ENERGY框架脫戰後消失
---
#### [LEG] 2016.08.22
- 設置圖標可用 /eam minimap 切換啟用/關閉
- 設置圖標可用右鍵移動(拖曳後之新位置將被暴雪自動存到各角色下的layout-local.txt，上線時將自動還原到最後位置)
- 新增: 輸入 /eam scdremovewhencooldown 直接切換EA_Config2.SCD_RemoveWhenCooldown變數來控制冷卻框架行為
(true表示單一技能冷卻完成即消失,false表示即使完成也不消失)
(不會存檔，下次登入時仍會按照Addons\EventAlertMod\EventAlertMod.lua內的設置)
- 新增: 輸入 /eam scdnocombatstillkeep 直接切換EA_Config2.SCD_NocombatStillKeep變數來控制冷卻框架行為(true表示脫離戰鬥仍然保持框架，false表示脫離戰鬥冷卻框架消失)   (不會存檔，下次登入時仍會按照Addons\EventAlertMod\EventAlertMod.lua內的設置)
- 計時器若在框體外(0.65倍框體大小)，則堆疊數字調大(0.45倍框體大小);計時器若在框體內(0.5倍框體大小)，堆疊數字大小調小(0.3倍框體大小)
- 在增減益下方顯示value1,value2,value3(若有的話),期能顯示吸收值
- 修正:當技能額外提示輸入了非職業所屬之技能ID時，會讓自身增減益模塊的若干BUFF產生錯誤，包含了不顯示時間或不正確的時間。
- 修正:條件式群組技能的存檔未納入新的副資源代碼，導致無法正確反應使用者的設置。(加入薩滿元能MAELSTROM、祕法充能ARCANE_CHARGES、惡魔獵人的魔怒FURY、魔痛PAIN)
---
#### [LEG] 2016.08.16
- 惡魔獵人增加PAIN 能量(坦克)
- 調整框架文字比例(隨圖示大小比例調整)
- 在小地圖附近增加一個齒輪圖示可點擊開啟主設定視窗，並在鼠標懸停時顯示提示說明
---
#### [LEG] 2016.08.11
- 修正:更新符文函數內的一行程式碼在DK登入遊戲時會造成報錯
- 修正:充能型技能在SCD_RemoveWhenCooldown啟用時，只消耗一次就把框架隱藏的問題。
- 條件式群組技能內的天賦改為專精，增加為4個,並顯示專精名稱。依照最大專精數量顯示
- 增加惡魔獵人相關程式碼
---
#### [LEG] 2016.08.09
- 調整:DK符文框架脫戰後消失
- 調整:DK符文框架附掛在自身BUFF的上方，並與BUFF同方向成長
- 調整:DK符文冷卻倒數數字比例調小
- 調整:移除EventAlertMod.lua內DK_ShowRunes變數，改為在圖形介面啟用關閉
- 新增:寵物BUFF/DEBUFF支援，以自身BUFF/DEBUFF模塊顯示
- 補充說明:寵物技能冷卻支援，以技能冷卻模塊顯示(早期已增加，但未加入說明)
- 修正:特殊職業資源取消勾選現在能即時生效
- 修正:預設法術ID因應版本刪除過時法術ID並加入大量7.0法術ID (可能無法滿足所有人)
---
#### [LEG] 2016.08.01
- 調整DK符文顯示大小, 解決卡頓問題
- BUFF 與 DEBUFF的滑鼠提示不再只是技能說明，而是當前的狀態數值，法術冷卻的框架則維持技能說明
- 堆疊次數小於2皆不顯示計數值，避免出現1的狀況。
- 連擊點數最大值若為6 則以6作為高亮值, 連擊點數若為8或5 則以5做為高亮值
- 若職業為盜賊則將能量的OFFSET 由-2改為-1
- 將間距調整顯示改為整數
---
#### [LEG] 2016.07.27
- 群組條件技能提示可以正常顯示指定圖案了，並加入新的特殊能量支援
- 新增法術時，預設僅顯示為玩家本人施放的BUFF/DEBUFF(點法術後的齒輪可以可見此選項)
- 修正當啟用倒數N秒後顯示小數時會讓特殊能量也出現小數點的問題(以timeLeft~=floor(timeLeft)來錯開)
- 修正EA_Config2.IsKeepGlowSCD 無法作用的問題
- 增加鼠標提示。
並以EA_Config2.ICON_APPEND_SPELL_TIP 變數作為開關
- 初始預設值為關閉所有職業特殊能量
- 初始預設值為關閉斬殺提示(星芒閃爍)
- "圖示位置選項"按鈕更名為:"圖示位置&職業特殊能量"(簡體:"图示位置&副资源")
以便於讓大家知道要去哪邊啟用關閉這些特殊POWER。
- EA_Config2變數更名:   
-- 脫離戰鬥後是否保持技能冷卻框架
SCD_NocombatStillKeep= true,
-- 當冷卻框架之技能達到可施放條件時高亮SCD_GlowWhenUsable		= true ,
-- 單一技能冷卻完成即移除(true:要移除/false:不移除)SCD_RemoveWhenCooldown= true,
-- 剩餘多少秒開始使用小數點一位顯示(使用0則完全不會有小數點)UseFloatSec= 1,
-- 是否顯示死騎符文(true:顯示/false:不顯示)DK_ShowRunes = false,
-- 是否顯示獵人寵物集中值HUNTER_ShowPetFocus= true,
-- 獵人寵物集中值高亮條件值(0表示不高亮)HUNTER_GlowPetFocus 	= 50,
---
#### [LEG] 2016.07.26
- 新增秘法充能資源(最大值高亮)
- 新增薩滿元能資源(最大值高亮)
---
#### [LEG] 2016.07.25
- 戰士/熊由於怒氣歸零時不會觸發UNIT_POWER，導致怒氣框架歸零後無法消失 ，所以增加 UNIT_FRUQUENT 事件來刷新怒氣框架。
- 死騎符文顯示6的問題。由於CreateFrames_SpecialFrames_Show內判定錯誤導致沒有刷新。已修正。符文顏色隨專精轉換。
- 在EventAlertMod.lua內的EA_Config2增加一個變數:DK_ShowRunes 來決定是否顯示符文。(true:顯示/false:不顯示)
- 對應武僧目前釀酒只有能量，風行有能量/真氣，織霧只有法力沒有能量真氣做對應的調整。
- 增加獵人寵物集中是否顯示的變數，由EA_Config2.HUNTER_ShowPetFocus來決定
- 增加獵人寵物集中值高亮條件值, 0表示不顯示高亮,預設值50。(寵物基本攻擊50集中以上有增傷)
- 暗牧瘋狂值達到上限會高亮
- 小數點變數變更為UseFloatSec, 表示低於此秒數才會使用小數點一位顯示若0 則表示完全不會顯示
- 鳥D 日月能移除，只剩下星能。

# [ChangLog](https://github.com/ziyuefan/EventAlertModAll/blob/main/README.md#changlog "ChangLog")
# [ScreenShot](https://github.com/ziyuefan/EventAlertModAll/blob/main/README.md#screenshot-2 "ScreenShot")

## Command Line

## 以下指令說明不分大小寫:

**/eam SCDRemoveWhenCooldown**

*開關型指令,技能冷卻圖示在冷卻完成後移除(true表示要移除;false表示不移除)*

**/eam SCDNocombatStillKeep**

*開關型指令,技能冷卻圖示在脫離戰鬥後是否仍顯示(true保持顯示;false 脫戰不顯示)*

**/eam SCDGlowWhenUsable**

*開關型指令,技能冷卻是否在可用時高亮(true表示可用時高亮false則否)
這指令特別說明其使用IsUsableSpell()判斷,也就是如果該指令因為資源或
有減益導致無法施放或者無法滿足其技能條件,則不會高亮但是距離不在此限*

**/eam MiniMap [reset]**

*開關型指令,用來顯示設定齒輪顯示與否,加上 reset 強制定位定位到小地圖左下角*

**/eam UpdateInterval  n**

*設定更新頻率,越小越快,若有團戰無法負荷情況請加大此數值,預設 0.1S (0.1 ~ 1秒)*

**/eam IconAppenSpellTip**

*開關形指令, 圖示是否在滑鼠移過時顯示法術說明*

**/eam ShowRunesBar**

*開關型指令,用來決定是否顯示死騎符文列(2020/10/18新增)*

**/eam StackFontSize nSize**

*指令以改變堆疊層數大小(不分大小寫,亦可以/eam sfs nSize代替)*

**/eam TimerFontSize nSize**

*以改變計時數字大小(不分大小寫,亦可以/eam tfs nSize代替)*

**/eam SNameFontSize nSize**

*以改變法術名稱大小(不分大小寫,亦可以/eam nfs nSize代替)*

# [ChangLog](https://github.com/ziyuefan/EventAlertModAll/blob/main/EventAlertMod/changelog.txt "ChangLog")

## Screenshot

![EAM Main](https://truth.bahamut.com.tw/s01/202008/1982fcd16ac80aaddfeb299f57a71e94.JPG)
![EAM Options](https://truth.bahamut.com.tw/s01/202008/cc3c05665af5fe7e3dae3dd5caa5acb5.JPG)
![EAM Self](https://truth.bahamut.com.tw/s01/202008/226588adaa20b9640c7cc00e8d8b6561.JPG)
![EAM Target](https://truth.bahamut.com.tw/s01/202008/0b6c52fcdf6fa73ac1d84c5a0198557f.JPG)
![EAM Other](https://truth.bahamut.com.tw/s01/202008/83af52716595ce311f7142f6085a1945.JPG)
![EAM Detail Option](https://truth.bahamut.com.tw/s01/202008/21cfb5148289c4480beca22cbf5e3c4a.JPG)
![EAM SCD](https://truth.bahamut.com.tw/s01/202008/1dd0d978d4daa6d4b5aab7b6308671d8.JPG)
![EAM Group](https://truth.bahamut.com.tw/s01/202008/198e63977a8ace11423675524c90f1d3.JPG)
![EAM Group Detail](https://truth.bahamut.com.tw/s01/202008/07c24ff7bc0d14fe9381b96f50905f52.JPG)
![EAM Minimap](https://truth.bahamut.com.tw/s01/202008/154db1c0ef239cd20035d3b91c2a140f.JPG)
![EAM Minimap Hint](https://truth.bahamut.com.tw/s01/202008/f1ee8bd0327ecd95f6d2ffea2f06d7ae.JPG)

# [ChangLog](https://github.com/ziyuefan/EventAlertModAll/blob/main/README.md#changlog "ChangLog")
# [CommandLine](https://github.com/ziyuefan/EventAlertModAll/blob/main/README.md#command-line "CommandLine")
# [ScreenShot](https://github.com/ziyuefan/EventAlertModAll/blob/main/README.md#screenshot-2 "ScreenShot")
