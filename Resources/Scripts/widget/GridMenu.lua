
-- GridMenu 表格菜单
-- @param scr 你懂的
-- @param width 生成表格的列数
-- @param height 生成表格的行数
-- @param pos 菜单的中心位置，默认为 (0,0)
-- @param step 相邻两格的距离，默认为横2纵1
Widget.GridMenu = Class(Widget.Widget, function(self, scr, width, height, pos, step)

    -- 最后一个参数本身并无任何意义，只是让父类有个渠道知道是哪一个子类在调用父类构造函数。
    Widget.Widget._ctor(self, scr, pos, "WIDGET.GRIDMENU")
    if not width or not height then
        print(_'错误：创建 GridMenu 控件时缺少参数')
        return
    end
    
    -- 位移。用于翻页。位移位置是上一页的结束位置（未实装）
    self.offsetpos = 0
    self.step = step or {2,1}
    self:SetSize(width, height)

end)

-- 设置行列数
function Widget.GridMenu:SetSize(width, height)
    self.width = width
    self.height = height
    self._viewlist = {}
    local list = {}

    for x=1, self.width do
        list[x] = {}
        for y=1, self.height do
            local txt = flux.TextView(this, nil, 'wqyS')
            txt:SetPosition(self.pos[1] + (x-1-width/2) * self.step[1], self.pos[2] + (-y+1+height/2) * self.step[2])
            txt:SetHUD(true)
            list[x][y] = txt
            table.insert(self._viewlist, txt)
        end
    end

    self.list = list
end

-- 更新位置，内部函数。
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

-- 设置相邻两格的距离
function Widget.GridMenu:SetStep(x, y)
    self.step = {x,y}
    self:_UpdatePos()
end

-- 设置文本颜色
function Widget.GridMenu:SetTextColor(r,g,b,a)
    local a = a or 1
    for x=1, self.width do
        for y=1, self.height do
            self.list[x][y]:SetTextColor(r,g,b,a)
        end
    end
end

-- 设置控件背景颜色
function Widget.GridMenu:SetColor(r,g,b,a)
    local a = a or 1
    self.col = flux.Color(r,g,b,a)
    for x=1, self.width do
        for y=1, self.height do
            self.list[x][y]:SetSize(self.step[1], self.step[2]):SetColor(self.col)
        end
    end
end

-- 设置当前选中的项
function Widget.GridMenu:SetSel(x, y)
    -- 若无参数，且之前也未曾选过，默认选为 1,1；若之前已经选过了，则直接退出
    -- 这样的话如果选择光标没有出现过，会进行相关初始化，如果出现过了，就会记住上次退出时的位置了。
    if not x then
        if not self.sel then
            x, y = 1,1
        else
            return
        end
    end
    -- 检查错误
    if x<=0 or y<=0 or x>self.width or y>self.height then
        printf(_'错误：(' .. x .. ', ' .. y .. ') 位置不存在课选中的项。')
        return
    end
    if not self.selcol then
        self.selcol = flux.Color()
    end
    -- 先取消刚才选择的项
    if self.sel then
        self.list[self.sel[1]][self.sel[2]]:SetColor(self.col)
    end
    self.sel = {x, y}
    self.list[x][y]:SetColor(self.selcol)
    if self.move_callback then
        -- 回调
        local index = (x-1)*self.width + y
        self.move_callback(index, data[index], x, y)
    end
end

-- 设置当前被选中项目的背景颜色
function Widget.GridMenu:SetSelColor(r,g,b,a)
    local a = a or 1
    self.selcol = flux.Color(r,g,b,a)
    if self.sel then
        self.list[self.sel[1]][self.sel[2]]:SetColor(self.selcol)
    end
end

-- 设置回调函数
-- 在每次被选中项改变的时候被调用
function Widget.GridMenu:SetMoveCallbak(callback)
    self.move_callback = callback
end

-- 设置选定回调函数
-- 当对着这个项按 Z 或 Space 时会调用这个回调
function Widget.GridMenu:SetMoveCallbak(callback)
    self.sel_callback = callback
end

-- 设置表中数据
-- @param data 数据是一个 table 列表，例如 {'物品1', '物品2'}，随后这边就会照此进行显示
function Widget.GridMenu:SetData(data)
    local data = data or {}
    self.data = data
    if not self.datafunc then
        self.datafunc = function(self, x, y, text)
            if text then
                if type(text) == 'table' then
                    self.list[x][y]:SetText(text[1])
                else
                    self.list[x][y]:SetText(text)
                end
            else
                self.list[x][y]:SetText('')
            end
        end
    end

    for x=1, self.width do
        for y=1, self.height do
            local index = (x-1)*self.width + y
            self.datafunc(self, x, y, self.data[index])
        end
    end
end

-- 自定义处理 data 的函数
-- 类似于 android 中的 adapter, 默认的函数只会做一件事情，即，将 data[n] 当作一个 string/table 并做SetText/SetText表的第一项的操作
-- 你可以自定义这个方法，使 data[n] 的内涵更加丰富，同时做一些例如字符串长度限制之类的事情
function Widget.GridMenu:SetCustomDataFunc(func)
    self.datafunc = func
end

-- 按键响应
function Widget.GridMenu:KeyInput(scr, key, state)

    local function _update(x, y)
        if x <= 0 then
            x = self.width
        elseif x > self.width then
            x = 1
        end

        if y <= 0 then
            y = self.height
        elseif y > self.height then
            y = 1
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
            -- 调用选中项回调
            if self.sel_callback then
                local index = (x-1)*self.width + y
                self.sel_callback(index, data[index], x, y)
                return
            end
        else
            return
        end
        _update(x, y)
    end
end
