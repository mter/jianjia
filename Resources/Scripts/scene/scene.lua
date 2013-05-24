

Scene = Class(function(self, init_func, onload_func, keyinput_func, phybegin_func, phyend_func)
    self.viewlist = {}
    self.isload = false
    self.init_func = init_func
    self.onload_func = onload_func
    self.keyinput_func = keyinput_func
    self.phybegin_func = phybegin_func
    self.phyend_func = phyend_func
end)

-- 加载和初始化控件
function Scene:Load()
    if not self.isload then
        self.init_func(self, SceneManager.scr)
        self.isload = true
    end
    self.onload_func(self, SceneManager.scr)
end

-- 释放所有控件
function Scene:Free()
    self.isload = false
    self.viewlist = {}
end

-- 创建地图边界
function Scene:CreateEdge()

    local views = self.viewlist

    -- 边框
    views.edge = {
        top = flux.View(screen),
        left = flux.View(screen),
        right = flux.View(screen),
        bottom = flux.View(screen),
    }

    views.edge.top:SetSize(400, 0.1):SetPosition(3000, 3000):SetColor(1,0,0):SetAlpha(1):SetPhy(flux.b2_staticBody):PhyNewFixture(10001)
    views.edge.left:SetSize(0.1, 400):SetPosition(-3000, 3001):SetColor(1,0,0):SetAlpha(1):SetPhy(flux.b2_staticBody):PhyNewFixture(10002)
    views.edge.right:SetSize(0.1, 400):SetPosition(-3000, 3002):SetColor(1,0,0):SetAlpha(1):SetPhy(flux.b2_staticBody):PhyNewFixture(10003)
    views.edge.bottom:SetSize(400, 0.1):SetPosition(3000, 3003):SetColor(1,0,0):SetAlpha(1):SetPhy(flux.b2_staticBody):PhyNewFixture(10004)

end

-- 根据当前地图大小决定边界位置
function Scene:ResetEdge()

    local views = self.viewlist
    local pos = SceneManager.map:GetSize()

    views.edge.top:SetSize(pos.x, 0.1):SetPosition(0, pos.y/2+0.05)
    views.edge.bottom:SetSize(pos.x, 0.1):SetPosition(0, -pos.y/2-0.05)
    views.edge.left:SetSize(0.1, pos.y):SetPosition(-pos.x/2-0.05, 0)
    views.edge.right:SetSize(0.1, pos.y):SetPosition(pos.x/2+0.05, 0)
    
    theCamera:SetSize(pos.x, pos.y)

end


-- 将控件添加至窗体
-- @param scr 指定的窗体
function Scene:AddToScreen(scr)
    self:Load()
    for k,v in pairs(self.viewlist) do
        if type(v) == 'table' then
            for k,v in pairs(v) do
                scr:AddView(v)
            end
        else
            scr:AddView(v)
        end
    end
end

function Scene:KeyInput(scr, key, value)
    if self.keyinput_func then
        self.keyinput_func(self, scr, key, value)
    end
end

function Scene:PhyContactBegin(scr, a, b)
    if self.phybegin_func then
        self.phybegin_func(self, scr, a, b)
    end
end

function Scene:PhyContactEnd(scr, a, b)
    if self.phyend_func then
        self.phyend_func(self, scr, a, b)
    end
end

