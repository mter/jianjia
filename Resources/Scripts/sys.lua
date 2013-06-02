

data = {
	num = {
		boot=0,
		game=0,
	},
	player = {
		x = 0, -- x ����
		y = 0, -- y ����
        scene = 'newbie_a3', -- �ص�
		alignment = 0, -- ��Ӫ
	},
	ch = {},
    items = {},
}

math.randomseed(os.time())

require('sys.fight')

require('data.enemy')
require('data.spell')
require('data.items')
require('data.character')

-- [[���˲���]]
-- ���˵����԰�����id�� ���֡��ȼ������������������ס����ԡ�ģ��id��ǰ׺id������id�б�����ͼƬ

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
        
        -- ֻ�����ɫ�� data ��Ϣ
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

