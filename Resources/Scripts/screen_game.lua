

ScreenGame = {

    new = function()
        if ScreenGame.scr then return end

		-- 基础设定
        ScreenGame.scr = flux.RMScreen()
		
		-- OnPush 事件
        ScreenGame.scr:lua_OnPush(wrap(function(this)
			ScreenGame.scr:SetPlayer(ScreenGame.player)
			this:AddView(ScreenGame.player)
			this:AddView(ScreenGame.v1, -2)
			this:AddView(ScreenGame.t1, -2)
        end))

		-- 按键响应
        ScreenGame.scr:lua_KeyInput(wrap(function(this, key, state)
		    if state == flux.GLFW_PRESS then
                if key == flux.GLFW_KEY_ESC then
                    -- MsgBox(101, "是否想要回到标题页面？")
				elseif key == _b'Z' then
					if ScreenGame.player:CheckFacing(ScreenGame.v1, 0.5) then
						print('进入战斗!')
						theWorld:PushScreen(ScreenFight.scr, flux.SCREEN_APPEND)
					end
                end
            end
        end))
	
		-- 初始化控件事件
        ScreenGame.scr:lua_Init(wrap(function(this)
            -- 生成控件
            ScreenGame.player = flux.RMCharacter(this)
			ScreenGame.player:SetColor(1,0,0)
			ScreenGame.player:SetPhy()
			
            ScreenGame.t1 = flux.TextView(this, nil, 'wqy', '陛下')
			ScreenGame.t1:SetValueMode(1):SetPosition(0, 5.5)
            ScreenGame.v1 = flux.View(this)
			ScreenGame.v1:SetValueMode(1):SetSprite('Resources/Images/fight.jpg'):SetSize(1.3,1.5):SetPosition(0,7):SetPhy(flux.b2_staticBody):PhyNewFixture(101)

            -- 注册按键
            this:RegKey(_b'Z')
            this:RegKey(flux.GLFW_KEY_ESC)
            this:RegKey(flux.GLFW_KEY_SPACE)
            this:RegKey(flux.GLFW_KEY_LEFT)
            this:RegKey(flux.GLFW_KEY_RIGHT)
            this:RegKey(flux.GLFW_KEY_UP)
            this:RegKey(flux.GLFW_KEY_DOWN)

        end))

    end,
}
