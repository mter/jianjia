--
--
--ShowText��ʹ�÷���:
--����Ϊ:(��Ļ���,{"����","���",������,����λ��,����,{"ѡ���֧1","ѡ���֧2"},�ص�����},{"����",{"ѡ���˷�֧1","ѡ���˷�֧2"},������,λ��,����,{"��֧1","��֧2"},"û���������ֺ������ĵ����仰"},{"ͼƬһ","ͼƬ��"})
--ShowText(101, {{"Yu","һ����������",2,1,102,{'��֧1','��֧2'},callback},{"���ص���",{"��֧1�Ľ��","��֧2�Ľ��"},1,2,101,{'��֧3','��֧4'}},{"Yu","b",2,1,101},{"���ص���","c",1,2,102},{"Yu","d",2,1,102},"һ�����������߰�"},{"Resources/Images/SCA07.png","Resources/Images/hero.png"})
--��ʹ��ͷ���ʱ��,ͷ�����������������λ��Ϊ3,���ұ�����������λ��Ϊ4,�÷���������һ��,��λ�ò�ͬ
--
--���ô�����Ϣ
--������ɫ:0.18,0.62,0.34
--�Ի�������ɫ205 205 180,
--ѡ����ɫ0.55,0.55,0.48
--�Ķ������ɫ139 139 122

ScreenText = {}

local TextColor = {
    Name = flux.Color(0.18, 0.62, 0.34),
    UnfinshRead = flux.Color(0.8, 0.8, 0.71),
    FinishRead = flux.Color(0.55, 0.55, 0.48), --139 139 122
    SwitchCase = flux.Color(0.42, 0.57, 0.14),
}

