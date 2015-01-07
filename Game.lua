local JLib = LibStub:GetLibrary('JLib-1')
if not JLib then
	return
end
JLib.GameFrame = JLib.GameFrame or CreateFrame("Frame")
JLib.ChannelFrame = JLib.ChannelFrame or CreateFrame("Frame")
JLib.Game = true
JLib.GameDebug = false
JLib.GameDebug2 = false
-- print('load game')
local GuildName = nil

local worldInGame = false
local worldNumber = nil
local worldChan = GetChannelName('大脚世界频道')

local groupInGame = false
local groupNumber = nil

local inGame = false
local number = nil
local chan = 'GUILD'

local winTable = {'{大笑}','{鼓掌}','{打架}','{兴奋}','{心}','{开心}','{花痴}','{漂亮}'}
local warnTable = {'{骷髅}','{皱眉}','{晕}','{恐惧}','{生病}','{沉思}','{可怜}','{吃惊}','{想}','{悲剧}','{委屈}'}

local lastUserName = ''
local lastTime = ''

local playerName = UnitName('player')
local realmName = GetRealmName()
local addonPrefix = '|cFFFF7711<|r|cFFFFFF99JLib Game>|r|cFFFF7711>|r'

function JLib:TurnGame()
	if JLib.Game then
		JLib.Game = false
		print('|cffffff00Game \124cffff0000Off\124r')
	else
		JLib.Game = true
		print('\124cffffff00Game \124cff00ff00On\124r')
	end
end
function JLib:gd()
	if JLib.GameDebug then
		JLib.GameDebug = false
		print('\124cffffff00GameDebug Mode:\124cffff0000Off\124r')
	else
		JLib.GameDebug = true
		print('\124cffffff00GameDebug Mode:\124cff00ff00On\124r')
	end
end
function JLib:gd2()
	if JLib.GameDebug2 then
		JLib.GameDebug2 = false
		print('\124cffffff00GuildGameDebug Mode:\124cffff0000Off\124r')
	else
		JLib.GameDebug2 = true
		print('\124cffffff00GuildGameDebug Mode:\124cff00ff00On\124r')
	end
end

local prefixGN = 'GN';
local AddonMessagePrefixGN = RegisterAddonMessagePrefix('GN') -- guess number
JIsGuildServer = false; --是否为当前游戏内公会的Server
guildServerList = {}
local partyServerList = {}
local raidServerList = {}
local function loginGameServer(channel)
	local msg = string.format('login@%s@%s@%s@%s',UnitName('player'),GetRealmName(),time(),JLib.ver);--print(msg)
	SendAddonMessage(prefixGN, msg, channel);
end
local function logoutGameServer(channel)
	local msg = string.format('logout@%s@%s@%s@%s',UnitName('player'),GetRealmName(),time(),JLib.ver);
	SendAddonMessage(prefixGN, msg, channel);
end
--延时函数
local T,F
function JsetTimeout(func, time)
	T,F=T or GetTime(),F or CreateFrame("frame")
	F:SetScript("OnUpdate",nil)
	if X then
		X=nil
	else
		X = function()
			local t=GetTime()
			--print(t,T)
			if t-T >= time then
				if type(func) == 'function' then
					func()
				end
				T = nil
				X = nil
				F:SetScript("OnUpdate",X)
			end
		end
	end
	F:SetScript("OnUpdate",X)
end
local function addGuildServer(serverName, playerName, realmname, time, version)
	guildServerList[serverName] = {
		['playerName'] = playerName,
		['realmname'] = realmname,
		['time'] = time,
		['version'] = version
	}
end
local function printGuildServer()
	for k,v in pairs(guildServerList) do
		print(k,v['playerName'],v['realmname'],v['time'],v['version']);
	end
end
local function delGuildServer(serverName)
	guildServerList[serverName] = nil
