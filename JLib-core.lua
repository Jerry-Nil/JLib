--Author: Jerry
local major = 1
local minor = 1
local edition = 7
local version = string.format('%d.%d.%d', major, minor, edition)
local major_name = string.format('JLib-%d',major)
local JLib = LibStub:NewLibrary(major_name, minor)

if not JLib then
	return
end

JLib.frame = JLib.frame or CreateFrame("Frame")
JLib.spellFrame = JLib.spellFrame or CreateFrame("Frame")

JLib.debug = false
JLib.ver = version

local gameVersion, _, _, tocversion = GetBuildInfo()
local unitLevelMax
if gameVersion > '6.0.2' then
	unitLevelMax = 100 -- for WoD
else
	unitLevelMax = 90 -- for MoP
end

function JLib:Version()
	versionStr = '|cffffff00JLib '..JLib.ver..'|r'
	print(versionStr)
end
function getMsgChan()
	if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and IsInInstance() then
		return "INSTANCE_CHAT"
	else
		if IsInRaid() then
			return "RAID"
		elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
			return "PARTY"
		else
			return 'SAY'
		end
	end
end
local function nc(num)
	if num == nil then
		num = 0
	end
	if (num-num%1000)/1000>0 then
		return nc((num-num%1000)/1000)..", "..string.format("%03d",num%1000)
	else
		if num%1000 >0 then
			return num%1000
		else
			return "0"
		end
	end
end
local function nc2(num)
	local ret = ''
	if num == nil then
		num = 0
	end
	if num >= 1e8 then
		ret = (num-num%1e8)/1e8
		ret = ret..'亿'..nc2(num%1e8)
	elseif num >= 1e4 then
		ret = (num-num%1e4)/1e4
		if ret > 0 then
			ret = ret..'万'..nc2(num%1e4)
		else
			ret = nc2(num%1e4)
		end
	else
		if num > 0 then
			ret = num
		end
	end
	--print('IN FUNC:',ret)
	return ret
end
local function Talent()
	talnet = GetSpecialization()
	if talnet == nil then
		return '未知'
	else
		_,talnetName = GetSpecializationInfo(GetSpecialization())
		return talnetName
	end
end
function JLib:getXP(guild)
	local playerXPMax = UnitXPMax("player")
	local playerXP = UnitXP("player")
	local playerXPEx = GetXPExhaustion()
	local playerLevel = UnitLevel("player")
	local playerName = UnitName("player")
	local playerRace = UnitRace("player")
	local playerClass = UnitClass("player")
	local p = math.ceil(playerXP*100/playerXPMax)
	local totalIL, equippedIL = GetAverageItemLevel()
	local playerIL = math.floor(equippedIL)..'/'..math.floor(totalIL)
	local groupCount = GetNumGroupMembers()
	--partyCount = GetNumPartyMembers()
	-- if IsInInstance() then
	-- 	channel = 'INSTANCE_CHAT'
	-- elseif groupCount>5 then
	-- 	channel = "raid"
	-- elseif groupCount>0 then
	-- 	channel = "party"
	-- else
	-- 	channel = "say"
	-- end
	local channel = getMsgChan()
	if guild == true then
		channel = "guild"
	elseif guild == 2 then
		channel = 'INSTANCE_CHAT'
	end
	local msg = {}
	msg[1] = "JLib角色通告:"..playerName.."(Lv"..playerLevel..")"
	msg[2] = "装等:"..playerIL..' '..playerRace.." "..playerClass..'('..Talent()..')'
	if playerLevel < unitLevelMax then
		msg[3] = "当前经验:"..nc(playerXP).."/"..nc(playerXPMax).."("..p.."%)"
		msg[4] = "当前可用双倍:"..nc(playerXPEx)
		msg[5] = "还需要"..nc(playerXPMax-playerXP).."升级"
	end
	for i=1, #msg do
		if channel == 'SAY' then
			print('|cffffff00'..msg[i])
		else
			SendChatMessage(msg[i],channel)
		end
	end
end