local function SetNext(this, curpos)
    local text = ScreenText.textlist[curpos]
    if type(text) == 'string' then
        ScreenText.t:SetText(text):SetPosition(-11, -4.5)

        --�����������������
        if ScreenText.portrait then
            if ScreenText.portrait:GetAlpha() ~= 0 then
                ScreenText.portrait:AnimCancel()
                ScreenText.portrait:FadeOut(1):AnimDo()
            end
        end
        --���ִ���������
        if ScreenText.name then
            ScreenText.name:AnimCancel()
            ScreenText.name:FadeOut(1, nil, -1):AnimDo()
        end
    else
        --����
        ScreenText.name:AnimCancel()
        ScreenText.name:SetText(text[1]):SetAlpha(1)
        --����
        local msg
        if type(text[2]) == 'table' then
            msg = text[2][ScreenText.curSelection]
        elseif type(text[2]) == 'string' then
            msg = text[2]
        end
        ScreenText.t:SetText(msg):SetPosition(-11, -4.5)
        ScreenText.portrait:SetAlpha(1)
        --����������Ϣ
        if ScreenText.ch_info then
            if ScreenText.ch_info[text[3]] then
                if ScreenText.portrait then
                    ScreenText.portrait:AnimCancel()
                    ScreenText.portrait:SetSprite(ScreenText.ch_info[text[3]]) --:SetAlpha(1)
                end
                --����λ��
                if text[4] == 1 then
                    --���������
                    ScreenText.portrait:SetPosition(-8, -4):SetSize(8.8, 20.34)
                    ScreenText.type = 1
                elseif text[4] == 2 then
                    --�������ұ�
                    ScreenText.portrait:SetPosition(8, -4):SetSize(8.8, 20.34)
                    ScreenText.type = 1
                elseif text[4] == 3 then
                    --Сͼ�����
                    ScreenText.portrait:SetPosition(-9, -6):SetSize(5, 5)
                    ScreenText.type = 3
                    --��ӵ�������
                    this:AddView(ScreenText.portrait, 10)
                    ScreenText.name:SetPosition(-6, -3.4)
                    ScreenText.t:SetPosition(-6, -4.5)
                    for k, v in pairs(ScreenText.switchCase) do
                        v:SetPosition(-6, -5 + -1 * k)
                    end
                elseif text[4] == 4 then
                    --Сͼ���ұ�
                    ScreenText.portrait:SetPosition(9, -6):SetSize(5, 5)
                    ScreenText.type = 4
                    this:AddView(ScreenText.portrait, 10)
                    ScreenText.name:SetPosition(4, -3.4)
                    ScreenText.t:SetPosition(-10, -4.5)
                    for k, v in pairs(ScreenText.switchCase) do
                        v:SetPosition(-9, -5 + -1 * k)
                    end
                end

            else
                ScreenText.portrait:SetAlpha(0)
            end
        else
            ScreenText.portrait:SetAlpha(0)
        end

        --����
        if text[5] then
            theSound:PlaySound(text[5])
        end

        --ѡ���֧
        if type(text[6]) == 'table' then
            for i = 1, 3 do
                if text[6][i] then
                    --��ʾ���ڵ�ѡ��
                    ScreenText.switchCase[i]:SetText('>   ' .. text[6][i]):SetAlpha(1)
                    ScreenText.switchNum = i
                else
                    --���ز����ڵ�ѡ��
                    ScreenText.switchCase[i]:SetAlpha(0)
                end
            end

            if ScreenText.type == 1 then
                ScreenText.selection:SetPosition(-10.3, -5 - ScreenText.curSelection):SetAlpha(1)
            elseif ScreenText.type == 3 then
                ScreenText.selection:SetPosition(-7, -5 - ScreenText.curSelection):SetAlpha(1)
            elseif ScreenText.type == 4 then
                ScreenText.selection:SetPosition(-10, -5 - ScreenText.curSelection):SetAlpha(1)
            end

            --���ô��ڷ�֧
            ScreenText.curExistSwitch = true
            --callback
            ScreenText.callback = text[7]
            --��֧���ڵ�λ��
            ScreenText.switchFlag = curpos
            ScreenText.tips:SetAlpha(1)
        else
            --��һ���Ի������ڷ�֧,�����ص�ǰ��֧
            if ScreenText.switchCase then
                --����ѡ����
                if ScreenText.selection then
                    ScreenText.selection:SetAlpha(0)
                end
                for i = 1, #ScreenText.switchCase do
                    ScreenText.switchCase[i]:SetAlpha(0)
                end
            end
            --������ʾ
            ScreenText.tips:SetAlpha(0)
            --�����ڷ�֧
            ScreenText.curExistSwitch = false
        end
    end
end

--��ʼ����Դ
local function InitRes(this, bgpic)
    --��ʼ������
    ScreenText.bg = flux.View(this)
    ScreenText.bg:SetSize(24, 6):SetPosition(0, -6):SetAlpha(0.8):SetHUD(true)
    --���ñ���
    if bgpic then
        ScreenText.bg:SetSprite(bgpic)
    else
        ScreenText.bg:SetSprite('Resources/Images/textbg.png')
    end
    this:AddView(ScreenText.bg)

    --��ʼ��ѡ��
    ScreenText.switchCase = {
        flux.TextView(ScreenText.scr, nil, 'wqy'),
        flux.TextView(ScreenText.scr, nil, 'wqy'),
        flux.TextView(ScreenText.scr, nil, 'wqy')
    }
    for k, v in pairs(ScreenText.switchCase) do
        v:SetTextColor(TextColor.SwitchCase):SetAlpha(0):SetPosition(-9, -5 + -1 * k):SetAlign(flux.ALIGN_LEFT):SetHUD(true)
        ScreenText.scr:AddView(v)
    end
    --��ʾѡ����
    if ScreenText.selection == nil then
        ScreenText.selection = flux.View(this)
        ScreenText.selection:SetSize(1, 1):SetAlpha(0):SetSprite('Resources/Images/hand.png'):SetAlign(flux.ALIGN_LEFT):SetHUD(true)
        this:AddView(ScreenText.selection)
    end

    --��ʼ������
    ScreenText.portrait = flux.View(this)
    ScreenText.portrait:SetAlpha(0):SetSize(8.8, 20.34):SetHUD(true)
    this:AddView(ScreenText.portrait, -2)

    --��ʼ������
    if ScreenText.t == nil then
        ScreenText.t = flux.TextView(this, nil, 'wqy')
        ScreenText.t:SetAlign(flux.ALIGN_TOPLEFT):SetHUD(true)
        ScreenText.t:SetTextColor(TextColor.UnfinshRead):SetTextAreaWidth(21.5):SetLineSpacing(15)
        this:AddView(ScreenText.t, 8)
    end
    --��ʼ������
    if ScreenText.name == nil then
        ScreenText.name = flux.TextView(this, nil, 'wqy')
        ScreenText.name:SetTextColor(TextColor.Name):SetHUD(true):SetAlign(flux.ALIGN_TOPLEFT):SetPosition(-11, -3.4)
        this:AddView(ScreenText.name, 5)
    end
    --��ʾ����
    ScreenText.tips = flux.TextView(this, nil, 'wqy')
    ScreenText.tips:SetPosition(5, -8):SetText("��Enterѡ��"):SetTextColor(1, 1, 1):SetAlpha(0):SetHUD(true)
    this:AddView(ScreenText.tips)
