

ScreenAlignmentChoose = {

    new = function()
        if ScreenAlignmentChoose.scr then return end

        -- 基础设定
        ScreenAlignmentChoose.scr = flux.Screen()
        
        -- OnPush 事件
        ScreenAlignmentChoose.scr:lua_OnPush(wrap(function(this)
            ScreenAlignmentChoose.splash:FadeOut(0.5):AnimDo()
        end))

        -- 按键响应
        ScreenAlignmentChoose.scr:lua_KeyInput(wrap(function(this, key, state)
            if state == flux.GLFW_PRESS then
                local cursel = ScreenAlignmentChoose.cursel
                if key == flux.GLFW_KEY_RIGHT then
                    if cursel == 5 then return end
                    ScreenAlignmentChoose.Items[cursel]:AnimCancel()
                    ScreenAlignmentChoose.Items[cursel+1]:AnimCancel()
                    ScreenAlignmentChoose.Items[cursel]:ResizeTo(0.5, ScreenAlignmentChoose.normalSize):AnimDo()
                    ScreenAlignmentChoose.Items[cursel+1]:ResizeTo(0.8, ScreenAlignmentChoose.bigSize):AnimDo()
                    ScreenAlignmentChoose.text:SetText(ScreenAlignmentChoose.ItemText[cursel+1])
                    ScreenAlignmentChoose.text2:SetText(ScreenAlignmentChoose.ItemText2[cursel+1])
                    ScreenAlignmentChoose.cursel = cursel + 1                    
                elseif key == flux.GLFW_KEY_LEFT then
                    if cursel == 1 then return end
                    ScreenAlignmentChoose.Items[cursel]:AnimCancel()
                    ScreenAlignmentChoose.Items[cursel-1]:AnimCancel()
                    ScreenAlignmentChoose.Items[cursel]:ResizeTo(0.5, ScreenAlignmentChoose.normalSize):AnimDo()
                    ScreenAlignmentChoose.Items[cursel-1]:ResizeTo(0.8, ScreenAlignmentChoose.bigSize):AnimDo()
                    ScreenAlignmentChoose.text:SetText(ScreenAlignmentChoose.ItemText[cursel-1])
                    ScreenAlignmentChoose.text2:SetText(ScreenAlignmentChoose.ItemText2[cursel-1])
                    ScreenAlignmentChoose.cursel = cursel - 1
                elseif key == flux.GLFW_KEY_SPACE or key == flux.GLFW_KEY_ENTER or key == _b'Z' then
                    this:SetFromCode(1001)
                    this:SetRetCode(cursel)
                    theWorld:PopScreen()
                end
            end
        end))

        -- 初始化控件事件
        ScreenAlignmentChoose.scr:lua_Init(wrap(function(this)
            -- 生成控件
            ScreenAlignmentChoose.bg = flux.View(this)
            ScreenAlignmentChoose.bg:SetHUD(true):SetSize(32, 24)

            ScreenAlignmentChoose.splash = flux.View(this)
            ScreenAlignmentChoose.splash:SetSize(32, 24):SetColor(0,0,0):SetHUD(true)
                        
            ScreenAlignmentChoose.normalSize = flux.Vector2(3, 4)
            ScreenAlignmentChoose.bigSize = flux.Vector2(5, 6.67)
            
            ScreenAlignmentChoose.cursel = 3

            ScreenAlignmentChoose.ItemText = {
                '守序善良',
                '善良',
                '无阵营(中立)',
                '邪恶',
                '混乱邪恶'
            }
            
            ScreenAlignmentChoose.ItemText2 = {
                '道德观：文明与秩序。\n       该阵营的角色会尊重权威，比如品德准则、法律和领导者，并且相信这些准则是达成理想的最好途径。当权者鼓励臣民们趋善，防止他们互相伤害。守序善良的角色与善良的角色同样看重生命的价值，甚至于更加关注保护弱者和扶助受压迫的人。守序善良的典范是杰出的斗士，他们坚持正义、荣誉和真理，为了阻止邪恶在这世上蔓延可以毫不犹豫地献出生命。\n       当掌权者开始用他们的权力牟取私利，当法律变成维护一部分人的特权的工具而将他人变成受奴役的阶级时，法律也就变成了邪恶，权力异化为暴政。该阵营的角色不仅敢于反抗这样的不公正，也在道德上强烈抵制。不过，该阵营的角色还是会尽量在体制范围内纠正这些问题，而不愿采取更激烈的和不合法的方式。',
                '道德观：自由与慈爱。\n       该阵营的角色坚信帮助并保护危境中的弱者是正确的。他可能被要求把他人的利益放在自己的利益之上，有时这就意味着对自身造成损害。\n       善良之人与邪恶之人在最基本的观念上相互冲突，他们之间激烈对抗，无法和平共处。善良之人与守序善良的角色相处得还不错——尽管善良的角色觉得守序善良的队友可能有点太死板，太遵守规矩，而不是径直去做应该做的事。',
                '道德观：没有阵营，没有倾向。\n       该阵营的角色不会积极地伤害他人，但是没有好处的情况下也不会冒什么风险。他支持法律和秩序，因为他能从中受益。他重视自己的自由，却不会过多地保护他人的自由。',
                '道德观：暴虐与仇恨。\n       该阵营的角色不一定非要伤害别人，但是他们很愿意掌握他人的弱点并借此得到他们想要的东西。\n       该阵营的角色合理地利用规则和法令来让个人所得最大化。他们不关心这些法律是否会伤害到他人。他们支持那些给予他们权力的社会结构，即使权力建立在奴役其他人的基础上。邪恶之人不仅赞同，而且向往奴隶制和森严的等级制度，只要他们还处在受益的位置上。',
                '道德观：无序与毁灭。\n       该阵营的角色完全不顾及其他人。他们认为自己才是唯一重要的，他们杀戮、盗窃、出卖别人，以求获取力量。他们惯于食言，他们的行为带来毁灭。他们的世界观极其扭曲，会毁掉所有跟他们的兴趣没有直接关系的人和东西。\n       在守序善良的人看来，混乱邪恶跟邪恶一样可恶，甚至更加遭人憎恨。混乱邪恶的怪物，比如恶魔和兽人，威胁到文明和安定的程度比起邪恶的怪物有过之而无不及。邪恶和混乱邪恶的生物都是善良之人的死敌，但是他们互相之间并没有多少敬意，很少会为共同目标而合作。'
            }

            ScreenAlignmentChoose.text = flux.TextView(this, nil, 'wqy', ScreenAlignmentChoose.ItemText[3])
            ScreenAlignmentChoose.text:SetPosition(0, -1):SetColor(0, 0, 1):SetHUD(true)
            -- ScreenAlignmentChoose.text:SetAlign(flux.ALIGN_LEFT)

            ScreenAlignmentChoose.text2 = flux.TextView(this, nil, 'wqy')
            ScreenAlignmentChoose.text2:SetPosition(-11, -2):SetHUD(true)
            ScreenAlignmentChoose.text2:SetAlign(flux.ALIGN_TOPLEFT):SetTextAreaWidth(800):SetText(ScreenAlignmentChoose.ItemText2[3])

            ScreenAlignmentChoose.ItemPos = {
                flux.Vector2(-10, 4),
                flux.Vector2(-5, 4),
                flux.Vector2( 0, 4),
                flux.Vector2( 5, 4),
                flux.Vector2( 10, 4),
            }

            ScreenAlignmentChoose.Items = {
                flux.View(this),
                flux.View(this),
                flux.View(this),
                flux.View(this),
                flux.View(this),
            }
            
            for k,v in pairs(ScreenAlignmentChoose.Items) do
                v:SetSize(ScreenAlignmentChoose.normalSize):SetSprite('Resources/Images/alignment' .. k .. '.jpg')
                v:SetPosition(ScreenAlignmentChoose.ItemPos[k]):SetHUD(true)
                this:AddView(v)
            end
            
            ScreenAlignmentChoose.Items[3]:SetSize(ScreenAlignmentChoose.bigSize)

            -- 注册按键
            this:RegKey(_b'Z')
            this:RegKey(flux.GLFW_KEY_ESC)
            this:RegKey(flux.GLFW_KEY_SPACE)
            this:RegKey(flux.GLFW_KEY_LEFT)
            this:RegKey(flux.GLFW_KEY_RIGHT)
            this:RegKey(flux.GLFW_KEY_UP)
            this:RegKey(flux.GLFW_KEY_DOWN)

            this:AddView(ScreenAlignmentChoose.bg, -1)
            this:AddView(ScreenAlignmentChoose.splash)
            this:AddView(ScreenAlignmentChoose.text)
            this:AddView(ScreenAlignmentChoose.text2)
        end))

    end,
    
    free = function()
        ScreenAlignmentChoose = nil
    end,
}
