
-- GridMenu ���˵�
-- @param scr �㶮��
-- @param width ���ɱ�������
-- @param height ���ɱ�������
-- @param pos �˵�������λ�ã�Ĭ��Ϊ (0,0)
-- @param step ��������ľ��룬Ĭ��Ϊ��2��1
Widget.GridMenu = Class(Widget.Widget, function(self, scr, width, height, pos, step)

    -- ���һ�������������κ����壬ֻ���ø����и�����֪������һ�������ڵ��ø��๹�캯����
    Widget.Widget._ctor(self, scr, pos, "WIDGET.GRIDMENU")
    if not width or not height then
        print(_'���󣺴��� GridMenu �ؼ�ʱȱ�ٲ���')
        return
    end
    
    -- λ�ơ����ڷ�ҳ��λ��λ������һҳ�Ľ���λ�ã�δʵװ��
    self.offset = 0
    self.step = step or {2,1}
    self:SetSize(width, height)

end)

-- �ڲ��������������
function Widget.GridMenu:_DoCallback(x, y, callback, not_ret_if_data_is_nil)
    if callback then
        local index = (x-1)*self.width + y
        local _x, _y = index % self.width, math.ceil(index / self.width)
        if _x == 0 then _x = self.width end
        callback(self, self.list[_x][_y], self.data[index + self.offset], index+self.offset)
    end
end

-- ����������
function Widget.GridMenu:SetSize(width, height)
    self.width = width
    self.height = height
    self._viewlist = {}
    local list = {}

    for x=1, self.width do
        list[x] = {}
        for y=1, self.height do
            local txt = flux.TextView(this, nil, 'wqyS')
            txt:SetPosition(self.pos[1] + (x-(width-1)) * self.step[1], self.pos[2] + (-y+1+height/2) * self.step[2])
            txt:SetHUD(true)
            list[x][y] = txt
            table.insert(self._viewlist, txt)
        end
    end

    self.list = list
end

-- ����λ�ã��ڲ�������
function Widget.GridMenu:_UpdatePos()
    if not table.empty(self.list) then
        for x=1, self.width do
            for y=1, self.height do
                local txt = self.list[x][y]
                txt:SetPosition(self.pos[1] + (x-1-self.width/2) * self.step[1], self.pos[2] + (-y+1+self.height/2) * self.step[2])
            end
        end
    end
end

-- ������������ľ���
function Widget.GridMenu:SetStep(x, y)
    self.step = {x,y}
    self:_UpdatePos()
end

-- �����ı���ɫ
function Widget.GridMenu:SetTextColor(r,g,b,a)
    local a = a or 1
    for x=1, self.width do
        for y=1, self.height do
            self.list[x][y]:SetTextColor(r,g,b,a)
        end
    end
end

-- ���ÿؼ�������ɫ
function Widget.GridMenu:SetColor(r,g,b,a)
    local a = a or 1
    self.col = flux.Color(r,g,b,a)
    for x=1, self.width do
        for y=1, self.height do
            self.list[x][y]:SetSize(self.step[1], self.step[2]):SetColor(self.col)
        end
    end
end

-- ���õ�ǰѡ�е���
function Widget.GridMenu:SetSel(x, y)
    -- ���޲�������֮ǰҲδ��ѡ����Ĭ��ѡΪ 1,1����֮ǰ�Ѿ�ѡ���ˣ���ֱ���˳�
    -- �����Ļ����ѡ����û�г��ֹ����������س�ʼ����������ֹ��ˣ��ͻ��ס�ϴ��˳�ʱ��λ���ˡ�
    if not x then
        if not self.sel then
            x, y = 1,1
        else
            return
        end
    end
    -- ������
    if x<=0 or y<=0 or x>self.width or y>self.height then
        print(_'����(' .. x .. ', ' .. y .. ') λ�ò����ڿ�ѡ�е��')
        return
    end
    if not self.selcol then
        self.selcol = flux.Color()
    end
    -- ��ȡ���ղ�ѡ�����
    if self.sel then
        self.list[self.sel[1]][self.sel[2]]:SetColor(self.col)
    end
    self.sel = {x, y}
    self.list[x][y]:SetColor(self.selcol)
    self:_DoCallback(y, x, self.move_callback)
end

-- ���õ�ǰ��ѡ����Ŀ�ı�����ɫ
function Widget.GridMenu:SetSelColor(r,g,b,a)
    local a = a or 1
    self.selcol = flux.Color(r,g,b,a)
    if self.sel then
        self.list[self.sel[1]][self.sel[2]]:SetColor(self.selcol)
    end
end

-- ���ûص�����
-- ��ÿ�α�ѡ����ı��ʱ�򱻵���
function Widget.GridMenu:SetMoveCallbak(callback)
    self.move_callback = callback
end

-- ����ѡ���ص�����
-- ���������� Z �� Space ʱ���������ص�
function Widget.GridMenu:SetSelectCallbak(callback)
    self.sel_callback = callback
end

-- ���ñ�������
-- @param data һ����������ݵı����� {'��Ʒ1', '��Ʒ2'}�������߾ͻ��մ˽�����ʾ����
function Widget.GridMenu:SetData(data)
    self.data = data
    if not self.datafunc then
        self.datafunc = function(self, view, data, index)
            if data then
                if type(data) == 'table' then
                    view:SetText(text[1])
                else
                    view:SetText(data)
                end
            else
                view:SetText('')
            end
        end
    end

    for x=1, self.width do
        for y=1, self.height do
            self:_DoCallback(x, y, self.datafunc)
        end
    end
end

-- �Զ��崦�� data �ĺ���
-- ������ android �е� adapter, Ĭ�ϵĺ���ֻ����һ�����飬������ data[n] ����һ�� string/table ����SetText/SetText��ĵ�һ��Ĳ���
-- ������Զ������������ʹ data[n] ���ں����ӷḻ��ͬʱ��һЩ�����ַ�����������֮�������
function Widget.GridMenu:SetCustomDataFunc(func)
    self.datafunc = func
end

-- ������Ӧ
function Widget.GridMenu:KeyInput(scr, key, state)

    local function _update(x, y)
        if x <= 0 then
            x = self.width
        elseif x > self.width then
            x = 1
        end

        if y <= 0 then
            if self.offset > 0 then
                self.offset = self.offset - self.width
                self:SetData(self.data)
                return
            else
                local datanum = #self.data
                y = self.height

                self.offset = (math.ceil(datanum / self.width) - self.height) * self.width
                if self.offset < 0 then
                    self.offset = 0
                end
                self:SetData(self.data)
            end
        elseif y > self.height then
            local num = self.width * self.height
            local datanum = #self.data
            
            if num + self.offset < datanum then
                self.offset = self.offset + self.width
                self:SetData(self.data)
                return
            else
                y = 1
                if self.offset > 0 then
                    self.offset = 0
                    self:SetData(self.data)
                end
            end
        end
        self:SetSel(x, y)
    end

    if state == flux.GLFW_PRESS and self.sel then
        local x,y = self.sel[1], self.sel[2]

        if key == flux.GLFW_KEY_LEFT then
            x = x - 1
        elseif key == flux.GLFW_KEY_RIGHT then
            x = x + 1
        elseif key == flux.GLFW_KEY_UP then
            y = y - 1
        elseif key == flux.GLFW_KEY_DOWN then
            y = y + 1
        elseif key == flux.GLFW_KEY_SPACE or key == _b'Z' then
            -- ����ѡ����ص�
            self:_DoCallback(y, x, self.sel_callback)
            return
        else
            return
        end
        _update(x, y)
    end
end
