

data = {
	num = {
		boot=0,
		game=0,
	},
	player = {
		x = 0, -- x 坐标
		y = 0, -- y 坐标
		alignment = 0, -- 阵营
	},
}

math.randomseed(os.time())

require('data.enemy')
require('data.skill')
require('data.character')

-- [[敌人部分]]
-- 敌人的属性包括：id， 名字、等级、攻击、防御、护甲、抗性、模板id、前缀id、技能id列表、怪物图片

-- [roll（攻击min，攻击max）+ （攻击max-攻击min)*意志^0.5/50 - 防御/魔抗]*(1-伤害抵挡）* 暴击倍数

sys = {

	init = function()
		sys.load()
		data.num.boot = data.num.boot + 1
	end,

	save = function()
		if ScreenGame.player then
			local pos = ScreenGame.player:GetPosition()
			data.player.x, data.player.y = pos.x, pos.y
		end
		local f = io.open('Savedata/flag1', 'w+')
		f:write(json.encode(data))
		f.close()
	end,

	load = function()
		lfs.mkdir('Savedata')
		if io.exists('Savedata/flag1') then
			local f = io.open('Savedata/flag1', 'r')
			data = json.decode(f:read('*a'))
			f.close()
		end
	end,
}

