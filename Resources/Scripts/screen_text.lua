--
--
--ShowText的使用方法:
--参数为:(屏幕编号,{"名字","语句",例会编号,立绘位置,声音,{"选择分支1","选择分支2"},回调方法},{"名字",{"选择了分支1","选择了分支2"},立绘编号,位置,声音,{"分支1","分支2"},"没有立绘名字和声音的第三句话"},{"图片一","图片二"})
--ShowText(101, {{"Yu","一二三四五六",2,1,102,{'分支1','分支2'},callback},{"神秘的人",{"分支1的结果","分支2的结果"},1,2,101,{'分支3','分支4'}},{"Yu","b",2,1,101},{"神秘的人","c",1,2,102},{"Yu","d",2,1,102},"一二三四五六七八"},{"Resources/Images/SCA07.png","Resources/Images/hero.png"})
--
--
--设置窗口信息
--名字颜色:0.18,0.62,0.34
--对话内容颜色205 205 180,
--选择颜色0.55,0.55,0.48
--阅读完毕颜色139 139 122
TextColor={
	Name=flux.Color(0.18,0.62,0.34),
	UnfinshRead=flux.Color(0.8,0.8,0.71),
	FinishRead=flux.Color(0.55,0.55,0.48),--139 139 122
	SwitchCase=flux.Color(0.42,0.57,0.14),
	}
function SetNext(this,curpos,ch_info)
	local text = ScreenText.textlist[curpos]
	if type(text) == 'string' then		
		if ScreenText.t==nil then
			ScreenText.t = flux.TextView(this, nil, 'wqy',text):SetAlign(flux.ALIGN_TOPLEFT)
			ScreenText.t:SetHUD(true)
			ScreenText.t:SetColor(TextColor.UnfinshRead)
			this:AddView(ScreenText.t,8)
		end
		ScreenText.t:SetText(text):SetPosition(-11,-4.5)
		
		--如果存在立绘则隐藏
		if ScreenText.portrait then
			ScreenText.portrait:AnimCancel()
			ScreenText.portrait:FadeOut(1,nil,-1):AnimDo()
		end
		--名字存在则隐藏
		if ScreenText.name then
			ScreenText.name:AnimCancel()
			ScreenText.name:FadeOut(1,nil,-1):AnimDo()
		end
	else
		--名字
		if ScreenText.name ==nil then
			ScreenText.name = flux.TextView(this, nil, 'wqy',text[1])
			ScreenText.name:SetHUD(true):SetColor(TextColor.Name):SetAlign(flux.ALIGN_TOPLEFT):SetPosition(-11,-3.4)
			this:AddView(ScreenText.name,5)
		else
			ScreenText.name:AnimCancel()
			ScreenText.name:SetText(text[1]):SetAlpha(1)
		end
		--内容
		local msg
		if type(text[2])=='table' then
			msg=text[2][ScreenText.curSelection]
		elseif type(text[2])=='string' then
			msg=text[2]
		end
		if ScreenText.t==nil then
			ScreenText.t = flux.TextView(this, nil, 'wqy',msg):SetAlign(flux.ALIGN_TOPLEFT)
			ScreenText.t:SetHUD(true)
			ScreenText.t:SetColor(TextColor.UnfinshRead)
			this:AddView(ScreenText.t,8)
		end
		ScreenText.t:SetText(msg):SetPosition(-11,-4.5)
		--设置立绘信息
		if ScreenText.portrait then
			ScreenText.portrait:AnimCancel()
			ScreenText.portrait:SetSprite(ch_info[text[3]]):SetSize(8.8,20.34)--:SetAlpha(1)
		else 
			ScreenText.portrait = flux.View(this):SetSprite(ch_info[text[3]]):SetSize(8.8,20.34)--:SetAlpha(1)
			this:AddView(ScreenText.portrait,-2)
		end
		--立绘位置
		if text[4] == 1then
			ScreenText.portrait:SetPosition(-8,-4)
		elseif text[4] == 2 then
			ScreenText.portrait:SetPosition(8,-4)
		end
		ScreenText.portrait:SetAlpha(1)
		--声音
		if text[5] then
			theSound:PlaySound(text[5])
		end
		
		--选择分支
		if type(text[6])=='table' then
			if ScreenText.switchCase==nil then
				ScreenText.switchCase={}
			else
				--下个对话存在分支,则隐藏上一个的分支
				for i=1,#ScreenText.switchCase do
					if ScreenText.switchCase[i] then
						ScreenText.switchCase[i]:SetAlpha(0)
					end
				end
			end
			--添加分支
			for i=1,#text[6] do
				ScreenText.switchCase[i]=flux.TextView(this,nil,'wqy','>   '..text[6][i]):SetColor(TextColor.SwitchCase):SetPosition(-9,-5+-1*i):SetAlign(flux.ALIGN_LEFT)
				this:AddView(ScreenText.switchCase[i])
			end
			--显示选中条
			if ScreenText.selection==nil then 
				ScreenText.selection=flux.View(this):SetSize(1,1):SetSprite('Resources/Images/hand.png'):SetAlign(flux.ALIGN_LEFT)
				this:AddView(ScreenText.selection)
			end
			ScreenText.selection:SetAlpha(1):SetPosition(-10.3,-5-ScreenText.curSelection)
			--设置存在分支
			ScreenText.curExistSwitch=true
			--callback
			ScreenText.callback = text[7]
			--分支存在的位置
			ScreenText.switchFlag =curpos
		else
			--下一个对话不存在分支,则隐藏当前分支
			if ScreenText.switchCase then
				--隐藏选项条
				if ScreenText.selection then
					ScreenText.selection:SetAlpha(0)
				end
				for i=1,#ScreenText.switchCase do
					ScreenText.switchCase[i]:SetAlpha(0)
				end
			end
			--不存在分支
			ScreenText.curExistSwitch=false
			
		end
	end
