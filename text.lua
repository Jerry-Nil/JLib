--START 准备施放技能或者开始读条 SUCCESS 施放成功 CREATE 制造物品成功 FAILED 技能施放失败
--SAY 白字喊话 YELL 红字喊话 GROUP 队伍喊话(团队/小队/副本队伍) WHISPER 密语
--{'信息','频道'}为一个信息发送单位,单个信息{{'信息','频道'}},多个信息{{'信息1','频道1'},{'信息2','频道2'},{'信息n','频道n'}}
--战士
--圣骑士
--死亡骑士
--萨满祭司
--猎人
--德鲁伊
--潜行者
--武僧
--术士
--法师
--牧师
JLib.Msg = {
	['START'] = {
		--XD
		['起死回生'] = {{'正在复活%target,其他奶妈请转火','GROUP'},{'正在对你施放%spell','WHISPER'}},
		['复生'] = {{'正在复活%target,其他奶妈请转火','GROUP'},{'正在对你施放%spell','WHISPER'}},
		--WS
		['轮回转世'] = {{'正在复活%target,其他奶妈请转火','GROUP'},{'正在对你施放%spell','WHISPER'}},
		['快速治疗222'] = {{'快速治疗---%spell','GROUP'}}
	},
	['SUCCESS'] = {
		--QS
		['炽热防御者'] = {{'春哥啦，我好怕怕','SAY'}},
		['圣盾术'] = {{'吾以圣光之名!','YELL'}},
		['保护之手'] = {{'%spell→%target','GROUP'},{'已经对你施放%spell','WHISPER'}},
		['牺牲之手'] = {{'%spell→%target','GROUP'},{'已经对你施放%spell','WHISPER'}},
		['自由之手'] = {{'%spell→%target','GROUP'},{'已经对你施放%spell','WHISPER'}},
		['拯救之手'] = {{'%spell→%target','GROUP'},{'已经对你施放%spell','WHISPER'}},
		--ZS
		['剑刃风暴'] = {{'大风车吱呀吱哟哟地转，对面的敌人你快完蛋！','YELL'}},
		['天神下凡'] = {{'看老子变粗变大变黑！','YELL'}},
		--DK
		['复活盟友'] = {{'以黑暗之名,战斗吧%target','GROUP'}},
		['炼狱'] = {{'信春哥，顶三秒','SAY'}},
		--XD
		['宁静'] = {{'自然的力量听我调遣……','SAY'}},
		['起死回生'] = {{'成功复活%target','GROUP'},{'快起来，不要躺地板了','WHISPER'}},
		['复生'] = {{'成功复活%target','GROUP'},{'已经%spell，请看情况起来','WHISPER'}},
		['激活'] = {{'已经对%target施放%spell','GROUP'},{'已经对你施放%spell','WHISPER'}},
		--WS
		['轮回转世'] = {{'正在复活%target','GROUP'},{'快起来，不要躺地板了','WHISPER'}},
		['壮胆酒'] = {{'劝君更尽%spell，西出阳关无故人...哎妈呀好疼','GROUP'}},
		['分筋错骨'] = {{'葵花点穴手！','SAY'},{'%spell => %target','GROUP'}},
		--DZ
		['嫁祸诀窍'] = {{'已经对你施放%spell!持续6秒!伤害提高15%!','WHISPER'}},
		['凿击'] = {{'已对%target%spell','SAY'}},
		['闷棍'] = {{'已对%target%spell','SAY'}},
		['脚踢'] = {{'%target，踢爆你!','SAY'}},
		--SS
		['召唤仪式'] = {{'开电视啦速速来俩小伙伴搭把手啦','GROUP'}},
		['制造灵魂之井'] = --{{'翔尚温，诸公何不分而啖之？','GROUP'}},
							{{'马桶已经就绪，要吃翔的小伙伴快来拿','GROUP'}},
		['恶魔法阵：传送'] = {{'瞬身术!','SAY'}},
		['灵魂石'] = {{'吾以执掌灵魂之力命汝魂归来兮!>>%target<<!','GROUP'}},
		['不灭决心'] = {{'%player已经施放%spell!请注意治疗!','GROUP'}},
		--MS
		['消散'] = {{'朕已%spell!太医何在？','SAY'}},
		['痛苦压制'] = {{'已对%target%spell','SAY'}},
		--['光晕'] = {{'','SAY'}},
		--FS
		['灸灼'] = {{'要死啦','SAY'},{'救命啊','SAY'},{'奶妈在哪里啊','SAY'}},
		['寒冰屏障'] = {{'啊……我的腰!','YELL'}},
		['变形术'] = {{'%spell ==> %target!','YELL'}},
		['时间扭曲'] = {{'时间，是一张纠结的网……','SAY'}},
		['操控时间'] = {{'秘术·时间操控之术！','YELL'}},
		['镜像'] = {{'禁术·多重影分身！','YELL'}},
		--SM
		['嗜血'] = {{'嗜血已开~嗷嗷嗷！','GROUP'}},
		--LR
		['误导'] = {{'%spell ==> %target','SAY'}},
		['群兽奔腾'] = {{'现在让我来告诉你们什么是数量优势','SAY'}},
		--种族
		--['奥术洪流'] = {{'%spell ==> %target!','YELL'}}
	},
	['CREATE'] = {},
	['FAILED'] = {},
	['AURA_APPLIED'] = {
		['幻觉'] = {{'秘法·变身术','SAY'}},
	},
	['AURA_REMOVED'] = {
		--FS
		['操控时间'] = {{'秘术·时间操控之术·开!','YELL'}},
		['时间扭曲'] = {{'时之砂随风而逝!','SAY'}}
	},
	['AURA_REFRESH'] = {}
}