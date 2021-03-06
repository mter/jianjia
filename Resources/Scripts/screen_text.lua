--
--
--ShowText的使用方法:
--参数为:(屏幕编号,{"名字","语句",例会编号,立绘位置,声音,{"选择分支1","选择分支2"},回调方法},{"名字",{"选择了分支1","选择了分支2"},立绘编号,位置,声音,{"分支1","分支2"},"没有立绘名字和声音的第三句话"},{"图片一","图片二"})
--ShowText(101, {{"Yu","一二三四五六",2,1,102,{'分支1','分支2'},callback},{"神秘的人",{"分支1的结果","分支2的结果"},1,2,101,{'分支3','分支4'}},{"Yu","b",2,1,101},{"神秘的人","c",1,2,102},{"Yu","d",2,1,102},"一二三四五六七八"},{"Resources/Images/SCA07.png","Resources/Images/hero.png"})
--当使用头像的时候,头像在左边则设置立绘位置为3,在右边则设置立绘位置为4,用法与带立绘的一致,仅位置不同
--
--设置窗口信息
--名字颜色:0.18,0.62,0.34
--对话内容颜色205 205 180,
--选择颜色0.55,0.55,0.48
--阅读完毕颜色139 139 122

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

        --如果存在立绘则隐藏
        if ScreenText.portrait then
            if ScreenText.portrait:GetAlpha() ~= 0 then
                ScreenText.portrait:AnimCancel()
                ScreenText.portrait:FadeOut(1):AnimDo()
            end
        end
        --名字存在则隐藏
        if ScreenText.name then
            ScreenText.name:AnimCancel()
            ScreenText.name:FadeOut(1, nil, -1):AnimDo()
        end
    else
        --名字
        ScreenText.name:AnimCancel()
        ScreenText.name:SetText(text[1]):SetAlpha(1)
        --内容
        local msg
        if type(text[2]) == 'table' then
            msg = text[2][ScreenText.curSelection]
        elseif type(text[2]) == 'string' then
            msg = text[2]
        end
        ScreenText.t:SetText(msg):SetPosition(-11, -4.5)
        ScreenText.portrait:SetAlpha(1)
        --设置立绘信息
        if ScreenText.ch_info then
            if ScreenText.ch_info[text[3]] then
                if ScreenText.portrait then
                    ScreenText.portrait:AnimCancel()
                    ScreenText.portrait:SetSprite(ScreenText.ch_info[text[3]]) --:SetAlpha(1)
                end
                --立绘位置
                if text[4] == 1 then
                    --大立绘左边
                    ScreenText.portrait:SetPosition(-8, -4):SetSize(8.8, 20.34)
                    ScreenText.type = 1
                elseif text[4] == 2 then
                    --大立绘右边
                    ScreenText.portrait:SetPosition(8, -4):SetSize(8.8, 20.34)
                    ScreenText.type = 1
                elseif text[4] == 3 then
                    --小图像左边
                    ScreenText.portrait:SetPosition(-9, -6):SetSize(5, 5)
                    ScreenText.type = 3
                    --添加到最上面
                    this:AddView(ScreenText.portrait, 10)
                    ScreenText.name:SetPosition(-6, -3.4)
                    ScreenText.t:SetPosition(-6, -4.5)
                    for k, v in pairs(ScreenText.switchCase) do
                        v:SetPosition(-6, -5 + -1 * k)
                    end
                elseif text[4] == 4 then
                    --小图像右边
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

        --声音
        if text[5] then
            theSound:PlaySound(text[5])
        end

        --选择分支
        if type(text[6]) == 'table' then
            for i = 1, 3 do
                if text[6][i] then
                    --显示存在的选项
                    ScreenText.switchCase[i]:SetText('>   ' .. text[6][i]):SetAlpha(1)
                    ScreenText.switchNum = i
                else
                    --隐藏不存在的选项
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

            --设置存在分支
            ScreenText.curExistSwitch = true
            --callback
            ScreenText.callback = text[7]
            --分支存在的位置
            ScreenText.switchFlag = curpos
            ScreenText.tips:SetAlpha(1)
        else
            --下一个对话不存在分支,则隐藏当前分支
            if ScreenText.switchCase then
                --隐藏选项条
                if ScreenText.selection then
                    ScreenText.selection:SetAlpha(0)
                end
                for i = 1, #ScreenText.switchCase do
                    ScreenText.switchCase[i]:SetAlpha(0)
                end
            end
            --隐藏提示
            ScreenText.tips:SetAlpha(0)
            --不存在分支
            ScreenText.curExistSwitch = false
        end
    end
end

