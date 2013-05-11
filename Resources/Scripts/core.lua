
scr = {}
_b = string.byte
package.path = package.path .. ';./Resources/Scripts/?.lua'

function table.empty(t)
    return _G.next( t ) == nil
end

function table.get_next(t, key)
	local flag
	for k,v in pairs(t) do
		if flag then
			return k,v
		end
		if key == k then
			flag = true
		end
	end
end

function table.get_prev(t, key)
	local lastk, lastv
	for k,v in pairs(t) do
		if key == k then
			return lastk, lastv
		end
		lastk, lastv = k, v
	end
end

function table.get_first(t)
	return _G.next(t)
end

function table.get_last(t)
	local lastk, lastv
	for k,v in pairs(t) do
		lastk, lastv = k, v
	end
	return lastk, lastv
end

config = {
    SCREEN_WIDTH = 1024,
    SCREEN_HEIGHT = 768,
    TITLE = '›Û›Á£∫√∞œ’÷Æ¬√',
    VER = 'v0.1',
}

json = require ("dkjson")

require('sys')
require('screen_start')
require('screen_fight')
require('screen_about')
require('screen_alignment_choose')
require('screen_text')
require('screen_game')

function theWorld_GameInit()
    theWorld:LoadFont('Resources/Fonts/wqy-microhei.ttc', 'wqyL', 40)
    theWorld:LoadFont('Resources/Fonts/wqy-microhei.ttc', 'wqy',  25)
	-- theSound:LoadMusic(1, "Resources/Sounds/bgm1.mid")
	ScreenStart.new()
	ScreenFight.new()
	ScreenAbout.new()
	ScreenGame.new()
	theWorld:PushScreen(ScreenStart.scr)
end

sys.init()
theWorld:Init(config.TITLE, config.SCREEN_WIDTH, config.SCREEN_HEIGHT)
theWorld:InitPhysics()
theWorld_GameInit()
theWorld:StartGame()
sys.save()
