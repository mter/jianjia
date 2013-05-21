
-- NameCard 角色名片
-- @param scr 你懂的
-- @param pos 控件中心位置，默认为 (0,0)
-- @param character 角色
Widget.NameCard = Class(Widget.Widget, function(self, scr, pos, ch)

    -- 最后一个参数本身并无任何意义，只是让父类有个渠道知道是哪一个子类在调用父类构造函数。
    Widget.Widget._ctor(self, scr, pos, "WIDGET.NAMECARD")
    if not ch then
        print(_'错误：创建 NameCard 控件时缺少参数')
        return
    end

    local list = self._viewlist
    list.board_bg = flux.View(self.scr)
    list.board_bg:SetHUD(true):SetSize(6, 4):SetColor(0, 0, 0):SetPosition(10, -7.7)

    list.board = flux.View(self.scr)
    list.board:SetHUD(true):SetSize(5.8, 3.8):SetColor(1, 1, 1):SetPosition(10, -7.7)
    
    list.head = flux.View(self.scr)
    list.head:SetHUD(true):SetSize(2, 2.5):SetColor(0, 0, 0):SetPosition(8.3, -8.2)
    
    list.name = flux.TextView(self.scr, nil, "wqy", ch:GetAttr('name'), 0.7)
    list.name:SetHUD(true):SetColor(0, 0, 0):SetPosition(10, -6.3)

    list.hp_text = flux.TextView(self.scr, nil, "wqy", ch:GetAttr('hp') .. '/' .. ch:GetAttr('hp_max'), 0.7)
    list.hp_text:SetAlign(flux.ALIGN_LEFT):SetHUD(true):SetColor(0, 0, 0):SetPosition(9.7, -7.2)

    list.hp_bar_bg = flux.View(self.scr)
    list.hp_bar_bg:SetHUD(true):SetColor(0.4, 0.4, 0.4):SetSize(3, 0.2):SetPosition(11.1, -7.7)

    list.hp_bar = flux.View(self.scr)
    list.hp_bar:SetHUD(true):SetColor(1, 0, 0):SetSize(3, 0.2):SetPosition(11.1, -7.7)

    list.mp_text = flux.TextView(self.scr, nil, "wqy", "MP", 0.7)
    list.mp_text:SetAlign(flux.ALIGN_LEFT):SetHUD(true):SetColor(0, 0, 0):SetPosition(9.7, -8.5)

    list.mp_bar_bg = flux.View(self.scr)
    list.mp_bar_bg:SetHUD(true):SetColor(0.4, 0.4, 0.4):SetSize(3, 0.2):SetPosition(11.1, -9)

    list.mp_bar = flux.View(self.scr)
    list.mp_bar:SetHUD(true):SetColor(0, 0, 1):SetSize(3, 0.2):SetPosition(11.1, -9)

end)

