
scr = {}
_b = string.byte
package.path = package.path .. ';./Resources/Scripts/?.lua'

config = {
    SCREEN_WIDTH = 1024,
    SCREEN_HEIGHT = 768,
    TITLE = '›Û›Á£∫√∞œ’÷Æ¬√',
    VER = 'v0.1',
}

json = require ("dkjson")

require('local_cn')
require('sys')
require('screen_start')
require('screen_fight')
require('screen_about')
require('screen_alignment_choose')
require('screen_text')
require('screen_character')
require('screen_game')

function theWorld_GameInit()
    theWorld:LoadFont('Resources/Fonts/wqy-microhei.ttc', 'wqyL', 40)
    theWorld:LoadFont('Resources/Fonts/wqy-microhei.ttc', 'wqy',  25)
	-- theSound:LoadMusic(1, "Resources/Sounds/bgm1.mid")
	ScreenStart.new()
	ScreenFight.new()
	ScreenAbout.new()
    ScreenCharacter.new()
	ScreenGame.new()
	theWorld:PushScreen(ScreenStart.scr)
end

sys.init()
theWorld:Init(config.TITLE, config.SCREEN_WIDTH, config.SCREEN_HEIGHT)
theWorld:InitPhysics()
theWorld_GameInit()
theWorld:StartGame()
sys.save()
