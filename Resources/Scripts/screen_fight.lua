--����״̬�б�
local characterSpellState = {}
local enemySpellState = {}
--��ʾͷ����״̬
local function showState(who, nums, color)
    if who.is_character then
        if not color then
            color = flux.Color(1, 0, 0)
        end
        --����
        ScreenFight.player_pic.dmg_num:SetText(tostring(nums)):SetColor(color):SetAlpha(1)
        -- ע�⣺View��TextView֮���ĳЩ�����������д
        ScreenFight.player_pic.dmg_num:FadeOut(0.4):AnimDo()
        --��ԭ
        ScreenFight.player_pic.dmg_num:SetColor(1, 0, 0)
    else
        --����
        ScreenFight.enm_lst[who] = 0
        -- ScreenFight.enm_lst[i]:GetAttr('name')
        local p
        for k, v in pairs(ScreenFight.enm_lst) do
            if v == who then
                p = k
            end
        end
        if p then
            ScreenFight.enemy_dmg_num[p]:SetText(nums):SetColor(color):SetAlpha(1)
            -- ע�⣺View��TextView֮���ĳЩ�����������д
            ScreenFight.enemy_dmg_num[p]:FadeOut(0.4):AnimDo()
            ScreenFight.enemy_dmg_num[p]:SetColor(1, 0, 0)
        end
    end
end

--�ͷż���
local function castSpell(splState)
    --ʩչ��,����,����
    --id, ���֣�          ����,     ����,   ��ѧ������ ����˵��
    for k, v in pairs(splState) do
        --ʩ����,����,����
        local spellcaster = v[1]
        local spl = v[2]
        local victims = v[3]
        print("spl=" .. spl.effect[1].delay)
        --�ж��Ƿ��ͷ�ʱ��ͳ���ʱ��
        if spl.effect[1].delay == 0 and spl.effect[1].round >= 1 then
            local result = Spell:Cast(spellcaster, victims, spl)
            if result then
                --��ʾʩ��Ч��
                for k, v in pairs(result) do
                    print("����Ч��---->   " .. k .. "==" .. v)
                    showState(victims, v, flux.Color(0, 0, 1))
                end
            end
            --ʩչ�����ȥ������������
            spl.cost = {}
            --�����غϼ�1
            spl.effect[1].round = spl.effect[1].round - 1
        elseif spl.effect[1].delay > 0 then
            --��ȥһ���غϵȴ�ʱ��
            spl.effect[1].delay = spl.effect[1].delay - 1
        else
            --�Ѿ��ͷ�������Ƴ�
            table.remove(splState, k)
        end
    end
end



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
        fight_player_board.name:SetHUD(true)
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
        local name = player:GetAttr('name')
        local hp_max = player:GetAttr('hp_max')
        local hp_now = player:GetAttr('hp')
        local mp_max = player:GetAttr('mp_max')
        local mp_now = player:GetAttr('mp')

        local hp_width = 3 * (hp_now / hp_max)
        local hp_position_y = 9.6 + hp_width / 2
        local mp_width = 3 * (mp_now / mp_max)
        local mp_position_y = 9.6 + mp_width / 2

        fight_player_board.name:SetText(name .. ' lv.' .. player:GetAttr('level'))
        fight_player_board.hp_bar:SetSize(hp_width, 0.2)
        fight_player_board.hp_bar:SetPosition(hp_position_y, -7.7)
        fight_player_board.mp_bar:SetSize(mp_width, 0.2)
        fight_player_board.mp_bar:SetPosition(mp_position_y, -9)

        fight_player_board.hp_text:SetText(hp_now .. '/' .. hp_max)
        fight_player_board.mp_text:SetText(mp_now .. '/' .. mp_max)
    end

    fight_player_board.new()
    return fight_player_board
end

-- ���
local function createFigthPlayer(this)
    local player_pic = {}
    player_pic.player = flux.View(this)
    player_pic.player:SetHUD(true)
    player_pic.player:SetColor(0, 0, 0)
    player_pic.player:SetSize(3, 4)
    player_pic.player:SetPosition(7, -2.5)
    this:AddView(player_pic.player)

    player_pic.dmg_num = flux.TextView(this, nil, 'wqy', '-2')
    player_pic.dmg_num:SetTextColor(1, 0, 0, 0):SetPosition(7, 0):SetHUD(true)
    this:AddView(player_pic.dmg_num)
    return player_pic
