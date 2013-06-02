

function ShowItemPanel(in_fight)
    ScreenItem.new()
    ScreenItem.in_fight = in_fight
    local in_fight = in_fight or false
    theWorld:PushScreen(ScreenItem.scr, flux.SCREEN_APPEND)
end

ScreenItem = {

    new = function()

        if ScreenItem.scr then return end

        ScreenItem.scr = flux.Screen()

        ScreenItem.scr:lua_OnPush(wrap(function(this)
            theWorld:PhyPause()
            ScreenItem.menu:SetData(data.items)
            ScreenItem.menu:SetSel()
            ScreenItem.namecardset:Refresh()
            this:SetRetCode(0)
        end))

        ScreenItem.scr:lua_OnPop(wrap(function(this)
            theWorld:PhyContinue()
        end))

        -- 初始化控件事件
        ScreenItem.scr:lua_Init(wrap(function(this)
            -- 生成控件
            
            ScreenItem.txt = flux.TextView(this, nil, 'wqyS')
            ScreenItem.txt:SetPadding(0.3):SetAlign(flux.ALIGN_TOPLEFT):SetHUD(true)
            ScreenItem.txt:SetSize(6, 7):SetColor(0.49,0.49,0.49):SetPosition(2.51, 4)

            ScreenItem.menu = Widget.GridMenu(this, 2, 7, {-5, 0}, {5,1})
            ScreenItem.menu:SetColor(0.49,0.49,0.49)
            ScreenItem.menu:SetSelColor(0.79, 0.79, 0.79)
            
            local chlst
            if ScreenItem.in_fight then
                chlst = data.chfight
            else
                chlst = data.ch
            end
            ScreenItem.namecardset = Widget.NameCardSet(this, {10, -7.7}, chlst)

            ScreenItem.menu:SetCustomDataFunc(function(self, view, data)
                if data and not table.empty(data) then
                    local id = data[1]
                    view:SetText(items[id][1])
                else
                    view:SetText('')
                end
            end)

            ScreenItem.menu:SetMoveCallbak(function(self, view, data)
                if data then
                    local id = data[1]
                    ScreenItem.txt:SetText(items[id][1] .. '\n \n' ..items[id].txt .. '\n \n当前数量：' .. data[2])
                else
                    ScreenItem.txt:SetText('')
                end
            end)

            ScreenItem.menu:SetSelectCallbak(function(self, view, data)
                if data then
                    local id = data[1]
                    ScreenItem.item_id = id
                    ScreenItem.namecardset:ShowSelect()
                    --ScreenItem.select_pos = 1
                    --ScreenItem.select:SetAlpha(1)
                    --ScreenItem.select:SetPosition(10, -5)
                end
            end)
            
            ScreenItem.namecardset:SetSelectCallbak(function(self, select)
                if select then
                    local ret,txt = Items:Use(select, ScreenItem.item_id, ScreenItem.in_fight)
                    print('选择对 ' .. select:GetAttr('name') .. ' 使用 ' .. items[ScreenItem.item_id][1])
                    if not ret then
                        print(txt)
                    end
                    ScreenItem.namecardset:Refresh()
                end
                ScreenItem.item_id = nil
                if ScreenItem.in_fight then
                    this:SetRetCode(1)
                    theWorld:PopScreen()
                end
            end)

            this:SetFromCode(4)

            -- 注册按键
            this:RegKey(_b'Z')
            this:RegKey(flux.GLFW_KEY_ESC)
            this:RegKey(flux.GLFW_KEY_SPACE)
            this:RegKey(flux.GLFW_KEY_LEFT)
            this:RegKey(flux.GLFW_KEY_RIGHT)
            this:RegKey(flux.GLFW_KEY_UP)
            this:RegKey(flux.GLFW_KEY_DOWN)

            this:AddView(ScreenItem.txt)
            ScreenItem.menu:AddToScreen(this)
            ScreenItem.namecardset:AddToScreen(this)
        end))

        ScreenItem.scr:lua_KeyInput(wrap(function(this, key, state)
            
            if ScreenItem.item_id then
                ScreenItem.namecardset:KeyInput(this, key, state)
            else
                if state == flux.GLFW_PRESS then
                    if key == flux.GLFW_KEY_ESC then
                        theWorld:PopScreen()
                        return
                    end
                end
                ScreenItem.menu:KeyInput(this, key, state)
            end

        end))
    end

}
