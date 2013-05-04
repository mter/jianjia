

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
        end))

    end,
}
