
require('scene.scene')

Fifo = Class(function(self)
    -- 构造器
	self.fifo_list = {}
end)

local scenes_fifo = Fifo()

SceneManager = Class()
SceneManager.scene = {}
SceneManager.now = nil

function SceneManager:Init()
    SceneManager.scr = ScreenGame.scr
    SceneManager.player = ScreenGame.player
    SceneManager.map = ScreenGame.map
    
    SceneManager.bg = flux.View(self.scr)
    SceneManager.bg:SetHUD(true):SetSize(100, 100):SetColor(0, 0, 0)

    SceneManager.splash = flux.View(self.scr)
    SceneManager.splash:SetHUD(true):SetSize(100, 100):SetColor(0, 0, 0, 0)
end

-- 获取场景实例
function SceneManager:Get(scene)
    return SceneManager.scene[scene]
end

-- 获取场景名字
function SceneManager:GetSceneName()
    if self.now then
        return self.now.name
    end
end

-- 加载一个新场景
function SceneManager:Load(scene, x, y)
    theWorld:DelayRun(wrap(function()
        self:Unload()
        self.splash:SetAlpha(1):AnimCancel()
        self.splash:Sleep(0.5):FadeOut(0.5):AnimDo()
        local find_index = scenes_fifo:find (scene)
        if find_index > 1 then
            scenes_fifo:set_priority ( find_index)
        else
            local pop_scene = scenes_fifo:push (scene)
            if not table.empty(pop_scene) then            
                print ("unload scene" , pop_scene )
    --			这里调unload函数
    --			pop_scenes.unload()
            end
            require('scene.' .. scene)
        end
        if x and y then
            self.player:SetPosition(x, y)
        end
        self.scene[scene]:AddToScreen(self.scr)
        self.now = self.scene[scene]
        self.now.name = scene
    end))
end

-- 离开当前场景
function SceneManager:Unload()
    self.scr:RemoveAllView()
    self.scr:AddView(self.map)
    self.scr:AddView(self.player)
    self.scr:AddView(self.bg, -1)
    self.scr:AddView(self.splash, 99)
    self.now = nil
end

-- 释放一个场景的资源
function SceneManager:FreeScene(scene)

end

-- 按键响应
function SceneManager:KeyInput(scr, key, state)
    if self.now then
        self.now:KeyInput(scr, key, state)
    end
end

-- 碰撞开始
function SceneManager:PhyContactBegin(scr, a, b)
    if self.now then
        self.now:PhyContactBegin(scr, a, b)
    end
end

-- 碰撞结束
function SceneManager:PhyContactEnd(scr, a, b)
    if self.now then
        self.now:PhyContactEnd(scr, a, b)
    end
end

--我们定义fifo深度为10

function Fifo:push(scene)
	if #self.fifo_list == 10 then
		local unload_scene = self.fifo_list[10]
		for j = 10, 2, -1 do
			self.fifo_list[j] = self.fifo_list[j - 1]
		end
		self.fifo_list[1] = scene

		return unload_scene
	else
		for j = #self.fifo_list + 1, 2, -1 do
			self.fifo_list[j] = self.fifo_list[j - 1]
		end
		self.fifo_list[1] = scene
	end
	return {}
end


function Fifo:pop(param)

end

function Fifo:set_priority(find_index)
	tmp = self.fifo_list[find_index]
	for j = find_index, 2, -1 do
		self.fifo_list[j] = self.fifo_list[j - 1]
	end
	self.fifo_list[1] = tmp
end

function Fifo:find(scene)
	for i = 1, 10, 1 do
        if self.fifo_list[i] == scene then
            return i
        end
    end
	return 0
end

--print (scene_find (t,6))
