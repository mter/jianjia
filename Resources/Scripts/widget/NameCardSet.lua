
-- 名字列表组件，附带选择功能
-- 注意一点：这个组件集合的 pos 并非整个组件集合的中心位置，而是第一个组件的位置。
-- 也就是说这个组件作用是选择玩家名片，例如只有一个角色时，你设定的 position 是右下角
-- 那么当角色增加到2个，不用重设位置，增加的角色的名片会出现在角色1的左边

Widget.NameCardSet = Class(Widget.WidgetSet, function(self, scr, pos, chlst, showdead)

    Widget.WidgetSet._ctor(self, scr, pos, "WIDGET.NAMECARDSET")

    self.num = 0
    self.chlst = chlst or {}
    self.showdead = showdead

    local widgetlst = self._widgetlist
    for i=1,4 do
        table.insert(widgetlst, Widget.NameCard(scr, {10-(i-1)*6.1, -7.7}))
    end

    self.select = flux.TextView(scr, nil, 'wqy', "↓")
    self.select:SetTextColor(1,0,0)
    self.select:SetAlpha(0):SetHUD(true)
    
    table.insert(self._viewlist, self.select)
    self:Refresh()

end)

-- 设置角色列表
function Widget.NameCardSet:SetChlst(lst)
    self.chlst = lst
    self:Refresh()
end

-- 刷新
function Widget.NameCardSet:Refresh()
    local widgetlst = self._widgetlist
    local dead_offset = 0
    local num = 0
    for k,v in pairs(self.chlst) do
        if self.showdead then
            if v:GetAttr('hp') < 0 then
                dead_offset = dead_offset + 1
            else
                widgetlst[k+dead_offset]:SetCharacter(v)
                num = num + 1
            end
        else
            widgetlst[k]:SetCharacter(v)
            num = num + 1
        end
    end
    for i=1,num do
        widgetlst[i]:SetVisible(true)
    end
    for i=num+1, 4 do
        widgetlst[i]:SetVisible(false)
    end
    self.num = num
end

-- 初始化选择，在此之前请设置选择回调函数
function Widget.NameCardSet:ShowSelect()
    self.select:SetAlpha(1)
    self.selectpos = 1
    self.select:SetPosition(10-(self.selectpos-1)*6.1, -5)
end

-- 按键响应
function Widget.NameCardSet:KeyInput(scr, key, state)
    local function update()
        if self.selectpos > self.num then
            self.selectpos = 1
        end
        if self.selectpos < 1 then
            self.selectpos = self.num
        end
        self.select:SetPosition(10-(self.selectpos-1)*6.1, -5)
    end
    if state == flux.GLFW_PRESS then
        if key == flux.GLFW_KEY_SPACE or key == _b'Z' then
            self.select:SetAlpha(0)
            if self.sel_callback then
                self.sel_callback(self, self.chlst[self.selectpos], self.selectpos)
            end
        elseif key == flux.GLFW_KEY_LEFT then
            self.selectpos = self.selectpos - 1
            update()
        elseif key == flux.GLFW_KEY_RIGHT then
            self.selectpos = self.selectpos + 1
            update()
        elseif key == flux.GLFW_KEY_ESC then
            self.select:SetAlpha(0)
            if self.sel_callback then
                self.sel_callback(self)
            end
        end
    end
end

-- 隐藏选择
function Widget.NameCardSet:HideSelect()
    self.select:SetAlpha(0)
end

-- 选择回调函数
function Widget.NameCardSet:SetSelectCallbak(callback)
    self.sel_callback = callback
end
