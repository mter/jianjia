local function createFightPlayerBoard(player)
	local name = '鸟蛋'
	local hp_max = 100
	local hp_now = 80
	local mp_max = 100
	local mp_now = 70

	local hp_width = 3*(hp_now/hp_max)
	local hp_position_y = 9.6+hp_width/2
	local mp_width = 3*(mp_now/mp_max)
	local mp_position_y = 9.6+mp_width/2
	
	local fight_player_board = {}
	function fight_player_board.new()
		fight_player_board.board_bg = flux.View(ScreenFight.scr)
		fight_player_board.board_bg:SetSize(6, 4)
		fight_player_board.board_bg:SetColor(flux.Color(0, 0, 0))
		fight_player_board.board_bg:SetPosition(10, -7.7)
		ScreenFight.scr:AddView(fight_player_board.board_bg)
		
		fight_player_board.board = flux.View(ScreenFight.scr)
		fight_player_board.board:SetSize(5.8, 3.8)
		fight_player_board.board:SetColor(flux.Color(1, 1, 1))
		fight_player_board.board:SetPosition(10, -7.7)
		ScreenFight.scr:AddView(fight_player_board.board)
	
		fight_player_board.head = flux.View(ScreenFight.scr)
		fight_player_board.head:SetSize(2, 2.5)
		fight_player_board.head:SetColor(flux.Color(0, 0, 0))
		fight_player_board.head:SetPosition(8.3, -8.2)
		ScreenFight.scr:AddView(fight_player_board.head)
		
		fight_player_board.name = flux.TextView(ScreenFight.scr, nil, "wqy", name, 0.7)
		fight_player_board.name:SetColor(flux.Color(0, 0, 0))
		fight_player_board.name:SetPosition(10, -6.3)
		ScreenFight.scr:AddView(fight_player_board.name)
	
		fight_player_board.hp_text = flux.TextView(ScreenFight.scr, nil, "wqy", "HP", 0.7)
		fight_player_board.hp_text:SetColor(flux.Color(0, 0, 0))
		fight_player_board.hp_text:SetPosition(10, -7.2)
		ScreenFight.scr:AddView(fight_player_board.hp_text)
	
		fight_player_board.hp_bar_bg = flux.View(ScreenFight.scr)
		fight_player_board.hp_bar_bg:SetColor(flux.Color(0.4, 0.4, 0.4))
		fight_player_board.hp_bar_bg:SetSize(3, 0.2)
		fight_player_board.hp_bar_bg:SetPosition(11.1, -7.7)
		ScreenFight.scr:AddView(fight_player_board.hp_bar_bg)
	
		fight_player_board.hp_bar = flux.View(ScreenFight.scr)
		fight_player_board.hp_bar:SetColor(flux.Color(1, 0, 0))
		fight_player_board.hp_bar:SetSize(hp_width, 0.2)
		fight_player_board.hp_bar:SetPosition(hp_position_y, -7.7)
		ScreenFight.scr:AddView(fight_player_board.hp_bar)
	
		fight_player_board.mp_text = flux.TextView(ScreenFight.scr, nil, "wqy", "MP", 0.7)
		fight_player_board.mp_text:SetColor(flux.Color(0, 0, 0))
		fight_player_board.mp_text:SetPosition(10, -8.5)
		ScreenFight.scr:AddView(fight_player_board.mp_text)
	
		fight_player_board.mp_bar_bg = flux.View(ScreenFight.scr)
		fight_player_board.mp_bar_bg:SetColor(flux.Color(0.4, 0.4, 0.4))
		fight_player_board.mp_bar_bg:SetSize(3, 0.2)
		fight_player_board.mp_bar_bg:SetPosition(11.1, -9)
		ScreenFight.scr:AddView(fight_player_board.mp_bar_bg)
	
		fight_player_board.mp_bar = flux.View(ScreenFight.scr)
		fight_player_board.mp_bar:SetColor(flux.Color(0, 0, 1))
		fight_player_board.mp_bar:SetSize(mp_width, 0.2)
		fight_player_board.mp_bar:SetPosition(mp_position_y, -9)
		ScreenFight.scr:AddView(fight_player_board.mp_bar)
	end
	fight_player_board.new()
	return fight_player_board