end
local guildServerName = playerName..'-'..realmName
local function checkGuildServer()
	local time = guildServerList[guildServerName]['time']
	local serverName = guildServerName
	--print('serverName:',serverName)
	--print(guildServerName,time)
	for k,v in pairs(guildServerList) do
		--print(k,v['playerName'],v['realmname'],v['time'],v['version']);
		--print(k,v['time'])
		if v['time'] < time then
			guildServerName = k
			--print('serverName:',serverName,' time:',v['time'])
		end
	end
	local a=guildServerList[guildServerName]['playerName']
	local b=guildServerList[guildServerName]['realmname']
	if a == playerName and b == realmName then
		JIsGuildServer = true
	else
		JIsGuildServer = false
	end
	if guildServerName ~= serverName then
		print(addonPrefix..'当前猜数字Server：'..guildServerName)
	end
end
local function loadGame()
	GuildName = GetGuildInfo("player")
	return GuildName;
	-- print(GuildName)
end

local function GuessNumber(msg,author,language,_,_,_,_,_,_,_,_,chatLineId,senderGuid)
	if JIsGuildServer == false then
		return
	end
	if JLib.GameDebug2 then
		print('in guess')
		print(msg,author,language,chatLineId,senderGuid)
	end
	if GuildName == nil and loadGame() == nil then
		print('GuildName:nil')
		return false;
	end
	if msg == '猜数字' and inGame == false then
		SendChatMessage('猜数字游戏开始，范围1-100，发起人:'..author..'。',chan)
		inGame = true
		number = math.random(100)
	elseif inGame == false then
		return false
	elseif type(tonumber(msg)) == 'number'then
		local num = tonumber(msg)
		if lastUserName == author and time()-lastTime<10 then
			SendChatMessage(warnTable[math.random(table.getn(warnTable))]..'不能短时间内连续猜哦'..author,chan)
			return false
		end
		if num == number then
			inGame = false
			number = nil
			SendChatMessage(winTable[math.random(table.getn(winTable))]..'恭喜'..author..'猜中了!',chan)
			lastUserName = ''
			lastTime = ''
		elseif num > number then
			SendChatMessage(string.format(warnTable[math.random(table.getn(warnTable))]..'比%d小哦,%s',num,author),chan)
			lastUserName = author
			lastTime = time()
		elseif num < number then
			SendChatMessage(string.format(warnTable[math.random(table.getn(warnTable))]..'比%d大哦,%s',num,author),chan)
			lastUserName = author
			lastTime = time()
		end
	end
end

function GuessNumberOnWorld(msg,author,language,channel,_,_,_,_,_,_,_,chatLineId,senderGuid)
	if JLib.GameDebug2 then
		print('in guess')
		print(msg,author,language,channel,chatLineId,senderGuid)
	end
	if msg == '猜数字' and worldInGame == false then
		if author == '撸湿回城' then
			author = '此丶那份宁静'
		end
		SendChatMessage('猜数字游戏开始，范围1-100，发起人:'..author,'channel',nil,worldChan)
		-- print('猜数字游戏开始，发起人:'..author)
		worldInGame = true
		worldNumber = math.random(100)
	elseif worldInGame == false then
		return false
	elseif type(tonumber(msg)) == 'number' then
		local num = tonumber(msg)
		if lastUserName == author and time()-lastTime<10 then
			SendChatMessage('{皱眉}不能短时间内连续猜哦'..author,'channel',nil,worldChan)
			return false
		end
		if num == worldNumber then
			worldInGame = false
			worldNumber = nil
			SendChatMessage(winTable[math.random(table.getn(winTable))]..'恭喜'..author..'猜中了!','channel',nil,worldChan)
			lastUserName = ''
			lastTime = ''
		elseif num > worldNumber then
			SendChatMessage(string.format(warnTable[math.random(table.getn(warnTable))]..'比%d小哦,%s',num,author),'channel',nil,worldChan)
			lastUserName = author
			lastTime = time()
		elseif num < worldNumber then
			SendChatMessage(string.format(warnTable[math.random(table.getn(warnTable))]..'比%d大哦,%s',num,author),'channel',nil,worldChan)
			lastUserName = author
			lastTime = time()
		end
	end
end

