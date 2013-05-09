

ScreenGame = {

    new = function()
        if ScreenGame.scr then return end

		-- 基础设定
        ScreenGame.scr = flux.RMScreen()

		-- OnPush 事件
        ScreenGame.scr:lua_OnPush(wrap(function(this)
			theCamera:SetFocus(ScreenGame.player)
			ScreenGame.scr:SetPlayer(ScreenGame.player)
			ScreenGame.player:SetPosition(data.player.x, data.player.y)
        end))

		-- AfterPush 事件
        ScreenGame.scr:lua_AfterPush(wrap(function(this)
			if not data.ch then
				data.ch = {
					yf = character.new('伊方')
				}
				ShowText(101, {'选择阵营'})
			end
		end))

        ScreenGame.scr:lua_OnResume(wrap(function(this, from, ret)
			if from == 0 then
				ScreenGame.player:Reset()
			elseif from == 101 then
				ScreenAlignmentChoose.new()
				theWorld:PushScreen(ScreenAlignmentChoose.scr, flux.SCREEN_APPEND)
			elseif from == 1001 then
				data.player.alignment = ret
			end
		end))

		-- 按键响应
        ScreenGame.scr:lua_KeyInput(wrap(function(this, key, state)
		    if state == flux.GLFW_PRESS then
                if key == flux.GLFW_KEY_ESC then
                    -- MsgBox(101, "是否想要回到标题页面？")
				elseif key == _b'Z' then
					if ScreenGame.player:CheckFacing(ScreenGame.v1, 0.5) then
						print('进入战斗!')
						ShowText(0, {{"紧握小黄书的男人","旅行者，有什么想说的么？",2,1,102,{'我们缺少原画！！','原画大神求带！！！'},callback},{"神秘的人",{"分支1的结果","分支2的结果"},1,2,101,{'分支3','分支4'}},{"Yu","b",2,1,101,{"ffdsaf1","fdafdsa2"}},{"神秘的人","c",1,2,102},{"Yu","d",2,1,102},"一二三四五六七八"},{"Resources/Images/SCA07.png","Resources/Images/hero.png"})
					elseif ScreenGame.player:CheckFacing(ScreenGame.head) then
						RandomShowText({{0, {{'村长', '敲碗，无聊，敲碗，无聊，敲碗，无聊……'}}},  {0, {{'村长', '多少年来方圆百里的妇联主席都是我呀~'}}}, {0, {{'村长', '其实我只有一百一十八岁的，啊不，或者是十八岁比较年轻一点？'}}}})
					end
                end
            end
        end))	
	
		-- 初始化控件事件
        ScreenGame.scr:lua_Init(wrap(function(this)
            -- 生成控件
            ScreenGame.player = flux.RMCharacter(this)
			ScreenGame.player:SetColor(1,0,0)
			ScreenGame.player:SetPhy()

            ScreenGame.t1 = flux.TextView(this, nil, 'wqy', '陛下')
			ScreenGame.t1:SetPosition(5, 12.5)
            ScreenGame.v1 = flux.View(this)
			ScreenGame.v1:SetSprite('Resources/Images/fight.jpg'):SetSize(1.3,1.5):SetPosition(3,14):SetPhy(flux.b2_staticBody):PhyNewFixture(101)

			this:AddView(ScreenGame.player)
			this:AddView(ScreenGame.v1, 0)
			this:AddView(ScreenGame.t1, 0)
			
			ScreenGame.grass = flux.View(this):SetSize(500, 500):SetSprite('Resources/Images/grass.jpg'):SetPaintMode(flux.PAINT_MODE_TILE)
			this:AddView(ScreenGame.grass, -1)

			ScreenGame.school = flux.TextView(this, nil, 'wqyL', '学校'):SetTextColor(1,1,1)
			ScreenGame.school:SetColor(0,0,1):SetSize(25, 12):SetPosition(0, 40)
			this:AddView(ScreenGame.school)

			ScreenGame.alchemy = flux.TextView(this, nil, 'wqyL', '炼金工坊'):SetTextColor(1,1,1)
			ScreenGame.alchemy:SetColor(1,1,0):SetSize(5.375, 8.16):SetPosition(10, 10):SetSprite('Resources/Images/21.png')
			this:AddView(ScreenGame.alchemy)

			ScreenGame.pet = flux.TextView(this, nil, 'wqyL', '宠物医院'):SetTextColor(1,1,1)
			ScreenGame.pet:SetSize(5.375, 8.16):SetPosition(10, 20):SetSprite('Resources/Images/27.png')
			this:AddView(ScreenGame.pet)
			
			ScreenGame.smithy = flux.TextView(this, nil, 'wqyL', '铁匠铺'):SetTextColor(1,1,1)
			ScreenGame.smithy:SetColor(0.77, 0.77, 0.77):SetSize(5.375, 8.16):SetPosition(-10, 14):SetSprite('Resources/Images/5.png')
			this:AddView(ScreenGame.smithy)

			ScreenGame.fair = flux.TextView(this, nil, 'wqyL', '集市'):SetTextColor(1,1,1)
			ScreenGame.fair:SetColor(0, 0.75, 0):SetSize(20, 20):SetPosition(0, -13)
			this:AddView(ScreenGame.fair)

			ScreenGame.headhome = flux.TextView(this, nil, 'wqyL', '村长家'):SetTextColor(1,1,1)
			ScreenGame.headhome:SetColor(0.75, 0, 0):SetSize(8, 5):SetPosition(-20, -13)
			this:AddView(ScreenGame.headhome)

			ScreenGame.hotel = flux.TextView(this, nil, 'wqyL', '旅店'):SetTextColor(1,1,1)
			ScreenGame.hotel:SetColor(0.75, 0, 0):SetSize(8, 5):SetPosition(-34, -13)
			this:AddView(ScreenGame.hotel)
			
			ScreenGame.bar = flux.TextView(this, nil, 'wqyL', '酒吧'):SetTextColor(1,1,1)
			ScreenGame.bar:SetColor(0.75, 0, 0):SetSize(8, 5):SetPosition(-49, -13)
			this:AddView(ScreenGame.bar)
			
			ScreenGame.uptown1 = flux.TextView(this, nil, 'wqyL', '居民区1'):SetTextColor(1,1,1)
			ScreenGame.uptown1:SetColor(0, 0.35, 0.55):SetSize(30, 15):SetPosition(30, -29)
			this:AddView(ScreenGame.uptown1)
			
			ScreenGame.church = flux.TextView(this, nil, 'wqyL', '教堂'):SetTextColor(1,1,1)
			ScreenGame.church:SetColor(0.44, 0.35, 0.55):SetPosition(-30, 27):SetSize(13, 23)
			this:AddView(ScreenGame.church)
			
			ScreenGame.uptown2 = flux.TextView(this, nil, 'wqyL', '居民区2'):SetTextColor(1,1,1)
			ScreenGame.uptown2:SetColor(0, 0.35, 0.55):SetSize(15, 33):SetPosition(30, 29)
			this:AddView(ScreenGame.uptown2)
			
			ScreenGame.wharf = flux.TextView(this, nil, 'wqyL', '码头'):SetTextColor(1,1,1)
			ScreenGame.wharf:SetColor(0.45, 0.25, 0.55):SetPosition(27, 68):SetSize(15, 33)
			this:AddView(ScreenGame.wharf)

			ScreenGame.head = flux.TextView(this, nil, 'wqy', '村长'):SetTextColor(1,1,1)
			ScreenGame.head:SetSize(1,1):SetColor(0,0,0):SetPosition(-20, -8):SetPhy(flux.b2_staticBody):PhyNewFixture()
			this:AddView(ScreenGame.head)

            -- 注册按键
            this:RegKey(_b'Z')
            this:RegKey(flux.GLFW_KEY_ESC)
            this:RegKey(flux.GLFW_KEY_SPACE)
            this:RegKey(flux.GLFW_KEY_LEFT)
            this:RegKey(flux.GLFW_KEY_RIGHT)
            this:RegKey(flux.GLFW_KEY_UP)
            this:RegKey(flux.GLFW_KEY_DOWN)

        end))

    end,
}