end

-- ս���˵����
local function createFightMenu()
    local fight_menu = { cursel = 1 }

    fight_menu.color = { sel = flux.Color(0.79, 0.79, 0.79), nor = flux.Color(0.79, 0.79, 0.79, 0) }

    fight_menu.attack = flux.TextView(ScreenFight.scr, nil, "wqy", "����", 0.7)
    fight_menu.attack:SetHUD(true):SetPosition(-10, -5.5):SetSize(1.5, 1):SetColor(fight_menu.color.sel)
    ScreenFight.scr:AddView(fight_menu.attack)

    fight_menu.magic = flux.TextView(ScreenFight.scr, nil, "wqy", "����", 0.7)
    fight_menu.magic:SetHUD(true):SetPosition(-8.5, -7):SetSize(1.5, 1):SetColor(fight_menu.color.nor)
    ScreenFight.scr:AddView(fight_menu.magic)

    fight_menu.defense = flux.TextView(ScreenFight.scr, nil, "wqy", "����", 0.7)
    fight_menu.defense:SetHUD(true):SetPosition(-11.5, -7):SetSize(1.5, 1):SetColor(fight_menu.color.nor)
    ScreenFight.scr:AddView(fight_menu.defense)

    fight_menu.escape = flux.TextView(ScreenFight.scr, nil, "wqy", "����", 0.7)
    fight_menu.escape:SetHUD(true):SetPosition(-10, -8.5):SetSize(1.5, 1):SetColor(fight_menu.color.nor)
    ScreenFight.scr:AddView(fight_menu.escape)

    fight_menu.ptr = flux.TextView(ScreenFight.scr, nil, 'wqy', '��')
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

    for k, v in pairs(ScreenFight.enemy_pic) do
        v:SetSize(3, 4):SetTextColor(1, 1, 1):SetHUD(true):SetColor(0, 0, 0)
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

    for k, v in pairs(ScreenFight.enemy_dmg_num) do
        v:SetTextColor(1, 0, 0):SetHUD(true)
        this:AddView(v)
    end
end

