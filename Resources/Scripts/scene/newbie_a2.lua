
-- 新手村

local function OnInit(self, scr)

    local views = self.viewlist

    -- 创建边界
    self:CreateEdge()
    
    views.dummy = flux.TextView(scr, nil, 'wqy', '木桩')
    views.dummy:SetTextColor(1,1,1):SetSize(3, 2):SetColor(0,0,0):SetPosition(-2, -11):SetRotation(0):SetPhy(flux.b2_staticBody):PhyNewFixture()

end

local function OnLoad(self, scr)
    SceneManager.map:Load('Resources/Maps/newbie2.tmx'):SetAlpha(1)
    self:ResetEdge()

    theWorld:DelayRun(wrap(function()
        scr:SetPlayer(SceneManager.player)
        SceneManager.player:Reset()
    end), 1)
    
end

local function KeyInput(self, scr, key, state)

    local views = self.viewlist
    
    if state == flux.GLFW_PRESS then
        if key == _b'Z' or key == flux.GLFW_KEY_SPACE then
            if SceneManager.player:CheckFacing(views.dummy) then
                print('木桩！战个痛！')
                ShowFight(enemy_set.newbie)
            end
        end
    end

end

local function PhyContactBegin(self, scr, a, b)
    -- 上边界
    if a.index == 3 and b.index == 10001 then
        
    -- 左边界
    elseif a.index == 3 and b.index == 10002 then
    -- 右边界
    elseif a.index == 3 and b.index == 10003 then
        SceneManager:Load('newbie_a3', -30, SceneManager.player:GetPosition().y)
    -- 下边界
    elseif a.index == 3 and b.index == 10004 then
    end
end

local function PhyContactEnd(self, scr, a, b)
    
end

SceneManager.scene.newbie_a2 = Scene(OnInit, OnLoad, KeyInput, PhyContactBegin, PhyContactEnd)
