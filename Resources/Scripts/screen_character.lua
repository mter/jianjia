-- show character board of given character
show_character_content = function(ctr)
    -- save local language for every elem
    local attr_text = {strength=_"力量", agility=_"敏捷", intelligence=_"智力", 
        spellpower=_"魔能", endurance=_"耐力", will=_"意志",}

    local bar_text = {hp=_"生命", mp=_"魔法", exp=_"经验",}
    local bar_order = {
        "hp",
        "hp_max",
        "mp",
        "mp_max",
        "exp",
        "exp_max",
    }
    local attr_order = {
        "strength",
        "agility",
        "intelligence",
        "spellpower",
        "endurance",
        "will",
    }
    local bar_color = {
        {1,0,0}, -- red
        {0,0,1}, -- blue
        {0.92,0.92,0.06}, -- yellow
    }
    local bar_box = {
        x=-4, y=10, w=6, h=1,
    }
    local attr_box = {
        x=6, y=6,
    }

    for i = 1,#bar_order,2 do
        local k = bar_order[i]
        local v = ctr[k]
        local k_max = bar_order[i+1]
        local v_max = ctr[k_max]
        print(ctr.level)
        print(v,v_max)
        -- show bar name
        local bar_name
        if bar_text[k] then
            bar_name = flux.TextView(ScreenCharacter.scr, nil, "wqyL", bar_text[k])
        else
            bar_name = flux.TextView(ScreenCharacter.scr, nil, "wqyL", _"N/A")
        end
        bar_name:SetTextColor(1,0,0):SetPosition(bar_box.x, bar_box.y - i*1):SetHUD(true)
        ScreenCharacter.scr:AddView(bar_name)
        local bar_x = bar_box.x + 2
        -- show the whole bar
        local bar_view_max = flux.View(ScreenCharacter.scr, nil)
        bar_view_max:SetSize(bar_box.w, bar_box.h):SetAlign(flux.ALIGN_LEFT)
        bar_view_max:SetColor(bar_color[(i+1)/2][1], bar_color[(i+1)/2][2], bar_color[(i+1)/2][3], 0.3)
        bar_view_max:SetPosition(bar_x, bar_box.y-i*1):SetHUD(true)
        ScreenCharacter.scr:AddView(bar_view_max)
        -- show the current bar
        local bar_view = flux.View(ScreenCharacter.scr, nil)
        bar_view:SetSize(bar_box.w*(v/v_max), bar_box.h):SetAlign(flux.ALIGN_LEFT)
        bar_view:SetColor(bar_color[(i+1)/2][1], bar_color[(i+1)/2][2], bar_color[(i+1)/2][3], 0.7)
        bar_view:SetPosition(bar_x, bar_box.y-i*1):SetHUD(true)
        ScreenCharacter.scr:AddView(bar_view)
        local bar_mark = flux.View(ScreenCharacter.scr, nil)
        bar_mark:SetSize(0.1, bar_box.h):SetAlign(flux.ALIGN_LEFT)
        bar_mark:SetColor(0,0,0)
        bar_mark:SetPosition(bar_x+bar_box.w*(v/v_max), bar_box.y-i*1):SetHUD(true)
        ScreenCharacter.scr:AddView(bar_mark)
    end
    local attr_name = flux.TextView(ScreenCharacter.scr, nil, "wqyL", _"属性")
    attr_name:SetTextColor(1,0,0):SetPosition(6, 6):SetHUD(true)
    ScreenCharacter.scr:AddView(attr_name)
    for i = 1,#attr_order,1 do
        local k = attr_order[i]
        local v = ctr[k]
        local attr_name
        if attr_text[k] then
            attr_name = flux.TextView(ScreenCharacter.scr, nil, "wqyL", attr_text[k])
        else
            attr_name = flux.TextView(ScreenCharacter.scr, nil, "wqyL", _"N/A")
        end
        local attr_num
        if v then 
            attr_num = flux.TextView(ScreenCharacter.scr, nil, "wqyL", v)
        else
            attr_num = flux.TextView(ScreenCharacter.scr, nil, "wqyL", "N/A")
        end
        attr_name:SetTextColor(1,0,0):SetPosition(attr_box.x, attr_box.y - i*2):SetHUD(true)
        attr_num:SetTextColor(0,0,1):SetPosition(attr_box.x+2, attr_box.y - i*2):SetHUD(true)
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
