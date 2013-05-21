

ScreenGame = {

    new = function()
        if ScreenGame.scr then return end

        -- 基础设定
        ScreenGame.scr = flux.RMScreen()

        -- OnPush 事件
        ScreenGame.scr:lua_OnPush(wrap(function(this)
            theCamera:SetFocus(ScreenGame.player)
            ScreenGame.scr:SetPlayer(ScreenGame.player)
            ScreenGame.player:SetPosition(data.player.x, data.player.y)
            SceneManager:Load(data.player.scene)
        end))

        -- AfterPush 事件
        ScreenGame.scr:lua_AfterPush(wrap(function(this)

            if table.empty(data.ch) then
                table.insert(data.ch, Character('伊方'))

                --初始化技能
                data.ch[1].data.spells[2]=3
                data.ch[1].data.spells[3]=1
                data.ch[1].data.spells[5]=1
                data.ch[1].data.spells[4]=1
                data.ch[1].data.spells[9]=1
                data.ch[1].data.spells[9]=1
                data.ch[1].data.spells[8]=1
                data.ch[1].data.spells[7]=1
                --data.ch[1].spells[7]=1
            end

        end))

        ScreenGame.scr:lua_OnResume(wrap(function(this, from, ret)
            if from == 0 then
                ScreenGame.player:Reset()
            elseif from == 3 then
                -- 从战斗场景中回来
                local exp, loot = GetLastFightResult()
                if exp ~= 0 then
                    for k,v in pairs(data.ch) do
                        local level = v:Inc('exp', exp)
                        if level then
                            print('玩家', v:GetAttr('name'), '升到了', level, '级')
                        end
                    end
                    for _,_loot in pairs(loot) do
                        for _,v in pairs(_loot) do
                            print('怪物掉落了' .. items[v][1])
                            Items:GetItem(v)
                        end
                    end
                end
                if ret ~= 0 then
                end
            elseif from == 101 then
                ScreenAlignmentChoose.new()
                theWorld:PushScreen(ScreenAlignmentChoose.scr, flux.SCREEN_APPEND)
            elseif from == 1001 then
                data.player.alignment = ret
            end
        end))

        -- 按键响应
        ScreenGame.scr:lua_KeyInput(wrap(function(this, key, state)
            SceneManager:KeyInput(this, key, state)

            if state == flux.GLFW_PRESS then
                if key == flux.GLFW_KEY_ESC then
                    -- MsgBox(101, "是否想要回到标题页面？")
                elseif key == _b'C' then
                    if data.ch[1] then
                        theWorld:PushScreen(ScreenCharacter.scr, flux.SCREEN_APPEND)
                        show_character_content(data.ch[1])
                    end
                elseif key == _b'B' then
                    theWorld:PushScreen(ScreenItem.scr, flux.SCREEN_APPEND)
                end
            end
        end))
    
        -- 初始化控件事件
        ScreenGame.scr:lua_Init(wrap(function(this)
            -- 生成控件
            ScreenGame.player = flux.RMCharacter(this)
            ScreenGame.player:SetSpeed(6):SetSprite('Resources/Images/yf.png')
            ScreenGame.player:SetSize(2, 2.4)
            ScreenGame.player:SetPhy()

            ScreenGame.map = flux.TmxMap(this)
            ScreenGame.map:SetBlockSize(2)

            this:AddView(ScreenGame.player)
            this:AddView(ScreenGame.map, -1)

            -- 注册按键
            this:RegKey(_b'Z')
            -- character board
            this:RegKey(_b'C')
            this:RegKey(_b'B')
            this:RegKey(flux.GLFW_KEY_ESC)
            this:RegKey(flux.GLFW_KEY_SPACE)
            this:RegKey(flux.GLFW_KEY_LEFT)
            this:RegKey(flux.GLFW_KEY_RIGHT)
            this:RegKey(flux.GLFW_KEY_UP)
            this:RegKey(flux.GLFW_KEY_DOWN)
            
            SceneManager:Init()
        end))

		-- 物体接触开始
        ScreenGame.scr:lua_PhyContactBegin(wrap(function(this, a, b)
            SceneManager:PhyContactBegin(this, a, b)
        end))

		-- 物体接触结束
        ScreenGame.scr:lua_PhyContactEnd(wrap(function(this, a, b)
            SceneManager:PhyContactEnd(this, a, b)
        end))
    end,
}
