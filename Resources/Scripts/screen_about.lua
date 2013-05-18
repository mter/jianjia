
ScreenAbout = {

    new = function()

        if ScreenAbout.scr then return end

        ScreenAbout.scr = flux.Screen()

        ScreenAbout.scr:lua_OnPush(wrap(function(this)
        end))

        -- 初始化控件事件
        ScreenAbout.scr:lua_Init(wrap(function(this)
        -- 生成控件
            ScreenAbout.About = flux.TextView(this, nil, "wqyL", config.TITLE)
            ScreenAbout.About:SetColor(0,0,1):SetPosition(0, 6):SetHUD(true)

            -- 注册按键
            this:RegKey(flux.GLFW_KEY_ESC)
            this:RegKey(flux.GLFW_KEY_SPACE)
            this:RegKey(_b'Z')

            this:AddView(ScreenAbout.About)
        end))

        ScreenAbout.scr:lua_KeyInput(wrap(function(this, key, state)
            if state == flux.GLFW_PRESS then
                if key == flux.GLFW_KEY_ESC or key == flux.GLFW_KEY_SPACE or key == _b'Z' then
                    theWorld:PushScreen(ScreenStart.scr)
                end
            end
        end))
    end

}