local function c1()
	for x=1,46 do
		local name, _,completed, _, _, _, _, assetID = GetAchievementCriteriaInfo(7281, x)
		if completed == true then
			print('|cffffff00'..x, name,completed,assetID,GetQuestsCompleted()[tonumber(assetID) ])
		else
			print('|cff00ff00'..x, name,completed,assetID,GetQuestsCompleted()[tonumber(assetID) ])
		end
	end
end

function worldboss()
	bosses = {
		["炮舰"] = 32098,
		["怒之煞"] = 32099,
		["纳拉克"] = 32518,
		["乌达斯塔"] = 32519
	}
	for k, v in pairs(bosses) do
		print(format("|cffffff00%s|r: %s", k, IsQuestFlaggedCompleted(v) and "|cff00ff00已杀|r" or "|cffff0000未杀|r"))
	end
end

JLib.frame:SetScript("OnEvent", function(self, event, name, ...)
	local arg1,arg2,arg3,arg4,arg5 = select(1, ...)
	-- print(arg1..'<>'..arg2..'<>'..arg3..'<>'..arg4..'<>'..arg5..'<>'..arg6..'<>'..arg7..'<>'..arg8..'<>'..arg9)
	if event == "PLAYER_LEVEL_UP" then
		channel = getMsgChan()
		playerName = UnitName("player")
		playerLevel = UnitLevel("player")+1
		if channel == 'SAY' then
			print("|cffffff00JLib角色通告:"..playerName.."(Lv"..playerLevel..")升级了!")
		else
			SendChatMessage("JLib角色通告:"..playerName.."(Lv"..playerLevel..")升级了!",channel)
		end
	end
end)

JLib.spellFrame:SetScript('OnEvent', function(self, event, ...)
	local timestamp, eventType, hideCaster, sourceGUID, sourceName,  sourceFlags, sourceRaidFlags, destGUID,
			destName, destFlags, destRaidFlags, spellID, spellName, spellSchool = select(1, ...)
	local filter = bit.bor(COMBATLOG_OBJECT_AFFILIATION_OUTSIDER, COMBATLOG_OBJECT_REACTION_FRIENDLY, COMBATLOG_OBJECT_CONTROL_MASK, COMBATLOG_OBJECT_TYPE_MASK)
	local y = "|cffffff00"
	local w = "|cffffffff"
	local endstr = "|r"
	eventTypeTable = {
		["SPELL_CAST_START"] = 'START', --'开始读条'
		["SPELL_CAST_SUCCESS"] = 'SUCCESS',--'制造成功\瞬发成功'
		["SPELL_CAST_CREATE"] = 'CREATE',--'制造\读条完毕'
		["SPELL_CAST_FAILED"] = 'FAILED',--'读条失败'
		["SPELL_AURA_APPLIED"] = 'AURA_APPLIED',--'得到增益效果'
		["SPELL_AURA_REMOVED"] = 'AURA_REMOVED',--'移除增益效果'
		["SPELL_AURA_REFRESH"] = 'AURA_REFRESH'--'刷新增益效果'
	}
	if sourceGUID == UnitGUID("player") or destGUID == UnitGUID("player") then
		--print(select(1, ...))
		local marg = {
			['eventType'] = eventType,
			['sourceName'] = sourceName,
			-- ['sourceFlags'] = sourceFlags,
			['destName'] = destName,
			--['destFlags'] = destFlags,
			['spellID'] = spellID,
			['spellName'] = spellName
		}
		str = ''
		if JLib.debug then
			print('start')
			for k, v in pairs(marg) do
				print(string.format("%s%s:%s%s%s",y,k,w,v,endstr))
			end
			print('end')
		end
	end
	if sourceGUID == UnitGUID("player") then -- or destGUID == UnitGUID("player") then
		local eItem = eventTypeTable[eventType]
		if eItem ~= nil then
			local mItem = JLib.Msg[eItem]
			if eItem == 'AURA_REMOVED' and destGUID ~= UnitGUID("player") then
			elseif mItem ~= nil then
				local sItem = mItem[spellID]--spellName]
				if type(sItem) == 'table' then
					for k,item in pairs(sItem) do
						local msg = item[1]
						local ch = item[2]
						if destName == nil then
							destName = ''
							-- return
						end
						msg,_ = string.gsub(msg,"%%target",destName)
						msg,_ = string.gsub(msg,"%%player",sourceName)
						msg,_ = string.gsub(msg,"%%spell",GetSpellLink(spellID))
						if destName == nil then
							destName = UnitName('player')
						end
						if ch == 'WHISPER' and destName ~= UnitName('player') then--and destName ~= nil and destName ~= '' then
							SendChatMessage(msg,ch,nil,destName)
						elseif ch == 'GROUP' then --and destName ~= nil and destName ~= '' then
							SendChatMessage(msg,getMsgChan())
						else
							SendChatMessage(msg,ch)
						end
					end
				end
			end
		else
		end
	end
