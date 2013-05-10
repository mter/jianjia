
-- show character board of given character
show_character_content = function(character)
    local attr_order = {
        "strength",
        "agility",
        "intelligence",
        "spellpower",
        "endurance",
        "will",
    }
    local attr_name = flux.TextView(ScreenCharacter.scr, nil, "wqyL", "属性")
    attr_name:SetTextColor(1,0,0):SetPosition(6, 6):SetHUD(true)
    ScreenCharacter.scr:AddView(attr_name)
    for i = 1,#attr_order,1 do
        local k = attr_order[i]
        local v = character[k]
        local attr_name
        if attr_text[k] then
            attr_name = flux.TextView(ScreenCharacter.scr, nil, "wqyL", attr_text[k])
        else
            attr_name = flux.TextView(ScreenCharacter.scr, nil, "wqyL", "N/A")
        end
        local attr_num
        if v then 
            attr_num = flux.TextView(ScreenCharacter.scr, nil, "wqyL", v)
        else
            attr_num = flux.TextView(ScreenCharacter.scr, nil, "wqyL", "N/A")
        end
        attr_name:SetTextColor(1,0,0):SetPosition(6, 6 - i*2):SetHUD(true)
        attr_num:SetTextColor(0,0,1):SetPosition(8, 6 - i*2):SetHUD(true)
        ScreenCharacter.scr:AddView(attr_name)
        ScreenCharacter.scr:AddView(attr_num)
    end
end

ScreenCharacter = {

    new = function()
        if ScreenCharacter.scr then return end
		-- 基础设定
        ScreenCharacter.scr = flux.Screen()
		
		-- OnPush 事件
        ScreenCharacter.scr:lua_OnPush(wrap(function(this)
			ScreenCharacter.splash:FadeOut(0.9):AnimDo()

        end))
		-- 按键响应
        ScreenCharacter.scr:lua_KeyInput(wrap(function(this, key, state)
            if state == flux.GLFW_PRESS then
                if key == flux.GLFW_KEY_ESC then
                    theWorld:PopScreen()
                end
            end
        end))
		-- 初始化控件事件
        ScreenCharacter.scr:lua_Init(wrap(function(this)

            -- 生成控件
            ScreenCharacter.bg = flux.View(this):SetHUD(true):SetSize(32, 24)

            ScreenCharacter.splash = flux.View(this)
            ScreenCharacter.splash:SetSize(32, 24):SetColor(0,0,0)

            -- 注册按键
            -- this:RegKey(_b'Z')
            this:RegKey(flux.GLFW_KEY_ESC)
            this:RegKey(flux.GLFW_KEY_SPACE)
            this:RegKey(flux.GLFW_KEY_LEFT)
            this:RegKey(flux.GLFW_KEY_RIGHT)
            this:RegKey(flux.GLFW_KEY_UP)
            this:RegKey(flux.GLFW_KEY_DOWN)

            this:AddView(ScreenCharacter.bg)
            -- this:AddView(ScreenCharacter.splash)
            
        end))

    end,

}
