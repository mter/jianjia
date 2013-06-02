
-- 新手村

local function OnInit(self, scr)

    local views = self.viewlist

    -- 创建边界
    self:CreateEdge()

    views.boss = flux.TextView(scr, nil, 'wqy', '')
    views.boss:SetTextColor(1,1,1):SetSize(1.079, 1.245):SetPosition(3, 12.5):SetSprite('Resources/Images/fight.jpg'):SetPhy(flux.b2_staticBody):PhyNewFixture()

    views.head = flux.TextView(scr, nil, 'wqy', '村长')
    views.head:SetTextColor(1,1,1):SetSize(3,3):SetColor(0,0,0):SetPosition(-20, 0):SetPhy(flux.b2_staticBody):PhyNewFixture()

    --views.red = flux.TextView(scr, nil, 'wqy', '测试')
    --views.red:SetTextColor(1,1,1):SetSize(7,7):SetColor(0,0,0):SetPosition(5, 0):SetPhy(flux.b2_staticBody)

end

local function OnLoad(self, scr)
    SceneManager.map:SetColor(0.486, 0.80, 0.486)
    SceneManager.map:Load('Resources/Maps/newbie3.tmx'):SetAlpha(1)
    self:ResetEdge()

    if data.player.alignment == 0 then
        -- 新玩家
        theWorld:DelayRun(wrap(function()
            scr:SetPlayer(SceneManager.player)
            SceneManager.player:Reset()
            ShowText(101, {
                {'青年', '……'},
                {'青年', '这……这是哪里？我怎么……'},
                {'村长', '年轻人，你终于醒了。'},
                {'青年', '我……这是在……什么地方？我之前在……抱歉，我什么都记不得了。'},
                {'村长', '我是这里的村长，今天散步的时候发现你晕倒在了湖边。现在你刚刚醒来，先好好休息一下吧。'},
                {'青年', '请等一等。'},
                {'青年', '多谢你救了我。我叫伊方，但是除了这个什么都想不起来了。我似乎失去了很多记忆。请问，我现在在哪里？'},
                {'村长', '这里是大陆的最北端，海洋与群山怀抱中的土地。我的族人们时代安居于此，大陆上的战火纷争素来离我们很遥远，不过这样的日子或许快要过去了。'},
                {'村长', '近些年很有些年轻人出外闯荡，有人衣锦还乡，有人落魄而回，也有人从此杳无音讯。越来越多的人离开这里，也有越来越多的异乡人来到这里。离去的人带着对故乡的眷恋，到来的人握着商品与金钱。看着这些商队，看着海面上偶尔经过的船帆，我能感觉到整个世界都在时代中动荡。'},
                {'村长', '要我说的话，你不如就留在这个尚且还算宁静的地方吧。'},
                {'伊方', '多谢。不过我想出去走一走，或许能找回自己的记忆。'},
                {'村长', '也好，从你眼里，我看到了对探索的渴望。大陆上充满了各种危险，在旅程开始之前，我建议你去向村里的战职者导师讨教一下。'},
                {'村长', '那么我就离开了，等你觉得好一些的时候可以逛一逛村子。'},
                {'伊方', '好的，慢走。'},
                '',
                '空格键和Z键都是确认键，与人物对话时要走进按两者之一才行。',
                '另外B键可以查看背包', '由于是工程版本，所以这段话会在每次进入这个场景时出现，请谅解。',
                '请选择人物的行为倾向。'
            })
        end), 2)
    else
        -- 非新玩家
        theWorld:DelayRun(wrap(function()
            scr:SetPlayer(SceneManager.player)
            SceneManager.player:Reset()
        end), 1)
    end
    
end

local function KeyInput(self, scr, key, state)

    local views = self.viewlist
    
    if state == flux.GLFW_PRESS then
        if key == _b'Z' or key == flux.GLFW_KEY_SPACE then
            if SceneManager.player:CheckFacing(views.boss, 0.5) then
                ShowText(0, {{"紧握小黄书的男人","旅行者，有什么想说的么？",2,1,102,{'我们缺少原画！！','原画大神求带！！！'},callback},{"神秘的人",{"分支1的结果","分支2的结果"},1,2,101,{'分支3','分支4'}},{"Yu","b",2,1,101,{"ffdsaf1","fdafdsa2"}},{"神秘的人","c",1,2,102},{"Yu","d",2,1,102},"一二三四五六七八"},{"Resources/Images/SCA07.png","Resources/Images/hero.png"})
            elseif SceneManager.player:CheckFacing(views.head) then
                RandomShowText({0, {{'村长', '敲碗，无聊，敲碗，无聊，敲碗，无聊……'}}},  {0, {{'村长', '多少年来方圆百里的妇联主席都是我呀~'}}}, {0, {{'村长', '其实我只有一百一十八岁的，啊不，或者是十八岁比较年轻一点？'}}})
            end
        end
    end

end

local function PhyContactBegin(self, scr, a, b)
    -- 上边界
    if a.index == 3 and b.index == 10001 then
        
    -- 左边界
    elseif a.index == 3 and b.index == 10002 then
        SceneManager:Load('newbie_a2', 30, SceneManager.player:GetPosition().y)
    -- 下边界
    elseif a.index == 3 and b.index == 10003 then
    -- 右边界
    elseif a.index == 3 and b.index == 10004 then
    end
end

local function PhyContactEnd(self, scr, a, b)
    
end

SceneManager.scene.newbie_a3 = Scene(OnInit, OnLoad, KeyInput, PhyContactBegin, PhyContactEnd)
