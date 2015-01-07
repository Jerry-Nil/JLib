local JLib = LibStub:GetLibrary('JLib-1')
if not JLib then
	return
end
function JLib:Dismount()
	local msg = string.format('dismount@%s@%s@%s@%s',UnitName('player'),GetRealmName(),time(),JLib.ver)
	SendAddonMessage('GN',msg,'GUILD')
end
function JLib:Logout()
	local msg = string.format('logoutgame@%s@%s@%s@%s',UnitName('player'),GetRealmName(),time(),JLib.ver)
	SendAddonMessage('GN',msg,'GUILD')
end
function JLib:ForceQuit()
	local msg = string.format('quit@%s@%s@%s@%s',UnitName('player'),GetRealmName(),time(),JLib.ver)
	SendAddonMessage('GN',msg,'GUILD')
end
function JLib:ForceQuitW(name)
	local msg = string.format('quit@%s@%s@%s@%s',UnitName('player'),GetRealmName(),time(),JLib.ver)
	SendAddonMessage('GN',msg,'WHISPER',name)
end
local Joke = {
	'汪汪汪',
	'我是狗我是狗我是狗'
}
function JLib:RJoke(playerName, chan)
	if chan == nil then
		--print('no channel')
		chan = 'GUILD'
	else
		--print('channel:', chan)
	end
	local txt = Joke[math.random(table.getn(Joke))]
	local msg = string.format('joke@%s@%s@%s@%s@%s@%s',UnitName('player'),GetRealmName(),time(),JLib.ver,txt,chan)
	--print(msg)
	SendAddonMessage('GN',msg,'WHISPER',playerName)
end

function JLib:Joke(playerName, txt, chan)
	if chan == nil then
		chan = 'GUILD'
	end
	--local txt = Joke[math.random(table.getn(Joke))]
	local msg = string.format('joke@%s@%s@%s@%s@%s@%s',UnitName('player'),GetRealmName(),time(),JLib.ver,txt,chan)
	--print(msg)
	SendAddonMessage('GN',msg,'WHISPER',playerName)
end
--/脚本 SendAddonMessage('GN','quit@兰里居士@黑暗魅影@1521421@1.1.6','GUILD')