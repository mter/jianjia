
-- ��ʾ����ѡ�����
-- @param ch ִ���ߣ�����ҡ�����Ҳ֧�ֹ��
-- @param cast_callback ѡ��÷����Ժ�ִ�лص�����
function ShowSpellSelect(ch, cast_callback)
    ScreenSpell.new()
    ScreenSpell.ch = ch
    ScreenSpell.callback = cast_callback
end

--��ʾ����
ScreenSpell={
    --�Ѽ��ܴ�����
    new = function()

        if ScreenSpell.scr then return end        
        ScreenSpell.scr = flux.Screen()

        ScreenSpell.scr:lua_OnPush(wrap(function(this)
			theWorld:PhyPause()
            ScreenSpell.menu:SetData(ScreenSpell.ch:GetSpells())
            ScreenSpell.menu:SetSel()
        end))

        ScreenSpell.scr:lua_OnPop(wrap(function(this)
			theWorld:PhyContinue()
        end))

        ScreenSpell.scr:lua_Init(wrap(function(this)

            -- ���ɿؼ�
            ScreenSpell.txt = flux.TextView(this, nil, 'wqyS')
            ScreenSpell.txt:SetPadding(0.3):SetAlign(flux.ALIGN_TOPLEFT):SetHUD(true)
            ScreenSpell.txt:SetSize(6, 7):SetColor(0.49,0.49,0.49):SetPosition(0.51, 4)

            ScreenSpell.menu = Widget.GridMenu(this, 1, 7, {-7, 0}, {5,1})
            ScreenSpell.menu:SetColor(0.49,0.49,0.49)
            ScreenSpell.menu:SetSelColor(0.7, 0, 1)

            ScreenSpell.menu:SetCustomDataFunc(function(self, view, data)
                if data and not table.empty(data) then
                    local id = data[1]
                    view:SetText(spells[id][1])
                else
                    view:SetText('')
                end
            end)

            ScreenSpell.menu:SetMoveCallbak(function(self, view, data)
                if data then
                    local id = data[1]
                    ScreenSpell.txt:SetText(spells[id][1] .. '\n \n' ..spells[id].txt .. '\n \n��ǰ�ȼ���' .. data[2])
                else
                    ScreenSpell.txt:SetText('')
                end
            end)

            ScreenSpell.menu:SetSelectCallbak(function(self, view, data)
                if data then
                    local id = data[1]
                    local level = data[2]
                    local spl = spells[id]
                    print('ѡ��ʹ��' .. spl[1])

                    local can_cast, _type, txt  = Spell:CanCast(ScreenSpell.ch, spl, level)
                    if can_cast then
                        theWorld:PopScreen()
                        if ScreenSpell.callback then
                            ScreenSpell.callback(spl, level)
                        end
                    else
                        print(txt)
                    end
                end
            end)

            -- ע�ᰴ��
            this:RegKey(_b'Z')
            this:RegKey(flux.GLFW_KEY_LEFT)
            this:RegKey(flux.GLFW_KEY_ESC)
            this:RegKey(flux.GLFW_KEY_ENTER)
            this:RegKey(flux.GLFW_KEY_SPACE)
            this:RegKey(flux.GLFW_KEY_RIGHT)
            this:RegKey(flux.GLFW_KEY_UP)
            this:RegKey(flux.GLFW_KEY_DOWN)

            this:AddView(ScreenSpell.txt)
            ScreenSpell.menu:AddToScreen(this)
        end))

        ScreenSpell.scr:lua_KeyInput(wrap(function(this, key, state)
            if state == flux.GLFW_PRESS then
                if key == flux.GLFW_KEY_ESC then
                    theWorld:PopScreen()
                    return
                end
            end
            ScreenSpell.menu:KeyInput(this, key, state)
        end))

    end,
}
