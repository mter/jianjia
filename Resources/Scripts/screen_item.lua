

function ShowItemPanel()
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
                    print('选择使用' .. items[id][1])
                end
            end)

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
		end))

        ScreenItem.scr:lua_KeyInput(wrap(function(this, key, state)
            if state == flux.GLFW_PRESS then
                if key == flux.GLFW_KEY_ESC then
                    theWorld:PopScreen()
                    return
                end
            end
            ScreenItem.menu:KeyInput(this, key, state)
        end))
    end

}