-- ���﹥�����
local function attack_player(this)

    local function _(k, v)
        local i = math.random(1, #data.ch)
        local dmg = v:Attack(data.ch[i])
        print('����', v:GetAttr('name'), '������ң�����˺�', dmg)

        if dmg ~= -0 then
            ScreenFight.player_pic.dmg_num:SetText('-' .. dmg):SetAlpha(1)
        else
            ScreenFight.player_pic.dmg_num:SetText(tostring(dmg)):SetAlpha(1)
        end
        -- ע�⣺View��TextView֮���ĳЩ�����������д
        ScreenFight.player_pic.dmg_num:Sleep(0.4)
        ScreenFight.player_pic.dmg_num:FadeOut(0.1):Sleep(0.4, wrap(function()
            local key = k + 1
            local value = ScreenFight.enm_lst[key]
            if value then
                _(key, value)
            else
                ScreenFight.input_pause = false
            end
        end)):AnimDo()

        if data.ch[i]:Dec('hp', dmg) == 0 then
            print('��������!')
            theWorld:PopScreen()
            return
        end
        ScreenFight.player_board.refurbish(data.ch[i])
    end

    local k, v = next(ScreenFight.enm_lst)
    if k then
        ScreenFight.input_pause = true
        _(k, v)
    else
        -- ���ʱ���Ѿ�û�й����ˣ�Ӧ���Ǹ�BUG
        ScreenFight.input_pause = false
    end
    --�ֵ������ͷż���
    castSpell(enemySpellState)
end

ScreenFight = {
    exp = 0,
    new = function()
    -- �����趨
        if ScreenFight.scr then
            return
        end

        ScreenFight.scr = flux.Screen()

        -- OnPush �¼�
        ScreenFight.scr:lua_OnPush(wrap(function(this)
            this:SetRetCode(0)
            ScreenFight.splash:FadeOut(0.5):AnimDo()
            local player = data.ch[1]
            ScreenFight.player_board.refurbish(player)
            for k, v in pairs(ScreenFight.enemy_pic) do
                v:SetAlpha(0)
            end
            for k, v in pairs(ScreenFight.enemy_dmg_num) do
                v:SetAlpha(0)
            end
            local num = #ScreenFight.enm_lst
            for i = 1, num do
                ScreenFight.enemy_pic[i]:SetTextColor(1, 1, 1):SetColor(0, 0, 0, 1)
                ScreenFight.enemy_pic[i]:SetText(ScreenFight.enm_lst[i]:GetAttr('name'))
            end
        end))

        ScreenFight.scr:lua_OnPop(wrap(function(this)
            for k, v in pairs(ScreenFight.enemy_pic) do
                v:AnimCancel()
            end
            ScreenFight.splash:AnimCancel()
        end))

        -- ������Ӧ
        ScreenFight.scr:lua_KeyInput(wrap(function(this, key, state)

            local function update(cursel)
                ScreenFight.fight_menu.cursel = cursel
                for k, v in pairs(ScreenFight.fight_menu) do
                    if type(v) == 'userdata' then
                        v:SetColor(ScreenFight.fight_menu.color.nor)
                    end
                end
                ScreenFight.fight_menu[cursel]:SetColor(ScreenFight.fight_menu.color.sel)
            end

            if state == flux.GLFW_PRESS and not ScreenFight.input_pause then
                local cursel = ScreenFight.fight_menu.cursel
                if key == flux.GLFW_KEY_ESC then
                    -- ��ȡ��������
                    if ScreenFight.select_aim then
                        ScreenFight.fight_menu.ptr:SetAlpha(0)
                        ScreenFight.select_aim = nil
                    end
                    --ȡ���ͷż��ܲ���
                    if ScreenFight.spl ~= nil then
                        ScreenFight.spl = nil
                    end
                elseif key == flux.GLFW_KEY_SPACE or key == _b'Z' then
                    -- ���й������߷����ȵ�
                    if cursel == 1 then
                        -- ���ѡ���ˡ�����������ʼѡ��Ŀ��
                        if not ScreenFight.select_aim then
                            if ScreenFight.enm_lst[ScreenFight.last_select] then
                                ScreenFight.select_aim = ScreenFight.last_select
                            else
                                ScreenFight.select_aim = next(ScreenFight.enm_lst)
                            end
                            local pos = ScreenFight.enemy_pic[ScreenFight.select_aim]:GetPosition()
                            ScreenFight.fight_menu.ptr:SetPosition(pos.x, pos.y + 2.5):SetAlpha(1)
                        else
                            -- ���ѡ����Ҫ������Ŀ�꣬��ʼ����
                            local aim_index = ScreenFight.select_aim
                            local aim = ScreenFight.enm_lst[aim_index]

                            ScreenFight.input_pause = true
                            ScreenFight.last_select = aim_index
                            ScreenFight.fight_menu.ptr:SetAlpha(0)

                            local dmg = data.ch[1]:Attack(aim, 1)
                            print('�˺�:', dmg)
                            ScreenFight.enemy_dmg_num[aim_index]:SetText('-' .. dmg):SetAlpha(1)
                            -- ע�⣺View��TextView֮���ĳЩ�����������д
                            ScreenFight.enemy_dmg_num[aim_index]:Sleep(0.4)
                            ScreenFight.enemy_dmg_num[aim_index]:FadeOut(0.1):AnimDo()
                            -- �������ֵ���Ժ���ܻ��ڼ�Ѫʱ���м����ж���

                            -- ��Ҵ����ˣ���һЩ����Ч����Ȼ���ֵ����˴�����
                            ScreenFight.player_pic.player:Sleep(0.5, wrap(function()

                                local new_hp = aim:Dec('hp', dmg)

                                if new_hp <= 0 then
                                    ScreenFight.enemy_pic[aim_index]:FadeOut(1):AnimDo()
                                    print(aim:GetAttr('name'), '�Ѿ�����')

                                    local _exp, _loot = aim:Killed()

                                    ScreenFight.exp = ScreenFight.exp + _exp
                                    table.insert(ScreenFight.loot, _loot)
                                    ScreenFight.enm_lst[aim_index] = nil

                                    if table.empty(ScreenFight.enm_lst) then
                                        ScreenFight.input_pause = true
                                        print('ս������! ��þ���', ScreenFight.exp)
                                        theWorld:PopScreen()
                                    end
                                end

                                ScreenFight.select_aim = nil

                                attack_player(this)
                            end)):AnimDo()
                            --��ѭ����
                            castSpell(characterSpellState)
                        end
                    elseif cursel == 2 then
                        local callback = function(spl, level)
                            ScreenFight.spl = spl
                            if ScreenFight.spl.effect[1].action_on == 1 then
                                --���Լ�ʩ��,��ӵ��б�      --ʩչ��,����,����
                                --characterSpellState[table.length(characterSpellState) + 1] = { data.ch[1], table.copy(spl), data.ch[1] }
                                table.insert(characterSpellState, { data.ch[1], table.copy(spl), data.ch[1] })
                                castSpell(characterSpellState)
                                ScreenFight.player_board.refurbish(data.ch[1])
                            elseif ScreenFight.spl[5][1].action_on == 2 then
                                --ѡ�����
                                if not ScreenFight.select_aim and (ScreenFight.spl ~= nil) then
                                    if ScreenFight.enm_lst[ScreenFight.last_select] then
                                        ScreenFight.select_aim = ScreenFight.last_select
                                    else
                                        ScreenFight.select_aim = next(ScreenFight.enm_lst)
                                    end
                                    local pos = ScreenFight.enemy_pic[ScreenFight.select_aim]:GetPosition()
                                    ScreenFight.fight_menu.ptr:SetPosition(pos.x, pos.y + 2.5):SetAlpha(1)
                                end
                            end
                        end
                        if ScreenFight.spl then
                            ScreenFight.input_pause = true
                            ScreenFight.last_select = ScreenFight.select_aim
                            ScreenFight.fight_menu.ptr:SetAlpha(0)
                            local dmg = -1
                            --�����˺����߼��ܼӳ�
                            if ScreenFight.spl.effect[1].action_on == 1 then
                                --�����������ʩ��
                                --character.cast(data.ch[1], ScreenFight.spl, ScreenFight.enm_lst[ScreenFight.select_aim])
                            elseif ScreenFight.spl.effect[1].action_on == 2 then
                                --�Թ�����м��ܴ��
                                --d = character.cast(data.ch[1], ScreenFight.spl, ScreenFight.enm_lst[ScreenFight.select_aim])
                                dmg = Character:Attack(data.ch[1], ScreenFight.enm_lst[ScreenFight.select_aim], 3)

                                --��Ӽ���                                                         --ʩչ��,����,����
                                --characterSpellState[table.length(characterSpellState) + 1] = { data.ch[1], table.copy(spl), ScreenFight.enm_lst[ScreenFight.select_aim] }
                                table.insert(characterSpellState, { data.ch[1], table.copy(spl), ScreenFight.enm_lst[ScreenFight.select_aim] })
                                --ʩչ����
                                castSpell(characterSpellState)
                                ScreenFight.player_board.refurbish(data.ch[1])
                            end

                            if dmg ~= -1 then
                                ScreenFight.select_aim = next(ScreenFight.enm_lst)
                                print('ħ���˺�:' .. dmg)
                                ScreenFight.enemy_dmg_num[ScreenFight.select_aim]:SetText('-' .. dmg):SetAlpha(1)
                                -- ע�⣺View��TextView֮���ĳЩ�����������д
                                ScreenFight.enemy_dmg_num[ScreenFight.select_aim]:Sleep(0.4)
                                ScreenFight.enemy_dmg_num[ScreenFight.select_aim]:FadeOut(0.1):AnimDo()
                                -- �������ֵ���Ժ���ܻ��ڼ�Ѫʱ���м����ж���
                            else
                                dmg = 0
                            end
                            -- ��Ҵ����ˣ��ֵ����˴�����
                            ScreenFight.player_pic.player:Sleep(0.5, wrap(function()
                                if ScreenFight.enm_lst[ScreenFight.select_aim] then
                                    local new_hp = ScreenFight.enm_lst[ScreenFight.select_aim][3] - dmg
                                    if new_hp <= 0 then
                                        ScreenFight.enemy_pic[ScreenFight.select_aim]:FadeOut(1):AnimDo()
                                        print(ScreenFight.enm_lst[ScreenFight.select_aim][1], '�Ѿ�����')
                                        ScreenFight.exp = ScreenFight.exp + Enemy:Exp(ScreenFight.enm_lst[ScreenFight.select_aim])
                                        ScreenFight.enm_lst[ScreenFight.select_aim] = nil

                                        if table.empty(ScreenFight.enm_lst) then
                                            ScreenFight.input_pause = true
                                            print('ս������! ��þ���', ScreenFight.exp)
                                            theWorld:PopScreen()
                                        end
                                    else
                                        ScreenFight.enm_lst[ScreenFight.select_aim][3] = new_hp
                                    end
                                end
                                ScreenFight.select_aim = nil

                                attack_player(this)
                            end)):AnimDo()
                            ScreenFight.spl = nil
                        else
                            ShowSpellSelect(data.ch[1], callback)
                            theWorld:PushScreen(ScreenSpell.scr, flux.SCREEN_APPEND)
                        end
                    elseif cursel == 3 then
                        -- ����
                        theWorld:PopScreen()
                    elseif cursel == 4 then
                        print('����')
                    end
                elseif key == flux.GLFW_KEY_LEFT then
                    if ScreenFight.select_aim then
                        local k, v = table.get_prev(ScreenFight.enm_lst, ScreenFight.select_aim)
                        if not k then
                            k, v = table.get_last(ScreenFight.enm_lst)
                        end
                        if k then
                            local pos = ScreenFight.enemy_pic[k]:GetPosition()
                            ScreenFight.fight_menu.ptr:SetPosition(pos.x, pos.y + 2.5):SetAlpha(1)
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
                        local k, v = table.get_next(ScreenFight.enm_lst, ScreenFight.select_aim)
                        if not k then
                            k, v = table.get_first(ScreenFight.enm_lst)
                        end
                        if k then
                            local pos = ScreenFight.enemy_pic[k]:GetPosition()
                            ScreenFight.fight_menu.ptr:SetPosition(pos.x, pos.y + 2.5):SetAlpha(1)
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

        -- ��ʼ���ؼ��¼�
        ScreenFight.scr:lua_Init(wrap(function(this)
        -- ���ɿؼ�
            ScreenFight.bg = flux.View(this)
            ScreenFight.bg:SetHUD(true):SetSize(32, 24)

            ScreenFight.splash = flux.View(this)
            ScreenFight.splash:SetHUD(true):SetSize(32, 24):SetColor(0, 0, 0)

            -- ע�ᰴ��
            this:RegKey(_b'Z')
            this:RegKey(flux.GLFW_KEY_ESC)
            this:RegKey(flux.GLFW_KEY_SPACE)
            this:RegKey(flux.GLFW_KEY_LEFT)
            this:RegKey(flux.GLFW_KEY_RIGHT)
            this:RegKey(flux.GLFW_KEY_UP)
            this:RegKey(flux.GLFW_KEY_DOWN)

            this:AddView(ScreenFight.bg)

            this:SetFromCode(3)

            -- ��ɫ����
            ScreenFight.player_pic = createFigthPlayer(this)
            -- ս���˵����
            ScreenFight.fight_menu = createFightMenu()
            -- ����ͼ��
            initEnemy(this)

            this:AddView(ScreenFight.splash)

            -- ��ɫ��Ϣ���
            ScreenFight.player_board = createFightPlayerBoard()
        end))
    end,
}

-- ����ϴ�ս���Ľ����
function GetLastFightResult()
    return ScreenFight.exp or 0, ScreenFight.loot or {}
end

function ShowFight(lst)
    local num = math.random(1, 4)
    local enm_lst = {}
    for i = 1, num do
        local index = math.random(1, #lst)
        -- ��ʼ�����˲�����з��б�
        table.insert(enm_lst, Enemy(enemys[lst[index]]))
    end
    --for k,v in pairs(enm_lst) do
    --    print(k,v)
    --end
    ScreenFight.new()
    ScreenFight.exp = 0
    ScreenFight.loot = {}
    ScreenFight.input_pause = false
    ScreenFight.enm_lst = enm_lst
    theWorld:PushScreen(ScreenFight.scr, flux.SCREEN_APPEND)
end
