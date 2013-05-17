
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
        fight_player_board.hp_text:SetAlign(flux.ALIGN_LEFT):SetHUD(true)
        fight_player_board.hp_text:SetColor(0, 0, 0)
        fight_player_board.hp_text:SetPosition(9.7, -7.2)
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
        fight_player_board.mp_text:SetAlign(flux.ALIGN_LEFT):SetHUD(true)
        fight_player_board.mp_text:SetColor(0, 0, 0)
        fight_player_board.mp_text:SetPosition(9.7, -8.5)
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

        fight_player_board.name:SetText(name .. ' lv.' .. player.level)
        fight_player_board.hp_bar:SetSize(hp_width, 0.2)
        fight_player_board.hp_bar:SetPosition(hp_position_y, -7.7)
        fight_player_board.mp_bar:SetSize(mp_width, 0.2)
        fight_player_board.mp_bar:SetPosition(mp_position_y, -9)

        fight_player_board.hp_text:SetText(player.hp .. '/' .. player.hp_max)
        fight_player_board.mp_text:SetText(player.mp .. '/' .. player.mp_max)
    end

    fight_player_board.new()
    return fight_player_board
end

-- 玩家
local function createFigthPlayer(this)
    local player_pic = {}
    player_pic.player = flux.View(this)
    player_pic.player:SetHUD(true)
    player_pic.player:SetColor(0, 0, 0)
    player_pic.player:SetSize(3, 4)
    player_pic.player:SetPosition(7, -2.5)
    this:AddView(player_pic.player)

    player_pic.dmg_num = flux.TextView(this, nil, 'wqy', '-2')
    player_pic.dmg_num:SetTextColor(1,0,0,0):SetPosition(7,0):SetHUD(true)
    this:AddView(player_pic.dmg_num)
    return player_pic
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

local function initEnemy(this)    
    ScreenFight.enemy_pic = {
        flux.TextView(ScreenFight.scr, nil, 'wqy'),
        flux.TextView(ScreenFight.scr, nil, 'wqy'),
        flux.TextView(ScreenFight.scr, nil, 'wqy'),
        flux.TextView(ScreenFight.scr, nil, 'wqy'),
    }

    ScreenFight.enemy_pic[1]:SetPosition(-7.1, 1.6)
    ScreenFight.enemy_pic[2]:SetPosition(-3.8, 4.3)
    ScreenFight.enemy_pic[3]:SetPosition(-0.5, 7)
    ScreenFight.enemy_pic[4]:SetPosition(-10.4, -1.1)

    for k,v in pairs(ScreenFight.enemy_pic) do
        v:SetSize(3, 4):SetTextColor(1,1,1):SetHUD(true):SetColor(0, 0, 0)
        ScreenFight.scr:AddView(v)
    end

    ScreenFight.enemy_dmg_num = {
        flux.TextView(this, nil, 'wqy', '-2'),
        flux.TextView(this, nil, 'wqy', '-2'),
        flux.TextView(this, nil, 'wqy', '-2'),
        flux.TextView(this, nil, 'wqy', '-2'),
    }

    ScreenFight.enemy_dmg_num[1]:SetPosition(-7.1, 4.1)
    ScreenFight.enemy_dmg_num[2]:SetPosition(-3.8, 6.8)
    ScreenFight.enemy_dmg_num[3]:SetPosition(-0.5, 9.5)
    ScreenFight.enemy_dmg_num[4]:SetPosition(-10.4, 1.6)

    for k,v in pairs(ScreenFight.enemy_dmg_num) do
        v:SetTextColor(1,0,0):SetHUD(true)
        this:AddView(v)
    end

end