--初始化资源
local function InitRes(this, bgpic)
    --初始化背景
    ScreenText.bg = flux.View(this)
    ScreenText.bg:SetSize(24, 6):SetPosition(0, -6):SetAlpha(0.8):SetHUD(true)
    --设置背景
    if bgpic then
        ScreenText.bg:SetSprite(bgpic)
    else
        ScreenText.bg:SetSprite('Resources/Images/textbg.png')
    end
    this:AddView(ScreenText.bg)

    --初始化选项
    ScreenText.switchCase = {
        flux.TextView(ScreenText.scr, nil, 'wqy'),
        flux.TextView(ScreenText.scr, nil, 'wqy'),
        flux.TextView(ScreenText.scr, nil, 'wqy')
    }
    for k, v in pairs(ScreenText.switchCase) do
        v:SetTextColor(TextColor.SwitchCase):SetAlpha(0):SetPosition(-9, -5 + -1 * k):SetAlign(flux.ALIGN_LEFT):SetHUD(true)
        ScreenText.scr:AddView(v)
    end
    --显示选中条
    if ScreenText.selection == nil then
        ScreenText.selection = flux.View(this)
        ScreenText.selection:SetSize(1, 1):SetAlpha(0):SetSprite('Resources/Images/hand.png'):SetAlign(flux.ALIGN_LEFT):SetHUD(true)
        this:AddView(ScreenText.selection)
    end

    --初始化立绘
    ScreenText.portrait = flux.View(this)
    ScreenText.portrait:SetAlpha(0):SetSize(8.8, 20.34):SetHUD(true)
    this:AddView(ScreenText.portrait, -2)

    --初始化内容
    if ScreenText.t == nil then
        ScreenText.t = flux.TextView(this, nil, 'wqy')
        ScreenText.t:SetAlign(flux.ALIGN_TOPLEFT):SetHUD(true)
        ScreenText.t:SetTextColor(TextColor.UnfinshRead):SetTextAreaWidth(21.5):SetLineSpacing(15)
        this:AddView(ScreenText.t, 8)
    end
    --初始化名字
    if ScreenText.name == nil then
        ScreenText.name = flux.TextView(this, nil, 'wqy')
        ScreenText.name:SetTextColor(TextColor.Name):SetHUD(true):SetAlign(flux.ALIGN_TOPLEFT):SetPosition(-11, -3.4)
        this:AddView(ScreenText.name, 5)
    end
    --提示文字
    ScreenText.tips = flux.TextView(this, nil, 'wqy')
    ScreenText.tips:SetPosition(5, -8):SetText("按Enter选择"):SetTextColor(1, 1, 1):SetAlpha(0):SetHUD(true)
    this:AddView(ScreenText.tips)
end

--窗体序列号,对话内容,立绘,背景图
function ShowText(fromcode, textlist, ch_info, bgpic)
    -- fromcode=100
    -- textlist{{'名字','第一句话', 立绘编号, 立绘位置, 语音,{'分支1','分支2'...},callback}, '第二句话'}
    -- textlist{{'名字','第一句话', 立绘编号, 立绘位置, 语音,{'分支1','分支2'...},callback}, {{'分支1res'},{'分支2res'}...}}
    -- ch_info = {'pic1', 'pic2', ...}
    if ScreenText.scr == nil then
        ScreenText.scr = flux.Screen()
        ScreenText.scr:lua_Init(wrap(function(this)

        -- 注册按键
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

        --恢复
        ScreenText.scr:lua_OnPop(wrap(function(this)
            theWorld:PhyContinue()
            if ScreenText.portrait then
                ScreenText.portrait:AnimCancel()
            end
        end))

        ScreenText.scr:lua_KeyInput(wrap(function(this, key, state)
            if state == flux.GLFW_PRESS then
                if key == flux.GLFW_KEY_ENTER or key == flux.GLFW_KEY_SPACE or key == _b'Z' or key == flux.GLFW_KEY_RIGHT then
                    --enter选中当前选项
                    if ScreenText.curExistSwitch then
                        if key == flux.GLFW_KEY_ENTER then
                            --print("选中:"..ScreenText.curSelection)
                            --callback
                            if type(ScreenText.callback) == 'function' then
                                --回调选中项
                                ScreenText.callback(ScreenText.curSelection)
                            end
                        else
                            --不选不行
                            return
                        end
                    end

                    if ScreenText.curpos > #ScreenText.textlist then
                        this:SetFromCode(ScreenText.fromcode)
                        theWorld:PopScreen()
                    else
                        SetNext(this, ScreenText.curpos)
                        --设置颜色
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
                        --ScreenText.switchFlag存在分支则不能返回
                        return
                    end
                    -- 这时候回溯前一句话
                    if ScreenText.curpos > 2 then
                        SetNext(this, ScreenText.curpos - 2)
                        --设置颜色
                        ScreenText.t:SetTextColor(TextColor.FinishRead)
                        ScreenText.curpos = ScreenText.curpos - 1
                    end
                elseif key == flux.GLFW_KEY_ESC then
                    this:SetFromCode(ScreenText.fromcode)
                    theWorld:PopScreen()
                end

                --选择分支
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
    --类型,1为大立绘,2为小头像
    ScreenText.type = 0
    --当前选项分支数量
    ScreenText.switchNum = 1
    --保存图片
    ScreenText.ch_info = ch_info
    --最后一个存在分支的位置
    ScreenText.switchFlag = 0
    --当前是否存在分支选项
    ScreenText.curExistSwitch = false
    --当前选中项
    ScreenText.curSelection = 1
    --阅读位置
    ScreenText.readpos = 2
    ScreenText.fromcode = fromcode
    ScreenText.textlist = textlist
    ScreenText.curpos = 2
    theWorld:PushScreen(ScreenText.scr, flux.SCREEN_APPEND)
end

-- 随机对话函数
-- 传入若干类型为 table 的参数，每个 table 都是一套 ShowText 的参数。
-- 随机选择一套参数进行调用，以实现 NPC 的随机对话功能
function RandomShowText(...)
    local t = { ... }
    local index = math.random(1, #t)
    local select = t[index]
    ShowText(select[1], select[2], select[3], select[4])
end
