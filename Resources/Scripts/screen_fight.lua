
local function createFightPlayerBoard()
	local fight_player_board = {}
	function fight_player_board.new()
		fight_player_board.board_bg = flux.View(ScreenFight.scr)
		fight_player_board.board_bg:SetHUD(true)
		fight_player_board.board_bg:SetSize(6, 4)
		fight_player_board.board_bg:SetColor(0, 0, 0)
		fight_player_board.board_bg:SetPosition(10, -7.7)
		ScreenFight.scr:AddView(fight_player_board.board_bg)
		
		fight_player_board.board = flux.View(ScreenFight.scr)
		fight_player_board.board:SetHUD(true)
		fight_player_board.board:SetSize(5.8, 3.8)
		fight_player_board.board:SetColor(1, 1, 1)
		fight_player_board.board:SetPosition(10, -7.7)
		ScreenFight.scr:AddView(fight_player_board.board)
	
		fight_player_board.head = flux.View(ScreenFight.scr)
		fight_player_board.head:SetHUD(true)
		fight_player_board.head:SetSize(2, 2.5)
		fight_player_board.head:SetColor(0, 0, 0)
		fight_player_board.head:SetPosition(8.3, -8.2)
		ScreenFight.scr:AddView(fight_player_board.head)
		
		fight_player_board.name = flux.TextView(ScreenFight.scr, nil, "wqy", "player1", 0.7)
		fight_player_board.name :SetHUD(true)
		fight_player_board.name:SetColor(0, 0, 0)
		fight_player_board.name:SetPosition(10, -6.3)
		ScreenFight.scr:AddView(fight_player_board.name)
	
		fight_player_board.hp_text = flux.TextView(ScreenFight.scr, nil, "wqy", "HP", 0.7)
		fight_player_board.hp_text:SetHUD(true)
		fight_player_board.hp_text:SetColor(0, 0, 0)
		fight_player_board.hp_text:SetPosition(10, -7.2)
		ScreenFight.scr:AddView(fight_player_board.hp_text)
	
		fight_player_board.hp_bar_bg = flux.View(ScreenFight.scr)
		fight_player_board.hp_bar_bg:SetHUD(true)
		fight_player_board.hp_bar_bg:SetColor(0.4, 0.4, 0.4)
		fight_player_board.hp_bar_bg:SetSize(3, 0.2)
		fight_player_board.hp_bar_bg:SetPosition(11.1, -7.7)
		ScreenFight.scr:AddView(fight_player_board.hp_bar_bg)
	
		fight_player_board.hp_bar = flux.View(ScreenFight.scr)
		fight_player_board.hp_bar:SetHUD(true)
		fight_player_board.hp_bar:SetColor(1, 0, 0)
		--fight_player_board.hp_bar:SetSize(hp_width, 0.2)
		--fight_player_board.hp_bar:SetPosition(hp_position_y, -7.7)
		fight_player_board.hp_bar:SetSize(3, 0.2)
		fight_player_board.hp_bar:SetPosition(11.1, -7.7)
		ScreenFight.scr:AddView(fight_player_board.hp_bar)
	
		fight_player_board.mp_text = flux.TextView(ScreenFight.scr, nil, "wqy", "MP", 0.7)
		fight_player_board.mp_text:SetHUD(true)
		fight_player_board.mp_text:SetColor(0, 0, 0)
		fight_player_board.mp_text:SetPosition(10, -8.5)
		ScreenFight.scr:AddView(fight_player_board.mp_text)
	
		fight_player_board.mp_bar_bg = flux.View(ScreenFight.scr)
		fight_player_board.mp_bar_bg:SetHUD(true)
		fight_player_board.mp_bar_bg:SetColor(0.4, 0.4, 0.4)
		fight_player_board.mp_bar_bg:SetSize(3, 0.2)
		fight_player_board.mp_bar_bg:SetPosition(11.1, -9)
		ScreenFight.scr:AddView(fight_player_board.mp_bar_bg)
	
		fight_player_board.mp_bar = flux.View(ScreenFight.scr)
		fight_player_board.mp_bar:SetHUD(true)
		fight_player_board.mp_bar:SetColor(0, 0, 1)
		--fight_player_board.mp_bar:SetSize(mp_width, 0.2)
		--fight_player_board.mp_bar:SetPosition(mp_position_y, -9)
		fight_player_board.mp_bar:SetSize(3, 0.2)
		fight_player_board.mp_bar:SetPosition(11.1, -9)
		ScreenFight.scr:AddView(fight_player_board.mp_bar)
	end
	
	function fight_player_board.refurbish(player)
		local name = player.name
		local hp_max = player.hp_max
		local hp_now = player.hp
		local mp_max = player.mp_max
		local mp_now = player.mp

		local hp_width = 3*(hp_now/hp_max)
		local hp_position_y = 9.6+hp_width/2
		local mp_width = 3*(mp_now/mp_max)
		local mp_position_y = 9.6+mp_width/2

		fight_player_board.name:SetText(name)
		fight_player_board.hp_bar:SetSize(hp_width, 0.2)
		fight_player_board.hp_bar:SetPosition(hp_position_y, -7.7)
		fight_player_board.mp_bar:SetSize(mp_width, 0.2)
		fight_player_board.mp_bar:SetPosition(mp_position_y, -9)
	end

	fight_player_board.new()
	return fight_player_board
