
Widget = {}

-- 控件基类
Widget.Widget = Class(function(self, scr, pos)
    self.scr = scr
    self.pos = pos or {0,0}
    self._viewlist = {}
    self._visible = true
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

-- 设置隐藏
function Widget.Widget:SetVisible(visible)
    self._visible = visible
    local alpha = 0
    if visible then
        alpha = 1
    end
    for k,v in pairs(self._viewlist) do
        v:SetAlpha(alpha)
    end
end

-- 获取隐藏参数
function Widget.Widget:GetVisible()
    return self._visible
end

require('widget.GridMenu')
require('widget.NameCard')
require('widget.EnemyImg')
