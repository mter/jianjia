

ScreenStart = {

    cursel = 1,
    MenuColor = {flux.Color(0,1,1), flux.Color(1,1,0),flux.Color(1,0,0), },

    new = function()
        if ScreenStart.scr then return end

		-- 基础设定
        theSound:LoadSound(101, "Resources/Sounds/se001.ogg")
        theSound:LoadSound(102, "Resources/Sounds/se002.ogg")
        ScreenStart.scr = flux.Screen()

		-- 按键响应
        ScreenStart.scr:lua_KeyInput(wrap(function(this, key, state)
            local function update(offset)
                theSound:PlaySound(101)
                ScreenStart.cursel = ScreenStart.cursel + offset
                if ScreenStart.cursel == 0 then ScreenStart.cursel = #ScreenStart.Menu
                elseif ScreenStart.cursel == (#ScreenStart.Menu+1) then ScreenStart.cursel = 1 end
                local cursel = ScreenStart.cursel
				ScreenStart.Star:AnimCancel()
                ScreenStart.Star:MoveTo(0.3, -2, 1.5*(3-cursel)):RotateTo(0.3, 0, 90, nil, 0):RecolorTo(0.3, ScreenStart.MenuColor[cursel], nil, 0):AnimDo()
            end

            if state == flux.GLFW_PRESS then
                if key == flux.GLFW_KEY_ESC then
                    theWorld:EndGame()
                elseif key == flux.GLFW_KEY_UP then
                    update(-1)
                elseif key == flux.GLFW_KEY_DOWN then
                    update(1)
                elseif key == flux.GLFW_KEY_SPACE or key == flux.GLFW_KEY_ENTER or key == _b'Z' then
                    theSound:PlaySound(102)
                    local cursel = ScreenStart.cursel
                    if cursel == 1 then
                        theWorld:PushScreen(ScreenGame.scr)
                    elseif cursel == 2 then
                        theWorld:PushScreen(ScreenAbout.scr)
                    elseif cursel == 3 then
                        theWorld:EndGame()
                    end
                end
            end
        end))
	
	
		-- 初始化控件事件
        ScreenStart.scr:lua_Init(wrap(function(this)
            -- 标题
            ScreenStart.Title = flux.TextView(this, nil, "wqyL", config.TITLE)
            ScreenStart.Title:SetTextColor(0,0,1.0):SetPosition(0, 5):SetHUD(true)

            -- 菜单
            ScreenStart.Menu = {
                flux.TextView(this, nil, "wqyL", '开始', 0.7),
                flux.TextView(this, nil, "wqyL", '关于', 0.7),
                flux.TextView(this, nil, "wqyL", '离开', 0.7),
            }

            for k,v in pairs(ScreenStart.Menu) do
                v:SetHUD(true)
                v:SetPosition(0, 1.5*(3-k))
                this:AddView(v)
            end

            -- 选择器
            local cursel = ScreenStart.cursel
            ScreenStart.Star = flux.View(this)
            ScreenStart.Star:SetHUD(true):SetSize(1,1):SetColor(ScreenStart.MenuColor[cursel]):SetPosition(-2, 1.5*(3-cursel))

            -- 注册按键
            this:RegKey(flux.GLFW_KEY_ESC)
            this:RegKey(flux.GLFW_KEY_UP);
            this:RegKey(flux.GLFW_KEY_DOWN);
            this:RegKey(flux.GLFW_KEY_SPACE);
            this:RegKey(flux.GLFW_KEY_ENTER);
            this:RegKey(_b'Z');

			this:AddView(ScreenStart.Title)
			this:AddView(ScreenStart.Menu[1])
			this:AddView(ScreenStart.Menu[2])
			this:AddView(ScreenStart.Menu[3])
			this:AddView(ScreenStart.Star)
        end))

    end,
}
