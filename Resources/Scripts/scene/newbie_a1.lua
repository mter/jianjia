
-- 新手村

local function OnInit(self, scr)

    local views = self.viewlist

    -- 创建边界
    self:CreateEdge()

    views.boss = flux.TextView(scr, nil, 'wqy', '')
    views.boss:SetTextColor(1,1,1):SetSize(1.079, 1.245):SetPosition(3, 12.5):SetSprite('Resources/Images/fight.jpg'):SetPhy(flux.b2_staticBody):PhyNewFixture()

    views.dummy = flux.TextView(scr, nil, 'wqy', '木桩')
    views.dummy:SetTextColor(1,1,1):SetSize(1.5, 1):SetColor(0,0,0):SetPosition(-2, 11):SetRotation(0):SetPhy(flux.b2_staticBody):PhyNewFixture()

    views.head = flux.TextView(scr, nil, 'wqy', '村长')
    views.head:SetTextColor(1,1,1):SetSize(1,1):SetColor(0,0,0):SetPosition(-20, -8):SetPhy(flux.b2_staticBody):PhyNewFixture()

end

local function OnLoad(self, scr)
    SceneManager.map:Load('Resources/Maps/example.tmx'):SetAlpha(1)
    self:ResetEdge()
end

local function KeyInput(self, scr, key, state)

    local views = self.viewlist
    
    if state == flux.GLFW_PRESS then
        if key == _b'Z' or key == flux.GLFW_KEY_SPACE then
            if SceneManager.player:CheckFacing(views.boss, 0.5) then
                ShowText(0, {{"紧握小黄书的男人","旅行者，有什么想说的么？",2,1,102,{'我们缺少原画！！','原画大神求带！！！'},callback},{"神秘的人",{"分支1的结果","分支2的结果"},1,2,101,{'分支3','分支4'}},{"Yu","b",2,1,101,{"ffdsaf1","fdafdsa2"}},{"神秘的人","c",1,2,102},{"Yu","d",2,1,102},"一二三四五六七八"},{"Resources/Images/SCA07.png","Resources/Images/hero.png"})
            elseif SceneManager.player:CheckFacing(views.dummy) then
                print('木桩！战个痛！')
                ShowFight(enemy_set.newbie)
            elseif SceneManager.player:CheckFacing(views.head) then
                RandomShowText({{0, {{'村长', '敲碗，无聊，敲碗，无聊，敲碗，无聊……'}}},  {0, {{'村长', '多少年来方圆百里的妇联主席都是我呀~'}}}, {0, {{'村长', '其实我只有一百一十八岁的，啊不，或者是十八岁比较年轻一点？'}}}})
            end
        end
    end

end

local function PhyContactBegin(self, scr, a, b)
    if a.index == 3 and b.index == 10001 then
        
    elseif a.index == 3 and b.index == 10002 then
    elseif a.index == 3 and b.index == 10003 then
    elseif a.index == 3 and b.index == 10004 then
    
    end
end

local function PhyContactEnd(self, scr, a, b)
    
end

SceneManager.scene.newbie = Scene('newbie', OnInit, OnLoad, KeyInput, PhyContactBegin, PhyContactEnd)
