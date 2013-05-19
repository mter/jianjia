

function ShowItemPanel()
    theWorld:PushScreen(ScreenItem.scr, flux.SCREEN_APPEND)
end

ScreenItem = {

    new = function()

		if ScreenItem.scr then return end

        ScreenItem.scr = flux.Screen()
		
        ScreenItem.scr:lua_OnPush(wrap(function(this)
			theWorld:PhyPause()
            ScreenItem.menu:SetCustomDataFunc(function(self, x, y, data)
                if data and not table.empty(data) then
                    local id = data[1][1]
                    self.list[x][y]:SetText(items[id][1])
                else
                    self.list[x][y]:SetText('')
                end
            end)
            ScreenItem.menu:SetData(data.items)
            ScreenItem.menu:SetSel()
        end))

        ScreenItem.scr:lua_OnPop(wrap(function(this)
			theWorld:PhyContinue()
        end))

		-- 初始化控件事件
        ScreenItem.scr:lua_Init(wrap(function(this)
            -- 生成控件
            ScreenItem.menu = Widget.GridMenu(this, 3, 7, nil, {3,1})
            ScreenItem.menu:SetColor(0.49,0.49,0.49)
            ScreenItem.menu:SetSelColor(0.79, 0.79, 0.79)

            -- 注册按键
			this:RegKey(_b'Z')
            this:RegKey(flux.GLFW_KEY_ESC)
            this:RegKey(flux.GLFW_KEY_SPACE)
            this:RegKey(flux.GLFW_KEY_LEFT)
            this:RegKey(flux.GLFW_KEY_RIGHT)
            this:RegKey(flux.GLFW_KEY_UP)
            this:RegKey(flux.GLFW_KEY_DOWN)

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