end

-- 玩家
local function createFigthPlayer()
	local fight_player = {}
	fight_player.player = flux.View(ScreenFight.scr)
	fight_player.player:SetHUD(true)
	fight_player.player:SetColor(0, 0, 0)
	fight_player.player:SetSize(3, 4)
	fight_player.player:SetPosition(7, -2.5)
	ScreenFight.scr:AddView(fight_player.player)
	return fight_player
end

-- 战斗菜单面板
local function createFightMenu()
	local fight_menu = {cursel = 1}
	
	fight_menu.color = {sel = flux.Color(0.79, 0.79, 0.79), nor = flux.Color(0.79, 0.79, 0.79, 0)}

	fight_menu.attack = flux.TextView(ScreenFight.scr, nil, "wqy", "攻击", 0.7)
	fight_menu.attack:SetHUD(true):SetPosition(-10, -5.5):SetSize(1.5, 1):SetColor(fight_menu.color.sel)
	ScreenFight.scr:AddView(fight_menu.attack)

	fight_menu.magic = flux.TextView(ScreenFight.scr, nil, "wqy", "法术", 0.7)
	fight_menu.magic:SetHUD(true):SetPosition(-8.5, -7):SetSize(1.5, 1):SetColor(fight_menu.color.nor)
	ScreenFight.scr:AddView(fight_menu.magic)

	fight_menu.defense = flux.TextView(ScreenFight.scr, nil, "wqy", "防御", 0.7)
	fight_menu.defense:SetHUD(true):SetPosition(-11.5, -7):SetSize(1.5, 1):SetColor(fight_menu.color.nor)
	ScreenFight.scr:AddView(fight_menu.defense)

	fight_menu.escape = flux.TextView(ScreenFight.scr, nil, "wqy", "逃跑", 0.7)
	fight_menu.escape:SetHUD(true):SetPosition(-10, -8.5):SetSize(1.5, 1):SetColor(fight_menu.color.nor)
	ScreenFight.scr:AddView(fight_menu.escape)
	
	fight_menu.ptr = flux.TextView(ScreenFight.scr, nil, 'wqy', '△')
	fight_menu.ptr:SetAlpha(0):SetHUD(true)
	ScreenFight.scr:AddView(fight_menu.ptr)

	fight_menu[1] = fight_menu.attack
	fight_menu[2] = fight_menu.magic
	fight_menu[3] = fight_menu.escape
	fight_menu[4] = fight_menu.defense

	return fight_menu
end

local function initEnemy()	
	enemy_pic = {
		flux.TextView(ScreenFight.scr, nil, 'wqy'):SetSize(3, 4):SetPosition(-7.1, 1.6),
		flux.TextView(ScreenFight.scr, nil, 'wqy'):SetSize(3, 4):SetPosition(-3.8, 4.3),
		flux.TextView(ScreenFight.scr, nil, 'wqy'):SetSize(3, 4):SetPosition(-0.5, 7),
		flux.TextView(ScreenFight.scr, nil, 'wqy'):SetSize(3, 4):SetPosition(-10.4, -1.1),
	}

	for k,v in pairs(enemy_pic) do
		v:SetTextColor(1,1,1):SetHUD(true):SetColor(0, 0, 0)
		ScreenFight.scr:AddView(v)
	end
	return enemy_pic