-- 怪物攻击玩家
local function attack_player(this)

    local function _(k,v)
        local i = math.random(1, #data.ch)
        local dmg = Enemy:Attack(v, data.ch[i], v[5])
        print('怪物', v[1], '攻击玩家！造成伤害', dmg)

        if dmg ~= -0 then
            ScreenFight.player_pic.dmg_num:SetText('-'..dmg):SetAlpha(1)
        else
            ScreenFight.player_pic.dmg_num:SetText(tostring(dmg)):SetAlpha(1)
        end
        -- 注意：View和TextView之间的某些动画必须分行写
        ScreenFight.player_pic.dmg_num:Sleep(0.4)
        ScreenFight.player_pic.dmg_num:FadeOut(0.1):Sleep(0.4, wrap(function()
            local key = k+1
            local value = ScreenFight.enm_lst[key]
            if value then
                _(key, value)
            else
                ScreenFight.input_pause = false
            end
        end)):AnimDo()

        if not character.hp_dec(data.ch[i], dmg) then
            print('你死亡了!')
            theWorld:PopScreen()
            return
        end
        ScreenFight.player_board.refurbish(data.ch[i])
    end

    local k,v = next(ScreenFight.enm_lst)
    if k then
        ScreenFight.input_pause = true
        _(k, v)
    else
        -- 这个时候已经没有怪物了，应该是个BUG
        ScreenFight.input_pause = false
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
            this:SetRetCode(0)
            ScreenFight.splash:FadeOut(0.5):AnimDo()
            local player = data.ch[1]
            ScreenFight.player_board.refurbish(player)
            for k,v in pairs(ScreenFight.enemy_pic) do
                v:SetAlpha(0)
            end
            for k,v in pairs(ScreenFight.enemy_dmg_num) do
                v:SetAlpha(0)
            end
            local num = #ScreenFight.enm_lst
            for i=1,num do
                ScreenFight.enemy_pic[i]:SetTextColor(1,1,1):SetColor(0,0,0,1)
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

            if state == flux.GLFW_PRESS and not ScreenFight.input_pause then
                local cursel = ScreenFight.fight_menu.cursel
                if key == flux.GLFW_KEY_ESC then
                    -- “取消”操作
                    if ScreenFight.select_aim then
                        ScreenFight.fight_menu.ptr:SetAlpha(0)
                        ScreenFight.select_aim = nil
                    end
                elseif key == flux.GLFW_KEY_SPACE or key == _b'Z' then
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
                            ScreenFight.input_pause = true
                            ScreenFight.last_select = ScreenFight.select_aim
                            ScreenFight.fight_menu.ptr:SetAlpha(0)

                            local dmg = Character:Attack(data.ch[1], ScreenFight.enm_lst[ScreenFight.select_aim], 1)
                            print('伤害:', dmg)
                            ScreenFight.enemy_dmg_num[ScreenFight.select_aim]:SetText('-'..dmg):SetAlpha(1)
                            -- 注意：View和TextView之间的某些动画必须分行写
                            ScreenFight.enemy_dmg_num[ScreenFight.select_aim]:Sleep(0.4)
                            ScreenFight.enemy_dmg_num[ScreenFight.select_aim]:FadeOut(0.1):AnimDo()
                            -- 留下这个值，以后可能会在减血时进行技能判定。

                            -- 玩家打完了，轮到敌人打击玩家
                            ScreenFight.player_pic.player:Sleep(0.5, wrap(function()
                                local new_hp = ScreenFight.enm_lst[ScreenFight.select_aim][3] - dmg
                                if new_hp <= 0 then
                                    ScreenFight.enemy_pic[ScreenFight.select_aim]:FadeOut(1):AnimDo()
                                    print(ScreenFight.enm_lst[ScreenFight.select_aim][1], '已经死亡')
                                    ScreenFight.exp = ScreenFight.exp + Enemy:Exp(ScreenFight.enm_lst[ScreenFight.select_aim])
                                    ScreenFight.enm_lst[ScreenFight.select_aim] = nil

                                    if table.empty(ScreenFight.enm_lst) then
                                        ScreenFight.input_pause = true
                                        print('战斗结束! 获得经验', ScreenFight.exp)
                                        this:SetRetCode(ScreenFight.exp)
                                        theWorld:PopScreen()
                                    end
                                else
                                    ScreenFight.enm_lst[ScreenFight.select_aim][3] = new_hp
                                end

                                ScreenFight.select_aim = nil

                                attack_player(this)

                            end)):AnimDo()
                        end
                    elseif cursel == 3 then
                        -- 逃跑
                        theWorld:PopScreen()
                    elseif cursel == 4 then
                        print('防御')
                    end
                elseif key == flux.GLFW_KEY_LEFT then
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
                elseif key == flux.GLFW_KEY_RIGHT then
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
            ScreenFight.bg = flux.View(this)
            ScreenFight.bg:SetHUD(true):SetSize(32, 24)

            ScreenFight.splash = flux.View(this)
            ScreenFight.splash:SetHUD(true):SetSize(32, 24):SetColor(0,0,0)

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
            ScreenFight.player_pic = createFigthPlayer(this)
            -- 战斗菜单面板
            ScreenFight.fight_menu = createFightMenu()
            -- 敌人图像
            initEnemy(this)

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
        table.insert(enm_lst, Enemy:Dup(lst[index]))
    end
    --for k,v in pairs(enm_lst) do
    --    print(k,v)
    --end
    ScreenFight.new()
    ScreenFight.exp = 0
    ScreenFight.input_pause = false
    ScreenFight.enm_lst = enm_lst
    theWorld:PushScreen(ScreenFight.scr, flux.SCREEN_APPEND)
end