end)

function JLib:Debug()
	if JLib.debug then
		JLib.debug=false
		print('|cffffff00Debug Mode:|cffff0000Off|r')
	else
		JLib.debug=true
		print('|cffffff00Debug Mode:|cff00ff00On|r')
	end
end

function ywlr()
	local strt = {
		[1] = '古代熊猫人鱼竿',
		[2] = '古代熊猫人伐木斧',
		[3] = '咔啡压榨机',
		[4] = '镶玉之刃',
		[5] = '卡桑沉船箱子',
		[6] = '武丁的螳螂刀',
		[7] = '古代熊猫人矿镐',
		[8] = '古代熊猫人茶壶',
		[9] = '熊猫人幸运硬币',
		[10] = '水语者法杖',
		[11] = '十雷之锤',
		[12] = '熊猫人仪式石',
		[13] = '兔妖宝箱',
		[14] = '一箱被偷的货物',
		[15] = '隐秘大师之杖',
		[16] = '蜥蜴人石板',
		[17] = '熊猫人鱼叉',
		[18] = '装备箱',
		[19] = '泡蕉朗姆酒',
		[20] = '林精的衣箱',
		[21] = '猢狲战士长矛',
		[22] = '猢狲宝箱',
		[23] = '失窃的林精宝藏',
		[24] = '雪怒雕像',
		[25] = '云壬的石板',
		[26] = '失踪探险者的随身物品',
		[27] = '里克提克的除虱器',
		[28] = '古代魔古石板',
		[29] = '野牛人武器箱',
		[30] = '陶俑头颅',
		[31] = '恐惧碎片',
		[32] = '科里维斯硬化树脂',
		[33] = '野牛人携火者',
		[34] = '琥珀包裹的飞蛾',
		[35] = '一箱被丢弃的货物',
		[36] = '荒谬之锤',
		[37] = '掠风者的匕首',
		[38] = '玛里克的坚固长矛',
		[39] = '明晰护符',
		[40] = '操纵者的护符',
		[41] = '菁华之刃   ',
		[42] = '虫群砍刀',
		[43] = '析象器之杖',
		[44] = '觅血者的疯狂钉锤',
		[45] = '虫群卫士之弩',
		[46] = '毒心之锤'
	}
	local l = ''
	local d = {-16,-8,4,7,96,97}
	for x=1,46 do
		n=31392+x
		s="已取得"
		if x<7 then
			n=31300+d[x]
		end
		if IsQuestFlaggedCompleted(n)==nil then
			s=">>未取得<<"
			if l=='' then
				l='['..x..']'..strt[x]..'.'
			else
				l=l..'['..x..']'..strt[x]..'.'
			end
		end
		print('#'..x..' '..strt[x]..': ',s)
	end
	print("\n汇总(未取得):")
	print(l)
end

JLib.frame:RegisterEvent("PLAYER_LEVEL_UP")
JLib.spellFrame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')

--/脚本 print("你特么来打我呀: \124cffa335ee\124Hitem:44707:0:0:0:0:0:0:0\124h[绿色始祖幼龙的缰绳]\124h\124r")