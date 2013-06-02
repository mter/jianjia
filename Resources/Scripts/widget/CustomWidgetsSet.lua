
-- 自定义位置组件序列，附带选择功能
-- 这个组件可以根据传入的一组位置参数，在屏幕的若干指定位置显示若干个某类型 Widget
-- 例如在战斗界面中，使用这个组件在四个不同位置显示了敌人(当敌人数量为最大时)
-- 可以通过 CustomWidgetsSet.widgetlst 来访问这些控件

Widget.CustomWidgetsSet = Class(Widget.WidgetSet, function(self, scr, widgetcls, poslst)

    if not widgetcls or not poslst then
        print('错误: CustomWidgetsSet 缺少参数，无法被创建')
        return
    end

    Widget.WidgetSet._ctor(self, scr, pos, "WIDGET.CUSTOMWIDGETSSET")
    
    self.num = 4
    self.widgetcls = widgetcls
    self.poslst = poslst
    self.widgetlst = self._widgetlist

    local widgetlst = self._widgetlist
    for k,v in pairs(poslst) do
        table.insert(widgetlst, widgetcls(scr, v))
    end

    self.select = flux.TextView(scr, nil, 'wqy', "↓")
    self.select:SetTextColor(1,0,0)
    self.select:SetAlpha(0):SetHUD(true)

    table.insert(self._viewlist, self.select)
    self:Refresh()

end)

-- 设置组件的显示数量
function Widget.CustomWidgetsSet:SetVisibleNum(num)
    if num > #self.poslst then
        print('错误: CustomWidgetsSet:SetVisibleNum 设置的显示数量大于控件的最大数量')
        return
    end
    self.num = num
    self:Refresh()
end

-- 刷新
function Widget.CustomWidgetsSet:Refresh()
    local widgetlst = self._widgetlist
    for i=1,self.num do
        widgetlst[i]:SetVisible(true)
    end
    for i=self.num+1, #self.poslst do
        widgetlst[i]:SetVisible(false)
    end
end

-- 初始化选择，在此之前请设置选择回调函数
-- @param select_offset 选择箭头的位置偏移
function Widget.CustomWidgetsSet:ShowSelect(select_offset)
    local widgetlst = self._widgetlist
    
    -- 首先确保所有项都是可见的，若不满足直接返回
    local is_visible = false
    for k,v in pairs(widgetlst) do
        if v:GetVisible() then
            is_visible = true
        end
    end
    if not is_visible then
        return
    end
    
    self.select:SetAlpha(1)
    if not self.selectpos then
        self.selectpos = 1
    end
    while not widgetlst[self.selectpos]:GetVisible() do
        self.selectpos = self.selectpos + 1
        if self.selectpos > self.num then
            self.selectpos = 1
        end
    end
    self.select_offset = select_offset or {0, 2}
    local pos = self.poslst[self.selectpos]
    self.select:SetPosition(pos[1]+self.select_offset[1], pos[2]+self.select_offset[2])
end

-- 按键响应
function Widget.CustomWidgetsSet:KeyInput(scr, key, state)
    local function update(step)
        local widgetlst = self._widgetlist        

        repeat
            self.selectpos = self.selectpos + step
            if self.selectpos > self.num then
                self.selectpos = 1
            end
            if self.selectpos < 1 then
                self.selectpos = self.num
            end
        until widgetlst[self.selectpos]:GetVisible()

        local pos = self.poslst[self.selectpos]
        self.select:SetPosition(pos[1]+self.select_offset[1], pos[2]+self.select_offset[2])
    end
    if state == flux.GLFW_PRESS then
        if key == flux.GLFW_KEY_SPACE or key == _b'Z' then
            self.select:SetAlpha(0)
            if self.sel_callback then
                self.sel_callback(self, self.selectpos)
            end
        elseif key == flux.GLFW_KEY_LEFT then
            update(-1)
        elseif key == flux.GLFW_KEY_RIGHT then
            update(1)
        elseif key == flux.GLFW_KEY_ESC then
            self.select:SetAlpha(0)
            if self.sel_callback then
                self.sel_callback(self)
            end
        end
    end
end

-- 隐藏选择
function Widget.CustomWidgetsSet:HideSelect()
    self.select:SetAlpha(0)
end

-- 选择回调函数
function Widget.CustomWidgetsSet:SetSelectCallbak(callback)
    self.sel_callback = callback
end
