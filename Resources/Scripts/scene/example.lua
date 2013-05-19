
-- example.lua
-- 示例场景文件, fy
-- 一个场景需要构造以下函数：
-- OnInit 负责初始化控件，只会在这个场景不在内存中时被调用。
-- OnLoad 负责做初始设定，例如加载地图。这张场景每次被Load的时候都会调用 OnLoad。OnInit和OnLoad的关系就如同Screen的OnInit和OnPush。
-- KeyInput 按键响应
-- PhyContactBegin 物理碰撞开始，a和b存放着两个物体的数据
-- PhyContactEnd 物理碰撞结束，a和b存放着两个物体的数据

local function OnInit(self, scr)
    
end

local function OnLoad(self, scr)

end

local function KeyInput(self, scr, key, state)
    
end

local function PhyContactBegin(self, scr, a, b)
    
end

local function PhyContactEnd(self, scr, a, b)
    
end

SceneManager.scene.example = Scene('example', OnInit, OnLoad, KeyInput, PhyContactBegin, PhyContactEnd)
