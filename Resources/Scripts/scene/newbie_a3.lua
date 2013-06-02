
-- ���ִ�

local function OnInit(self, scr)

    local views = self.viewlist

    -- �����߽�
    self:CreateEdge()

    views.boss = flux.TextView(scr, nil, 'wqy', '')
    views.boss:SetTextColor(1,1,1):SetSize(1.079, 1.245):SetPosition(3, 12.5):SetSprite('Resources/Images/fight.jpg'):SetPhy(flux.b2_staticBody):PhyNewFixture()

    views.head = flux.TextView(scr, nil, 'wqy', '�峤')
    views.head:SetTextColor(1,1,1):SetSize(3,3):SetColor(0,0,0):SetPosition(-20, 0):SetPhy(flux.b2_staticBody):PhyNewFixture()

    --views.red = flux.TextView(scr, nil, 'wqy', '����')
    --views.red:SetTextColor(1,1,1):SetSize(7,7):SetColor(0,0,0):SetPosition(5, 0):SetPhy(flux.b2_staticBody)

end

local function OnLoad(self, scr)
    SceneManager.map:SetColor(0.486, 0.80, 0.486)
    SceneManager.map:Load('Resources/Maps/newbie3.tmx'):SetAlpha(1)
    self:ResetEdge()

    if data.player.alignment == 0 then
        -- �����
        theWorld:DelayRun(wrap(function()
            scr:SetPlayer(SceneManager.player)
            SceneManager.player:Reset()
            ShowText(101, {
                {'����', '����'},
                {'����', '�⡭�������������ô����'},
                {'�峤', '�����ˣ����������ˡ�'},
                {'����', '�ҡ��������ڡ���ʲô�ط�����֮ǰ�ڡ�����Ǹ����ʲô���ǲ����ˡ�'},
                {'�峤', '��������Ĵ峤������ɢ����ʱ�������ε����˺��ߡ�������ո��������Ⱥú���Ϣһ�°ɡ�'},
                {'����', '���һ�ȡ�'},
                {'����', '��л������ҡ��ҽ����������ǳ������ʲô���벻�����ˡ����ƺ�ʧȥ�˺ܶ���䡣���ʣ������������'},
                {'�峤', '�����Ǵ�½����ˣ�������Ⱥɽ�����е����ء��ҵ�������ʱ�������ڴˣ���½�ϵ�ս��������������Ǻ�ңԶ���������������ӻ����Ҫ��ȥ�ˡ�'},
                {'�峤', '��Щ�����Щ�����˳��ⴳ���������½����磬�������Ƕ��أ�Ҳ���˴Ӵ�������Ѷ��Խ��Խ������뿪���Ҳ��Խ��Խ������������������ȥ���˴��ŶԹ���ľ�������������������Ʒ���Ǯ��������Щ�̶ӣ����ź�����ż�������Ĵ��������ܸо����������綼��ʱ���ж�����'},
                {'�峤', 'Ҫ��˵�Ļ����㲻�������������һ��������ĵط��ɡ�'},
                {'����', '��л�����������ȥ��һ�ߣ��������һ��Լ��ļ��䡣'},
                {'�峤', 'Ҳ�ã���������ҿ����˶�̽���Ŀ�������½�ϳ����˸���Σ�գ����ó̿�ʼ֮ǰ���ҽ�����ȥ������սְ�ߵ�ʦ�ֽ�һ�¡�'},
                {'�峤', '��ô�Ҿ��뿪�ˣ�������ú�һЩ��ʱ����Թ�һ����ӡ�'},
                {'����', '�õģ����ߡ�'},
                '',
                '�ո����Z������ȷ�ϼ���������Ի�ʱҪ�߽�������֮һ���С�',
                '����B�����Բ鿴����', '�����ǹ��̰汾��������λ�����ÿ�ν����������ʱ���֣����½⡣',
                '��ѡ���������Ϊ����'
            })
        end), 2)
    else
        -- �������
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
                ShowText(0, {{"����С���������","�����ߣ���ʲô��˵��ô��",2,1,102,{'����ȱ��ԭ������','ԭ���������������'},callback},{"���ص���",{"��֧1�Ľ��","��֧2�Ľ��"},1,2,101,{'��֧3','��֧4'}},{"Yu","b",2,1,101,{"ffdsaf1","fdafdsa2"}},{"���ص���","c",1,2,102},{"Yu","d",2,1,102},"һ�����������߰�"},{"Resources/Images/SCA07.png","Resources/Images/hero.png"})
            elseif SceneManager.player:CheckFacing(views.head) then
                RandomShowText({0, {{'�峤', '���룬���ģ����룬���ģ����룬���ġ���'}}},  {0, {{'�峤', '����������Բ����ĸ�����ϯ������ѽ~'}}}, {0, {{'�峤', '��ʵ��ֻ��һ��һʮ����ģ�������������ʮ����Ƚ�����һ�㣿'}}})
            end
        end
    end

end

local function PhyContactBegin(self, scr, a, b)
    -- �ϱ߽�
    if a.index == 3 and b.index == 10001 then
        
    -- ��߽�
    elseif a.index == 3 and b.index == 10002 then
        SceneManager:Load('newbie_a2', 30, SceneManager.player:GetPosition().y)
    -- �±߽�
    elseif a.index == 3 and b.index == 10003 then
    -- �ұ߽�
    elseif a.index == 3 and b.index == 10004 then
    end
end

local function PhyContactEnd(self, scr, a, b)
    
end

SceneManager.scene.newbie_a3 = Scene(OnInit, OnLoad, KeyInput, PhyContactBegin, PhyContactEnd)
