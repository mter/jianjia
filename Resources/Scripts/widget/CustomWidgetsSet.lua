
-- �Զ���λ��������У�����ѡ����
-- ���������Ը��ݴ����һ��λ�ò���������Ļ������ָ��λ����ʾ���ɸ�ĳ���� Widget
-- ������ս�������У�ʹ�����������ĸ���ͬλ����ʾ�˵���(����������Ϊ���ʱ)
-- ����ͨ�� CustomWidgetsSet.widgetlst ��������Щ�ؼ�

Widget.CustomWidgetsSet = Class(Widget.WidgetSet, function(self, scr, widgetcls, poslst)

    if not widgetcls or not poslst then
        print('����: CustomWidgetsSet ȱ�ٲ������޷�������')
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

    self.select = flux.TextView(scr, nil, 'wqy', "��")
    self.select:SetTextColor(1,0,0)
    self.select:SetAlpha(0):SetHUD(true)

    table.insert(self._viewlist, self.select)
    self:Refresh()

end)

-- �����������ʾ����
function Widget.CustomWidgetsSet:SetVisibleNum(num)
    if num > #self.poslst then
        print('����: CustomWidgetsSet:SetVisibleNum ���õ���ʾ�������ڿؼ����������')
        return
    end
    self.num = num
    self:Refresh()
end

-- ˢ��
function Widget.CustomWidgetsSet:Refresh()
    local widgetlst = self._widgetlist
    for i=1,self.num do
        widgetlst[i]:SetVisible(true)
    end
    for i=self.num+1, #self.poslst do
        widgetlst[i]:SetVisible(false)
    end
end

-- ��ʼ��ѡ���ڴ�֮ǰ������ѡ��ص�����
-- @param select_offset ѡ���ͷ��λ��ƫ��
function Widget.CustomWidgetsSet:ShowSelect(select_offset)
    local widgetlst = self._widgetlist
    
    -- ����ȷ��������ǿɼ��ģ���������ֱ�ӷ���
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

-- ������Ӧ
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

-- ����ѡ��
function Widget.CustomWidgetsSet:HideSelect()
    self.select:SetAlpha(0)
end

-- ѡ��ص�����
function Widget.CustomWidgetsSet:SetSelectCallbak(callback)
    self.sel_callback = callback
end
