local JLib = LibStub:GetLibrary('JLib-1')
if not JLib then
	return
end
SLASH_JLIB1 = '/jlib'

SlashCmdList['JLIB'] = function(input)
	if input == 'help' then
	elseif input == 'game' then
		JLib:TurnGame()
	elseif input == 'guild' or input == 'g' then
		JLib:getXP(true)
	elseif input == 'debug' or input == 'd' then
		JLib:Debug();
	elseif input == 'version' or input == 'v' then
		JLib:Version();
	else
		JLib:getXP()
	end
end