
-- NameCard 角色名片
-- @param scr 你懂的
-- @param pos 控件中心位置，默认为 (0,0)
-- @param character 角色
Widget.NameCard = Class(Widget.Widget, function(self, scr, pos, ch)

    -- 最后一个参数本身并无任何意义，只是让父类有个渠道知道是哪一个子类在调用父类构造函数。
    Widget.Widget._ctor(self, scr, pos, "WIDGET.NAMECARD")
    
    local list = self._viewlist

    -- board_bg
    list[1] = flux.View(self.scr)
    list[1]:SetHUD(true):SetSize(6, 4):SetColor(0, 0, 0):SetPosition(pos[1], pos[2]) --(10, -7.7)

    -- board
    list[2] = flux.View(self.scr)
    list[2]:SetHUD(true):SetSize(5.8, 3.8):SetColor(1, 1, 1):SetPosition(pos[1], pos[2]) --(10, -7.7)

    -- head
    list[3] = flux.View(self.scr)
    list[3]:SetHUD(true):SetSize(2, 2.5):SetColor(0, 0, 0):SetPosition(pos[1] - 1.7, pos[2] - 0.5) -- (8.3, -8.2)

    -- name
    list[4] = flux.TextView(self.scr, nil, "wqy", 'name', 0.7)
    list[4]:SetHUD(true):SetColor(0, 0, 0):SetPosition(pos[1], pos[2] + 1.4) -- (10, -6.3)

    -- hp_text
    list[5] = flux.TextView(self.scr, nil, "wqy", 'hp', 0.7)
    list[5]:SetAlign(flux.ALIGN_LEFT):SetHUD(true):SetColor(0, 0, 0):SetPosition(pos[1] - 0.3, pos[2] + 0.5) -- (9.7, -7.2)

    -- hp_bar_bg
    list[6] = flux.View(self.scr)
    list[6]:SetHUD(true):SetColor(0.4, 0.4, 0.4):SetSize(3, 0.2):SetPosition(pos[1] + 1.1, pos[2]) -- (11.1, -7.7)

    -- hp_bar
    list[7] = flux.View(self.scr)
    list[7]:SetHUD(true):SetColor(1, 0, 0):SetSize(3, 0.2):SetPosition(pos[1] -0.4, pos[2]):SetAlign(flux.ALIGN_LEFT) -- (11.1, -7.7)

    -- mp_text
    list[8] = flux.TextView(self.scr, nil, "wqy", 'mp', 0.7)
    list[8]:SetAlign(flux.ALIGN_LEFT):SetHUD(true):SetColor(0, 0, 0):SetPosition(pos[1] - 0.3, pos[2] - 0.8) -- (9.7, -8.5)

    -- mp_bar_bg
    list[9] = flux.View(self.scr)
    list[9]:SetHUD(true):SetColor(0.4, 0.4, 0.4):SetSize(3, 0.2):SetPosition(pos[1] + 1.1, pos[2] - 1.3) -- (11.1, -9)

    -- mp_bar
    list[10] = flux.View(self.scr)
    list[10]:SetHUD(true):SetColor(0, 0, 1):SetSize(3, 0.2):SetPosition(pos[1] - 0.4, pos[2] - 1.3):SetAlign(flux.ALIGN_LEFT) -- (11.1, -9)

    if ch then
        self:SetCharacter(ch)
    end
end)

function Widget.NameCard:SetCharacter(ch)
    self.ch = ch
    self:Refresh()
end

function Widget.NameCard:_UpdatePos()
    list[1]:SetPosition(pos[1], pos[2])
    list[2]:SetPosition(pos[1], pos[2])
    list[3]:SetPosition(pos[1] - 1.7, pos[2] - 0.5)
    list[4]:SetPosition(pos[1]      , pos[2] + 1.4)
    list[5]:SetPosition(pos[1] - 0.3, pos[2] + 0.5)
    list[6]:SetPosition(pos[1] + 1.1, pos[2])
    list[7]:SetPosition(pos[1] - 0.4, pos[2])
    list[8]:SetPosition(pos[1] - 0.3, pos[2] - 0.8)
    list[9]:SetPosition(pos[1] + 1.1, pos[2] - 1.3)
    list[10]:SetPosition(pos[1]- 0.4, pos[2] - 1.3)
end

function Widget.NameCard:Refresh()
    local ch = self.ch
    local list = self._viewlist    
    if not ch then return end

    list[4]:SetText(ch:GetAttr('name') .. ' lv.' .. ch:GetAttr('level'))

    list[5]:SetText(ch:GetAttr('hp') .. '/' .. ch:GetAttr('hp_max'))
    list[8]:SetText(ch:GetAttr('mp') .. '/' .. ch:GetAttr('mp_max'))
    
    list[7]:SetSize(3*ch:GetAttr('hp') / ch:GetAttr('hp_max'), 0.2)
    list[10]:SetSize(3*ch:GetAttr('mp') / ch:GetAttr('mp_max'), 0.2)
end
