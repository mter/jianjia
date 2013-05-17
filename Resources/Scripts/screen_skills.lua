--颜色
local Colors={
    normal=flux.Color(1,1,1),
    selection=flux.Color(1,0,0),
}
--初始化控件
local function InitRes(this)
    --初始化背景
    ScreenSkills.bg = flux.View(this)
    ScreenSkills.bg:SetHUD(true)
    ScreenSkills.bg:SetSize(24, 6)
    ScreenSkills.bg:SetPosition(0, 0):SetAlpha(0.8)
    ScreenSkills.bg:SetSprite('Resources/Images/textbg.png')
    this:AddView(ScreenSkills.bg)

    ScreenSkills.skillsView = {
        flux.TextView(this,nil,'wqy'),
        flux.TextView(this,nil,'wqy'),
        flux.TextView(this,nil,'wqy'),
        flux.TextView(this,nil,'wqy'),
        flux.TextView(this,nil,'wqy'),
    }
    --每页显示五条技能
    for i=1,5 do
        --ScreenSkillsView.skillsView[i] = flux.TextView(this,nil,'wqy'):SetAlpha(0)
        ScreenSkills.skillsView[i]:SetTextColor(Colors.normal):SetPosition(-7,3+-1*i):SetAlign(flux.ALIGN_LEFT):SetAlpha(0):SetHUD(true)--
        this:AddView(ScreenSkills.skillsView[i])
    end
    --技能说明
    ScreenSkills.instruct=flux.TextView(this,nil,'wqy')
    ScreenSkills.instruct:SetTextColor(Colors.normal):SetPosition(4,1):SetAlign(flux.ALIGN_LEFT):SetHUD(true)
    this:AddView(ScreenSkills.instruct)

    --技能选择框
    ScreenSkills.skillsSelection=flux.View(this)
    ScreenSkills.skillsSelection:SetColor(0.7,0,1):SetAlpha(0.3):SetSize(6,1):SetPosition(-4.5,2):SetHUD(true)
    this:AddView(ScreenSkills.skillsSelection)
end
--截取字符串
local function Split(s)
    local ts=''
    while true do
        if string.len(s)>22 then
            ts=ts..(string.sub(s,1,22))..'\n'
            s=string.sub(s,22,string.len(s))
        else
            ts = ts..s
            return ts
        end
    end
end

--显示技能
ScreenSkills={
    --把技能传进来
    new = function(spells,callback)
        ScreenSkills.skills = spells
        ScreenSkills.skillsNums=table.length(spells)
        ScreenSkills.callback=callback
        --初始化
        if ScreenSkills.scr==nil then
            ScreenSkills.scr = flux.Screen()
            ScreenSkills.scr:lua_Init(wrap(function(this)
                InitRes(this)
                -- 注册按键
                this:RegKey(_b'Z')
                this:RegKey(flux.GLFW_KEY_LEFT)
                this:RegKey(flux.GLFW_KEY_ESC)
                this:RegKey(flux.GLFW_KEY_ENTER)
                this:RegKey(flux.GLFW_KEY_SPACE)
                this:RegKey(flux.GLFW_KEY_RIGHT)
                this:RegKey(flux.GLFW_KEY_UP)
                this:RegKey(flux.GLFW_KEY_DOWN)
            end))
            ScreenSkills.scr:lua_OnPush(wrap(function(this)
                theWorld:PhyPause()
                ScreenSkills.update(ScreenSkills.curSelection,0)
            end))
            ScreenSkills.scr:lua_OnPop(wrap(function(this)
                theWorld:PhyContinue()
            end))

            --监听按键事件
            ScreenSkills.scr:lua_KeyInput(wrap(function(this, key, state)
                if state == flux.GLFW_PRESS then
                    if key==flux.GLFW_KEY_UP then
                        --上
                        print("S上选择")
                        if ScreenSkills.curSelection > 1 then
                            print("上选择")
                            ScreenSkills.update(ScreenSkills.curSelection,-1)
                        end
                    elseif key==flux.GLFW_KEY_DOWN then
                        --下
                        if ScreenSkills.curSelection < ScreenSkills.skillsNums then
                            ScreenSkills.update(ScreenSkills.curSelection,1)
                        end
                    elseif key==flux.GLFW_KEY_ENTER then
                        --选择释放技能
                        local tk = table.find(ScreenSkills.skills,ScreenSkills.curSelection)
                        if skill.can_cast(data.ch[1],skills[tk]) then
                            print("释放技能吧骚年")
                            if type(ScreenSkills.callback)=='function' then
                                ScreenSkills.callback(skills[tk])
                            end
                            theWorld:PopScreen()
                        else
                            print("释放条件不足")
                        end
                    elseif key==flux.GLFW_KEY_ESC then
                        theWorld:PopScreen()
                    end
                end
            end))
        end
    end,
    --更新
    update = function(curSelection,step)
        --选择
        local nextSelection = curSelection+step
        if nextSelection >=1 and nextSelection<=ScreenSkills.skillsNums then
            if step==1 then
                --下
                if ScreenSkills.curPosition<5 then
                    ScreenSkills.curPosition=ScreenSkills.curPosition+1
                end
                ScreenSkills.curSelection=nextSelection
            elseif step==-1 then
                --上
                if ScreenSkills.curPosition>1 then
                    ScreenSkills.curPosition=ScreenSkills.curPosition-1
                end
                ScreenSkills.curSelection=nextSelection
            elseif step==0 then
                --纯粹更新
                ScreenSkills.curSelection=nextSelection
            end
        end
        ScreenSkills.skillsSelection:SetAlpha(0.3):SetPosition(-4.5,3-ScreenSkills.curPosition)
        --更新说明信息
        --ScreenSkills.instruct:SetText(ScreenSkills.skills[ScreenSkills.curSelection][6]):SetAlpha(1)
        local k= table.find(ScreenSkills.skills,ScreenSkills.curSelection)
        ScreenSkills.instruct:SetText(skills[k][6]):SetAlpha(1)
        --ScreenSkills.instruct:SetText(Split(ScreenSkills.skills[ScreenSkills.curPosition][5])):SetAlpha(1)
        local m=nil
        if ScreenSkills.curPosition==1 and (step==-1 or step==0) then
            m=-1
        elseif ScreenSkills.curPosition==5 and step==1 then
            m=-5
        end
        print("进入")
        --更新技能列表
        if  m then
            for k, v in pairs(ScreenSkills.skillsView) do
                --技能id,等级
                local tk = table.find(ScreenSkills.skills,k+ScreenSkills.curSelection+m)
                if tk and skills[tk] then
                    if skills[tk][2] then
                        v:SetText(skills[tk][2]):SetAlpha(1)
                    end
                else
                    v:SetAlpha(0)
                end
            end
        end
    end,
    --当前选中项
    curSelection=1,
    --技能数量
    spellsNums=1,
    --当前位置
    curPosition=1,
}