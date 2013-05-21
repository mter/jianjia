
Widget = {}

-- 控件基类
Widget.Widget = Class(function(self, scr, pos)
    self.scr = scr
    self.pos = pos or {0,0}
    --self._viewlist = {}
end)

-- 将控件添加至窗体
-- @param scr 指定的窗体
function Widget.Widget:AddToScreen(scr)
    for k,v in pairs(self._viewlist) do
        scr:AddView(v)
    end
end

-- 更新位置，内部函数。
function Widget.Widget:_UpdatePos()
    -- 这是一个虚函数，主要被重载
end

-- 设置控件位置
function Widget.Widget:SetPosition(x, y)
    pos = {x, y}
    self:_UpdatePos()
end

require('widget.GridMenu')
require('widget.NameCard')