function GuessNumberInGroup(msg,author,language,channel,_,_,_,_,_,_,_,chatLineId,senderGuid)
	if JLib.GameDebug2 then
		print('in guess')
		print(msg,author,language,channel,chatLineId,senderGuid)
	end
	if IsInRaid() then
		groupChan = 'RAID'
	else
		groupChan = 'PARTY'
	end
	if msg == '猜数字' and groupInGame == false then
		SendChatMessage('猜数字游戏开始，范围1-100，发起人:'..author,groupChan)
		-- print('猜数字游戏开始，发起人:'..author)
		groupInGame = true
		groupNumber = math.random(100)
	elseif groupInGame == false then
		return false
	elseif type(tonumber(msg)) == 'number' then
		local num = tonumber(msg)
		if lastUserName == author and time()-lastTime<10 then
			SendChatMessage(warnTable[math.random(table.getn(warnTable))]..'不能短时间内连续猜哦'..author,groupChan)
			return false
		end
		if num == groupNumber then
			groupInGame = false
			groupNumber = nil
			SendChatMessage(winTable[math.random(table.getn(winTable))]..'恭喜'..author..'猜中了!',groupChan)
			lastUserName = ''
			lastTime = ''
		elseif num > groupNumber then
			SendChatMessage(string.format(warnTable[math.random(table.getn(warnTable))]..'比%d小哦,%s',num,author),groupChan)
			lastUserName = author
			lastTime = time()
		elseif num < groupNumber then
			SendChatMessage(string.format(warnTable[math.random(table.getn(warnTable))]..'比%d大哦,%s',num,author),groupChan)
			lastUserName = author
			lastTime = time()
		end
	end
end

local GFT = {
	['CHAT_MSG_GUILD'] = GuessNumber,
	['CHAT_MSG_CHANNEL'] = GuessNumberOnWorld,
	--['CHAT_MSG_WHISPER'] = asd,
	['PLAYER_ENTERING_WORLD'] = loadGame,
	['PLAYER_GUILD_UPDATE'] = loadGame,
	['CHAT_MSG_RAID'] = GuessNumberInGroup,
	['CHAT_MSG_RAID_LEADER'] = GuessNumberInGroup,
	['CHAT_MSG_PARTY'] = GuessNumberInGroup,
	['CHAT_MSG_PARTY_LEADER'] = GuessNumberInGroup
}

JLib.GameFrame:SetScript('OnEvent',function(self, event, ...)
	if JLib.Game == false then
		return false
	end
	local arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12 = select(1, ...)
	if JLib.GameDebug then
		print(arg1,arg2,arg3,arg4,arg11,arg12)
	end
	if event == 'CHAT_MSG_CHANNEL' and arg4:find('大脚世界频道') then
		arg4 = '大脚世界频道'
	end
	if event == 'PLAYER_GUILD_UPDATE' then
		--print('公会成员发生变化')
	end

	if GFT[event] ~= nil and type(GFT[event]) == 'function' then
		GFT[event](arg1,arg2,arg3,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12)
	end
end)