end
--窗体序列号,对话内容,立绘,背景图
function ShowText(fromcode,textlist,ch_info,bgpic)
	-- fromcode=100
	-- textlist{{'名字','第一句话', 立绘编号, 立绘位置, 语音,{'分支1','分支2'...},callback}, '第二句话'}
	-- textlist{{'名字','第一句话', 立绘编号, 立绘位置, 语音,{'分支1','分支2'...},callback}, {{'分支1res'},{'分支2res'}...}}
	-- ch_info = {'pic1', 'pic2', ...}
    if scr.ScreenText == nil then
        ScreenText = {}
        scr.ScreenText = flux.Screen()
		scr.ScreenText:lua_Init(wrap(function(this)
            local bg = flux.View(this)
            bg:SetHUD(true)
			bg:SetSize(24, 6)
            bg:SetPosition(0, -6):SetAlpha(0.8)
			--设置背景
			if bgpic then
				bg:SetSprite(bgpic)
			else
				bg:SetSprite('Resources/Images/textbg.png')
			end
            this:AddView(bg)
            -- 注册按键
			this:RegKey(_b'Z')
            this:RegKey(flux.GLFW_KEY_LEFT)
            this:RegKey(flux.GLFW_KEY_ESC)
            this:RegKey(flux.GLFW_KEY_ENTER)
            this:RegKey(flux.GLFW_KEY_SPACE)
            this:RegKey(flux.GLFW_KEY_RIGHT)
			this:RegKey(flux.GLFW_KEY_UP)
			this:RegKey(flux.GLFW_KEY_DOWN)

            -- 保存引用
           ScreenText.bg = bg

			scr.ScreenText:lua_OnPush(wrap(function(this)
				SetNext(this,1,ch_info)
				theWorld:PhyPause()
			end))
			
		end))
		
		--恢复
        scr.ScreenText:lua_OnPop(wrap(function(this)
			theWorld:PhyContinue()
		end))

        scr.ScreenText:lua_KeyInput(wrap(function(this, key, state)
            if state == flux.GLFW_PRESS then
                if key == flux.GLFW_KEY_ENTER or key == flux.GLFW_KEY_SPACE or key == _b'Z' or key == flux.GLFW_KEY_RIGHT then
					--enter选中当前选项
					if ScreenText.curExistSwitch then
						if  key == flux.GLFW_KEY_ENTER then
							--print("选中:"..ScreenText.curSelection)
							--callback
							if type(ScreenText.callback)=='function' then
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
						SetNext(this,ScreenText.curpos,ch_info)
						--设置颜色
						if ScreenText.readpos<=ScreenText.curpos then
							ScreenText.readpos =ScreenText.curpos
							ScreenText.t:SetColor(TextColor.UnfinshRead)
						else
							ScreenText.t:SetColor(TextColor.FinishRead)
						end
						ScreenText.curpos = ScreenText.curpos + 1
					end
				elseif key == flux.GLFW_KEY_LEFT then
					if ScreenText.curpos-2<=ScreenText.switchFlag then
						--ScreenText.switchFlag存在分支则不能返回
						return
					end
					-- 这时候回溯前一句话
					if ScreenText.curpos > 2 then
						SetNext(this,ScreenText.curpos-2,ch_info)
						--设置颜色
						ScreenText.t:SetColor(TextColor.FinishRead)
						ScreenText.curpos = ScreenText.curpos - 1
					end
				elseif key == flux.GLFW_KEY_ESC then
					this:SetFromCode(ScreenText.fromcode)
					theWorld:PopScreen()
                end
				
				--选择分支
				if ScreenText.curExistSwitch then
					if key==flux.GLFW_KEY_UP then
						if ScreenText.curSelection <= 1 then
							ScreenText.curSelection=#ScreenText.switchCase
						else
							ScreenText.curSelection=ScreenText.curSelection-1
						end
						
						ScreenText.selection:SetPosition(-10.3,-5-ScreenText.curSelection)
					elseif key==flux.GLFW_KEY_DOWN then
						if ScreenText.curSelection>=#ScreenText.switchCase then
							ScreenText.curSelection=1
							else
							ScreenText.curSelection=ScreenText.curSelection+1
						end
						ScreenText.selection:SetPosition(-10.3,-5-ScreenText.curSelection)
					end
				end
            end
        end))

    end
	
	--最后一个存在分支的位置
	ScreenText.switchFlag=0
	--当前是否存在分支选项
	ScreenText.curExistSwitch=false
	--当前选中项
	ScreenText.curSelection=1
	--阅读位置
	ScreenText.readpos = 2
	ScreenText.fromcode = fromcode
	ScreenText.textlist = textlist
	ScreenText.curpos = 2
    theWorld:PushScreen(scr['ScreenText'], flux.SCREEN_APPEND)
end