end

-- 怪物攻击玩家
local function attack_player(this)
	for k,v in pairs(ScreenFight.enm_lst) do
		local i = math.random(1, #data.ch)
		local dmg = enemy.attack(v, data.ch[i], v[5])
		print('怪物', v[1], '攻击玩家！造成伤害', dmg)
		if not character.hp_dec(data.ch[i], dmg) then
			print('你死亡了!')
			theWorld:PopScreen()
			return
		end
		ScreenFight.player_board.refurbish(data.ch[i])
	end
end

ScreenFight = {

	exp = 0,

    new = function()
    	-- 基础设定
        if ScreenFight.scr then
        	return
        end

        ScreenFight.scr = flux.Screen()

		-- OnPush 事件
        ScreenFight.scr:lua_OnPush(wrap(function(this)
			ScreenFight.splash:FadeOut(0.5):AnimDo()
			local player = data.ch[1]
			ScreenFight.player_board.refurbish(player)
			for k,v in pairs(ScreenFight.enemy_pic) do
				v:SetColor(0,0,0,0)
			end
			local num = #ScreenFight.enm_lst
			for i=1,num do
				ScreenFight.enemy_pic[i]:SetColor(0,0,0,1)
				ScreenFight.enemy_pic[i]:SetText(ScreenFight.enm_lst[i][1])
			end
        end))

        ScreenFight.scr:lua_OnPop(wrap(function(this)
			for k,v in pairs(ScreenFight.enemy_pic) do
				v:AnimCancel()
			end
			ScreenFight.splash:AnimCancel()
		end))

		-- 按键响应
        ScreenFight.scr:lua_KeyInput(wrap(function(this, key, state)

			local function update(cursel)
				ScreenFight.fight_menu.cursel = cursel
				for k,v in pairs(ScreenFight.fight_menu) do 
					if type(v) == 'userdata' then
						v:SetColor(ScreenFight.fight_menu.color.nor)
					end
				end
				ScreenFight.fight_menu[cursel]:SetColor(ScreenFight.fight_menu.color.sel)
			end

			if state == flux.GLFW_PRESS then
				local cursel = ScreenFight.fight_menu.cursel
                if key == flux.GLFW_KEY_ESC then
					-- “取消”操作
					if ScreenFight.select_aim then
						ScreenFight.fight_menu.ptr:SetAlpha(0)
						ScreenFight.select_aim = nil
					end
				elseif key == flux.GLFW_KEY_SPACE or key == _b'Z' then
					if not ScreenFight.fight_end then
						-- 进行攻击或者防御等等
						if cursel == 1 then
							-- 玩家选择了“攻击”，开始选择目标
							if not ScreenFight.select_aim then
								if ScreenFight.enm_lst[ScreenFight.last_select] then
									ScreenFight.select_aim = ScreenFight.last_select
								else
									ScreenFight.select_aim = next(ScreenFight.enm_lst)
								end
								local pos = ScreenFight.enemy_pic[ScreenFight.select_aim]:GetPosition()
								ScreenFight.fight_menu.ptr:SetPosition(pos.x, pos.y+2.5):SetAlpha(1)
							else
								-- 玩家选定了要攻击的目标，开始攻击
								ScreenFight.last_select = ScreenFight.select_aim
								ScreenFight.fight_menu.ptr:SetAlpha(0)

								local dmg = character.attack(data.ch[1], ScreenFight.enm_lst[ScreenFight.select_aim], 1)
								print('伤害:', dmg)
								-- 留下这个值，以后可能会在减血时进行技能判定。
								local new_hp = ScreenFight.enm_lst[ScreenFight.select_aim][3] - dmg
								if new_hp <= 0 then
									ScreenFight.enemy_pic[ScreenFight.select_aim]:FadeOut(1):AnimDo()
									print(ScreenFight.enm_lst[ScreenFight.select_aim][1], '已经死亡')
									ScreenFight.exp = ScreenFight.exp + enemy.exp(ScreenFight.enm_lst[ScreenFight.select_aim][2])
									ScreenFight.enm_lst[ScreenFight.select_aim] = nil

									if table.empty(ScreenFight.enm_lst) then
										ScreenFight.fight_end = true
										print('战斗结束! 获得经验', ScreenFight.exp)
										this:SetRetCode(ScreenFight.exp)
										theWorld:PopScreen()
									end
								else
									ScreenFight.enm_lst[ScreenFight.select_aim][3] = new_hp
								end

								ScreenFight.select_aim = nil

								-- 玩家打完了，轮到敌人打击玩家
								attack_player(this)
							end
						elseif cursel == 3 then
							-- 逃跑
							theWorld:PopScreen()
						elseif cursel == 4 then
							print('防御')
						end
					end
				elseif key == flux.GLFW_KEY_LEFT and not ScreenFight.fight_end then
					if ScreenFight.select_aim then
						local k,v = table.get_prev(ScreenFight.enm_lst, ScreenFight.select_aim)
						if not k then
							k,v = table.get_last(ScreenFight.enm_lst)
						end
						if k then
							local pos = ScreenFight.enemy_pic[k]:GetPosition()
							ScreenFight.fight_menu.ptr:SetPosition(pos.x, pos.y+2.5):SetAlpha(1)
							ScreenFight.select_aim = k
						end
					else
						cursel = cursel - 1
						if cursel == 0 then
							cursel = 4
						end
						update(cursel)
					end
				elseif key == flux.GLFW_KEY_RIGHT and not ScreenFight.fight_end  then
					if ScreenFight.select_aim then
						local k,v = table.get_next(ScreenFight.enm_lst, ScreenFight.select_aim)
						if not k then
							k,v = table.get_first(ScreenFight.enm_lst)
						end
						if k then
							local pos = ScreenFight.enemy_pic[k]:GetPosition()
							ScreenFight.fight_menu.ptr:SetPosition(pos.x, pos.y+2.5):SetAlpha(1)
							ScreenFight.select_aim = k
						end
					else
						cursel = cursel + 1
						if cursel == 5 then
							cursel = 1
						end
						update(cursel)
					end
                end
            end
        end))
	
		-- 初始化控件事件
        ScreenFight.scr:lua_Init(wrap(function(this)
            -- 生成控件
			ScreenFight.bg = flux.View(this):SetHUD(true):SetSize(32, 24)

			ScreenFight.splash = flux.View(this):SetHUD(true)
			ScreenFight.splash:SetSize(32, 24):SetColor(0,0,0)

            -- 注册按键
            this:RegKey(_b'Z')
            this:RegKey(flux.GLFW_KEY_ESC)
            this:RegKey(flux.GLFW_KEY_SPACE)
            this:RegKey(flux.GLFW_KEY_LEFT)
            this:RegKey(flux.GLFW_KEY_RIGHT)
            this:RegKey(flux.GLFW_KEY_UP)
            this:RegKey(flux.GLFW_KEY_DOWN)

			this:AddView(ScreenFight.bg)
			
			this:SetFromCode(3)

			-- 角色形象
			ScreenFight.player_pic = createFigthPlayer()
			-- 战斗菜单面板
			ScreenFight.fight_menu = createFightMenu()
			-- 敌人图像
			ScreenFight.enemy_pic = initEnemy()

			this:AddView(ScreenFight.splash)

			-- 角色信息面板
			ScreenFight.player_board = createFightPlayerBoard()
        end))

    end,
}

function ShowFight(lst)
	local num = math.random(1, 4)
	local enm_lst = {}
	for i=1,num do
		local index = math.random(1, #lst)
		table.insert(enm_lst, table.copy(enemys[lst[index]]))
	end
	--for k,v in pairs(enm_lst) do
	--	print(k,v)
	--end
	ScreenFight.new()
	ScreenFight.exp = 0
	ScreenFight.fight_end = false
	ScreenFight.enm_lst = enm_lst
	theWorld:PushScreen(ScreenFight.scr, flux.SCREEN_APPEND)
end