end

local function createFigthPlayer(player)
	local fight_player = {}
	function fight_player.new()
		fight_player.player = flux.View(ScreenFight.scr)
		fight_player.player:SetColor(flux.Color(0, 0, 0))
		fight_player.player:SetSize(3, 4)
		fight_player.player:SetPosition(7, -2.5)
		ScreenFight.scr:AddView(fight_player.player)
	end
	fight_player.new()
	return fight_player
end

local function initPlayer(player_list)
	--for player in player_list do
	player = nil
	createFightPlayerBoard(player)
	createFigthPlayer(player)
	--end
end

local function createFightMenu()
	local fight_menu = {}
	function fight_menu.new()
		fight_menu.attack_text = flux.TextView(ScreenFight.scr, nil, "wqy", "攻击", 0.7)
		fight_menu.attack_text:SetColor(flux.Color(0, 0, 0))
		fight_menu.attack_text:SetPosition(-10, -5.5)
		ScreenFight.scr:AddView(fight_menu.attack_text)

		fight_menu.magic_text = flux.TextView(ScreenFight.scr, nil, "wqy", "法术", 0.7)
		fight_menu.magic_text:SetColor(flux.Color(0, 0, 0))
		fight_menu.magic_text:SetPosition(-8.5, -7)
		ScreenFight.scr:AddView(fight_menu.magic_text)

		fight_menu.defense_text= flux.TextView(ScreenFight.scr, nil, "wqy", "防御", 0.7)
		fight_menu.defense_text:SetColor(flux.Color(0, 0, 0))
		fight_menu.defense_text:SetPosition(-11.5, -7)
		ScreenFight.scr:AddView(fight_menu.defense_text)

		fight_menu.escape_text= flux.TextView(ScreenFight.scr, nil, "wqy", "逃跑", 0.7)
		fight_menu.escape_text:SetColor(flux.Color(0, 0, 0))
		fight_menu.escape_text:SetPosition(-10, -8.5)
		ScreenFight.scr:AddView(fight_menu.escape_text)
	end
	fight_menu.new()
	return fight_menu
end

local function createFightEnemy(num)
	local enemy_position = {}
	enemy_position[1] = {-0.5, 7}
	enemy_position[2] = {-3.8, 4.3}
	enemy_position[3] = {-7.1, 1.6}
	enemy_position[4] = {-10.4, -1.1}
	
	local fight_enemy = {}
	function fight_enemy.new()
		fight_enemy.enemy = flux.View(ScreenFight.scr)
		fight_enemy.enemy:SetColor(flux.Color(0, 0, 0))
		fight_enemy.enemy:SetSize(3, 4)
		fight_enemy.enemy:SetPosition(enemy_position[num][1], enemy_position[num][2])
		ScreenFight.scr:AddView(fight_enemy.enemy)
	end
	fight_enemy.new()
	return fight_enemy
end

local function initEnemy()
	for i = 1, 4 do
		createFightEnemy(i)
	end
end

ScreenFight = {

    new = function()
        if ScreenFight.scr then return end

		-- 基础设定
        ScreenFight.scr = flux.Screen()
		
		-- OnPush 事件
        ScreenFight.scr:lua_OnPush(wrap(function(this)
			ScreenFight.splash:FadeOut(0.5):AnimDo()
        end))

		-- 按键响应
        ScreenFight.scr:lua_KeyInput(wrap(function(this, key, state)
		
        end))
	
		-- 初始化控件事件
        ScreenFight.scr:lua_Init(wrap(function(this)
            -- 生成控件
			ScreenFight.bg = flux.View(this):SetHUD(true):SetSize(32, 24)

			ScreenFight.splash = flux.View(this)
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
			this:AddView(ScreenFight.splash)
			
			initPlayer()
			createFightMenu()
			initEnemy()
        end))

    end,
}