end

--�������к�,�Ի�����,����,����ͼ
function ShowText(fromcode, textlist, ch_info, bgpic)
    -- fromcode=100
    -- textlist{{'����','��һ�仰', ������, ����λ��, ����,{'��֧1','��֧2'...},callback}, '�ڶ��仰'}
    -- textlist{{'����','��һ�仰', ������, ����λ��, ����,{'��֧1','��֧2'...},callback}, {{'��֧1res'},{'��֧2res'}...}}
    -- ch_info = {'pic1', 'pic2', ...}
    if ScreenText.scr == nil then
        ScreenText.scr = flux.Screen()
        ScreenText.scr:lua_Init(wrap(function(this)

        -- ע�ᰴ��
            this:RegKey(_b'Z')
            this:RegKey(flux.GLFW_KEY_LEFT)
            this:RegKey(flux.GLFW_KEY_ESC)
            this:RegKey(flux.GLFW_KEY_ENTER)
            this:RegKey(flux.GLFW_KEY_SPACE)
            this:RegKey(flux.GLFW_KEY_RIGHT)
            this:RegKey(flux.GLFW_KEY_UP)
            this:RegKey(flux.GLFW_KEY_DOWN)


            InitRes(this, bgpic)
        end))

        ScreenText.scr:lua_OnPush(wrap(function(this)
            theWorld:PhyPause()
            if ScreenText.portrait then
                --ScreenText.portrait:SetAlpha(1)
            end
            SetNext(this, 1)
        end))

        --�ָ�
        ScreenText.scr:lua_OnPop(wrap(function(this)
            theWorld:PhyContinue()
            if ScreenText.portrait then
                ScreenText.portrait:AnimCancel()
            end
        end))

        ScreenText.scr:lua_KeyInput(wrap(function(this, key, state)
            if state == flux.GLFW_PRESS then
                if key == flux.GLFW_KEY_ENTER or key == flux.GLFW_KEY_SPACE or key == _b'Z' or key == flux.GLFW_KEY_RIGHT then
                    --enterѡ�е�ǰѡ��
                    if ScreenText.curExistSwitch then
                        if key == flux.GLFW_KEY_ENTER then
                            --print("ѡ��:"..ScreenText.curSelection)
                            --callback
                            if type(ScreenText.callback) == 'function' then
                                --�ص�ѡ����
                                ScreenText.callback(ScreenText.curSelection)
                            end
                        else
                            --��ѡ����
                            return
                        end
                    end

                    if ScreenText.curpos > #ScreenText.textlist then
                        this:SetFromCode(ScreenText.fromcode)
                        theWorld:PopScreen()
                    else
                        SetNext(this, ScreenText.curpos)
                        --������ɫ
                        if ScreenText.readpos <= ScreenText.curpos then
                            ScreenText.readpos = ScreenText.curpos
                            ScreenText.t:SetTextColor(TextColor.UnfinshRead)
                        else
                            ScreenText.t:SetTextColor(TextColor.FinishRead)
                        end
                        ScreenText.curpos = ScreenText.curpos + 1
                    end
                elseif key == flux.GLFW_KEY_LEFT then
                    if ScreenText.curpos - 2 <= ScreenText.switchFlag then
                        --ScreenText.switchFlag���ڷ�֧���ܷ���
                        return
                    end
                    -- ��ʱ�����ǰһ�仰
                    if ScreenText.curpos > 2 then
                        SetNext(this, ScreenText.curpos - 2)
                        --������ɫ
                        ScreenText.t:SetTextColor(TextColor.FinishRead)
                        ScreenText.curpos = ScreenText.curpos - 1
                    end
                elseif key == flux.GLFW_KEY_ESC then
                    this:SetFromCode(ScreenText.fromcode)
                    theWorld:PopScreen()
                end

                --ѡ���֧
                if ScreenText.curExistSwitch then
                    if key == flux.GLFW_KEY_UP then
                        if ScreenText.curSelection <= 1 then
                            ScreenText.curSelection = ScreenText.switchNum
                        else
                            ScreenText.curSelection = ScreenText.curSelection - 1
                        end
                        if ScreenText.type == 1 then
                            ScreenText.selection:SetPosition(-10.3, -5 - ScreenText.curSelection):SetAlpha(1)
                        elseif ScreenText.type == 3 then
                            ScreenText.selection:SetPosition(-7, -5 - ScreenText.curSelection):SetAlpha(1)
                        elseif ScreenText.type == 4 then
                            ScreenText.selection:SetPosition(-10, -5 - ScreenText.curSelection):SetAlpha(1)
                        end
                    elseif key == flux.GLFW_KEY_DOWN then
                        if ScreenText.curSelection >= ScreenText.switchNum then
                            ScreenText.curSelection = 1
                        else
                            ScreenText.curSelection = ScreenText.curSelection + 1
                        end
                        if ScreenText.type == 1 then
                            ScreenText.selection:SetPosition(-10.3, -5 - ScreenText.curSelection):SetAlpha(1)
                        elseif ScreenText.type == 3 then
                            ScreenText.selection:SetPosition(-7, -5 - ScreenText.curSelection):SetAlpha(1)
                        elseif ScreenText.type == 4 then
                            ScreenText.selection:SetPosition(-10, -5 - ScreenText.curSelection):SetAlpha(1)
                        end
                    end
                end
            end
        end))
    end
    --����,1Ϊ������,2ΪСͷ��
    ScreenText.type = 0
    --��ǰѡ���֧����
    ScreenText.switchNum = 1
    --����ͼƬ
    ScreenText.ch_info = ch_info
    --���һ�����ڷ�֧��λ��
    ScreenText.switchFlag = 0
    --��ǰ�Ƿ���ڷ�֧ѡ��
    ScreenText.curExistSwitch = false
    --��ǰѡ����
    ScreenText.curSelection = 1
    --�Ķ�λ��
    ScreenText.readpos = 2
    ScreenText.fromcode = fromcode
    ScreenText.textlist = textlist
    ScreenText.curpos = 2
    theWorld:PushScreen(ScreenText.scr, flux.SCREEN_APPEND)
end

-- ����Ի�����
-- ������������Ϊ table �Ĳ�����ÿ�� table ����һ�� ShowText �Ĳ�����
-- ���ѡ��һ�ײ������е��ã���ʵ�� NPC ������Ի�����
function RandomShowText(...)
    local t = { ... }
    local index = math.random(1, #t)
    local select = t[index]
    ShowText(select[1], select[2], select[3], select[4])
end
