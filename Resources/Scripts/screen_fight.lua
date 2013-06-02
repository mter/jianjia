
ScreenFight = {
    new = function()
        -- 基础设定
        if ScreenFight.scr then return end
        ScreenFight.scr = flux.Screen()

        -- OnPush 事件
        ScreenFight.scr:lua_OnPush(wrap(function(this)
            ScreenFight.splash:FadeOut(0.5):AnimDo()
            ScreenFight.namecardset:SetChlst(data.chfight)
            ScreenFight.enemypic:SetVisibleNum(#ScreenFight.fight.enemy)
            
            for k,v in pairs(ScreenFight.fight.enemy) do
                ScreenFight.enemypic.widgetlst[k].title:SetText(v:GetAttr('name'))
            end

            ScreenFight.fightmenu:SetSel()
            
            ScreenFight.namecardset:HideSelect()
            ScreenFight.enemypic:HideSelect()

            -- 开始战斗循环
            ScreenFight.fightmenu:SetVisible(false)
            coroutine.resume(ScreenFight.co)
        end))

        ScreenFight.scr:lua_OnPop(wrap(function(this)
            ScreenFight.splash:AnimCancel()
        end))
        
        
        ScreenFight.scr:lua_OnResume(wrap(function(this, from, ret)
            if from == 4 and ret ~= 0 then
                -- 从物品界面回来，刷新血量等
                ScreenFight.Input = nil
                ScreenFight.fight:DoAction(ScreenFight.obj, ScreenFight.action)
                theWorld:DelayRun(wrap(function()
                    coroutine.resume(ScreenFight.co)
                end), 0.4)
            end
        end))

        -- 按键响应
        ScreenFight.scr:lua_KeyInput(wrap(function(this, key, state)
            if ScreenFight.Input then
                if ScreenFight.SelectAimEnm then
                    ScreenFight.enemypic:KeyInput(this, key, state)
                else
                    ScreenFight.fightmenu:KeyInput(this, key, state)
                end
            end
        end))

        -- 初始化控件事件
        ScreenFight.scr:lua_Init(wrap(function(this)
            -- 生成控件
            ScreenFight.bg = flux.View(this)
            ScreenFight.bg:SetHUD(true):SetSize(32, 24)

            ScreenFight.splash = flux.View(this)
            ScreenFight.splash:SetHUD(true):SetSize(32, 24):SetColor(0, 0, 0)

            -- 人物面板
            ScreenFight.namecardset = Widget.NameCardSet(this, {10, -7.7})
            
            -- 敌人图像
            ScreenFight.enemypic = Widget.CustomWidgetsSet(this, Widget.EnemyImg, {{-7.1, 1.6}, {-3.8, 4.3}, {-0.5, 7}, {-10.4, -1.1}})
            ScreenFight.enemypic:SetSelectCallbak(function(self, pos)
                -- 选择目标
                if pos then
                    local from, to, dmg = ScreenFight.fight:DoAction(ScreenFight.obj, ScreenFight.action, pos)
                    ScreenFight.fightmenu:SetVisible(false)
                    print(from:GetAttr('name')..' 攻击 '..to[1]:GetAttr('name')..' 造成伤害 '..dmg[1])
                    for k,v in pairs(to) do
                        if v:GetAttr('hp') <= 0 then
                            print(v:GetAttr('name') .. ' 死亡')
                            ScreenFight.enemypic.widgetlst[v.index]:SetVisible(false)
                        end
                    end
                    ScreenFight.namecardset:Refresh()
                    theWorld:DelayRun(wrap(function()
                        coroutine.resume(ScreenFight.co)
                    end), 0.8)
                end
                ScreenFight.SelectAimEnm = nil
                ScreenFight.Input = nil
            end)

            -- 战斗菜单
            ScreenFight.fightmenu = Widget.GridMenu(this, 1, 5, {5, 0}, {2,1})
            ScreenFight.fightmenu:SetColor(0.49,0.49,0.49)
            ScreenFight.fightmenu:SetSelColor(0.79, 0.79, 0.79)
            ScreenFight.fightmenu:SetData({'攻击','技能','道具','防御','逃跑'})
            ScreenFight.fightmenu:SetSelectCallbak(function(self, view, data, pos)
                ScreenFight.action = pos
                if pos == 1 then
                    -- 攻击
                    ScreenFight.SelectAimEnm = true
                    ScreenFight.enemypic:ShowSelect({0, 3})
                elseif pos == 2 then
                    -- 技能
                elseif pos == 3 then
                    -- 道具
                    ShowItemPanel(true)
                elseif pos == 4 then
                    -- 防御
                elseif pos == 5 then
                    -- 逃跑
                    theWorld:PopScreen()
                end
            end)

            this:SetFromCode(3)

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
            ScreenFight.enemypic:AddToScreen(this)
            ScreenFight.namecardset:AddToScreen(this)
            ScreenFight.fightmenu:AddToScreen(this)
        end))
    end,
}

local function fightloop()
    while true do
        -- 回合开始
        local obj = ScreenFight.fight:GetNext()
        ScreenFight.obj = obj
        if obj.is_character then
            ScreenFight.fightmenu:SetVisible(true)
        else
            theWorld:DelayRun(wrap(function()
                local from, to, dmg = ScreenFight.fight:DoAction(obj)
                print(from:GetAttr('name')..' 攻击 '..to[1]:GetAttr('name')..' 造成伤害 '..dmg[1])
                ScreenFight.namecardset:Refresh()
                coroutine.resume(ScreenFight.co)
            end), 0.8)
        end
        ScreenFight.Input = obj.is_character
        coroutine.yield()
        ScreenFight.namecardset:Refresh()
        if ScreenFight.fight:CheckOver() then
            print('战斗结束!')
            theWorld:DelayRun(wrap(function()
                theWorld:PopScreen()
            end), 0.8)
        end
    end
end

function ShowFight(random_enm_lst, enm_lst)    

    ScreenFight.fight = FightSession(random_enm_lst, enm_lst)
    ScreenFight.co = coroutine.create(fightloop)
    ScreenFight.new()
    
    -- 初始化
    ScreenFight.Input = false
    ScreenFight.SelectAimCh = nil
    ScreenFight.SelectAimEnm = nil
    
    theWorld:PushScreen(ScreenFight.scr, flux.SCREEN_APPEND)
end

function GetFightRet()
    return ScreenFight.fight:GetLastFightResult()
end
