

data = {
	num = {
		boot=0,
		game=0,
	},
	player = {
		x = 0, -- x 坐标
		y = 0, -- y 坐标
        scene = 'newbie_a3', -- 地点
		alignment = 0, -- 阵营
	},
	ch = {},
    items = {},
}

math.randomseed(os.time())

require('data.enemy')
require('data.spell')
require('data.items')
require('data.character')

-- [[敌人部分]]
-- 敌人的属性包括：id， 名字、等级、攻击、防御、护甲、抗性、模板id、前缀id、技能id列表、怪物图片

sys = {

	init = function()
		sys.load()
		data.num.boot = data.num.boot + 1
	end,

	save = function(slot)
        local slot = slot or 1
		if ScreenGame.player then
			local pos = ScreenGame.player:GetPosition()
			data.player.x, data.player.y = pos.x, pos.y
            data.player.scene = SceneManager:GetSceneName() or data.player.scene
		end
		local f = io.open('Savedata/flag' .. slot, 'w+')
        
        -- 只保存角色的 data 信息
        local ch = {}
        local chbak = data.ch
        for k,v in pairs(data.ch) do
            ch[k] = v.data
        end
        data.ch = ch
		f:write(json.encode(data))
        data.ch = chbak
		f.close()
	end,

	load = function(slot)
        local slot = slot or 1
		lfs.mkdir('Savedata')
		if io.exists('Savedata/flag' .. slot) then
			local f = io.open('Savedata/flag1', 'r')
			data = json.decode(f:read('*a'))
			f.close()
			for k,v in pairs(data.ch) do
                data.ch[k] = Character(v)
			end
		end
	end,
}

