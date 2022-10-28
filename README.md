# EventAlertModAll
版本合併
#   EventAlertMod
--  WOW Addons : EventAlertMod for Shadowland PTR
    本版本僅在WOW 9.0 SHADOWLAND PTR測試, 8.0 BFA正服未測試過
    
CHANGELOG:     
---    
https://github.com/ziyuefan/EventAlertModAll/blob/DF_WOTLKC_20221028-1/changelog.txt

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

## 以下指令說明不分大小寫:

> /eam SCDRemoveWhenCooldown
開關型指令,技能冷卻圖示在冷卻完成後移除(true表示要移除;false表示不移除)

> /eam SCDNocombatStillKeep
開關型指令,技能冷卻圖示在脫離戰鬥後是否仍顯示(true保持顯示;false 脫戰不顯示)

> /eam SCDGlowWhenUsable
開關型指令,技能冷卻是否在可用時高亮(true表示可用時高亮false則否)
這指令特別說明其使用IsUsableSpell()判斷,
也就是如果該指令因為資源或有減益導致無法施放
或者無法滿足其技能條件,則不會高亮
但是距離不在此限

> /eam MiniMap [reset]
開關型指令,用來顯示設定齒輪顯示與否
,加上 reset 強制定位定位到小地圖左下角

> /eam UpdateInterval  n
設定更新頻率,越小越快,若有團戰無法負荷情況請加大此數值
預設 0.1S (0.1 ~ 1秒)

> /eam IconAppenSpellTip
開關形指令, 圖示是否在滑鼠移過時顯示法術說明

> /eam ShowRunesBar
開關型指令,用來決定是否顯示死騎符文列(2020/10/18新增)

> /eam BaseFontSize n
由於字體大小不再跟隨圖示大小縮放,
所以另提供指令更改基礎字體大小,
計時、堆疊、名稱皆與此基礎字體大
小做等比例縮放