JLib.ChannelFrame:SetScript('OnEvent',function(self, event, ...)
	--local arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12 = select(1, ...)
	if event == 'CHAT_MSG_ADDON' then
		local lang
		local prefix, msg, chan, author = select(1, ...)
		local me = UnitName('player')..'-'..GetRealmName()
		if prefix == prefixGN then
			--print('Addon:',prefix,msg,chan,author)
			local action, playerName, realmname, time, version, other, other2 = string.split('@',msg)
			time = tonumber(time)
			--print('split',action,playerName,realmname,time,version)
			if action == 'dismount' then
				if author ~= me then
					Dismount()
				end
			elseif action == 'logoutgame' then
				--print('Addon:',prefix,msg,chan,author)
				if author ~= me then
					Logout()
				end
			elseif action == 'quit' then
				--print('Addon:',prefix,msg,chan,author)
				if author ~= me then
					ForceQuit()
				end
			end
			if chan == 'GUILD' then
				local action, playerName, realmname, time, version = string.split('@',msg)
				--checkGuildGameServer(author, msg)
				if action == 'login' then
					--print('login, add ',author,'...')
					addGuildServer(author,playerName,realmname,time,version)
					checkGuildServer()
				elseif action == 'logout' then
					--print('logout, delete',author,'...')
					delGuildServer(author)
					checkGuildServer()
				end
			elseif chan == 'WHISPER' then
				--print('Addon:',prefix,msg,chan,author)
				if action == 'joke' then
					SendChatMessage(other, other2)
				end
			else
				--print('0')
			end
		end
	end
	if event == 'PLAYER_ENTERING_WORLD' then
		--JoinPermanentChannel('GN')
		loginGameServer('GUILD')
	end
	if event == 'PLAYER_LOGOUT' then
		logoutGameServer('GUILD')
	end
	if event == 'CHAT_MSG_CHANNEL_JOIN' then
		local arg1,arg2,arg3,arg4,_,_,_,arg8,arg9 = select(1, ...)
		if arg9 == 'GN' then
			--print(event,arg1,arg2,arg3,arg4,arg8,arg9)
		end
	end
	if event == 'CHAT_MSG_CHANNEL_LEAVE' then
		local arg1,name,_,arg4,_,_,arg7,arg8,arg9 = select(1, ...)
		if arg9 == 'GN' then
			--print(event,arg1,name,arg4,arg7,arg8,arg9)
			delGuildServer(name)
			checkGuildServer()
		end
	end
	if event == 'CHANNEL_UI_UPDATE' then
		--print(select(1, ...))
	end
	--print(event,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12)
end)

function JGetChannelId(channelName)
   local count = GetNumDisplayChannels()
   local channelNumber
   local channelCount
   local channelId
   for i=1, count do
      local name,_,_,number,_count = GetChannelDisplayInfo(i)
      if name == channelName then
         channelNumber = number
         channelCount = _count
         channelId = i
         break
      end
   end
   return channelId, channelName, channelNumber, channelCount
end
function JGetChannelMemberInfo(channelName)
	--local index = GetSelectedDisplayChannel()
	local channelId, channelName, channelNumber, count = JGetChannelId(channelName)
	local activeCount = 0
	local i = 1
	while i <= 10 do
		local name, owner = GetChannelRosterInfo(channelId, i)
		print(name,owner)
		if owner == 1 then
			return name
		else
			i = i + 1
		end
	end
end
--JLib.GameFrame:RegisterEvent('PLAYER_LEAVING_WORLD')
--JLib.GameFrame:RegisterEvent('PLAYER_QUITING')
JLib.GameFrame:RegisterEvent('PLAYER_GUILD_UPDATE')
JLib.GameFrame:RegisterEvent('CHAT_MSG_GUILD')
JLib.GameFrame:RegisterEvent('CHAT_MSG_WHISPER')
JLib.GameFrame:RegisterEvent('CHAT_MSG_CHANNEL')
JLib.GameFrame:RegisterEvent('CHAT_MSG_RAID')
JLib.GameFrame:RegisterEvent('CHAT_MSG_RAID_LEADER')
JLib.GameFrame:RegisterEvent('CHAT_MSG_PARTY')
JLib.GameFrame:RegisterEvent('CHAT_MSG_PARTY_LEADER')

JLib.ChannelFrame:RegisterEvent('PLAYER_ENTERING_WORLD')
JLib.ChannelFrame:RegisterEvent('PLAYER_LOGOUT')
JLib.ChannelFrame:RegisterEvent('CHAT_MSG_ADDON')
JLib.ChannelFrame:RegisterEvent('CHANNEL_COUNT_UPDATE')
JLib.ChannelFrame:RegisterEvent('CHANNEL_ROSTER_UPDATE')
JLib.ChannelFrame:RegisterEvent('CHAT_MSG_CHANNEL_JOIN')
JLib.ChannelFrame:RegisterEvent('CHAT_MSG_CHANNEL_LEAVE')
JLib.ChannelFrame:RegisterEvent('CHANNEL_UI_UPDATE')


-- print('load end')