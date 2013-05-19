
enemy_prefix = {
    -- 名字,  挑战等级增加, 经验百分比, hp百分比, mp百分比, 伤害百分比, 防御百分比, 护甲百分比, 抗性百分比, 技能列表增加
    {'坚韧',             1,       1.2,       1.5,        1,          1,        1.3,        1.3,        1.3,           {}}, -- 1
}

enemy_template = {
    -- 名字,  挑战等级增加,   经验百分比,   hp百分比,  mp百分比,   伤害百分比,   防御百分比,  护甲百分比,    抗性百分比,    技能列表增加
    {'普通',           0,          1,        1,        1,          1,         1,           1,          1,          {}}, -- 1
    {'精英',           1,       1.25,     1.25,     1.25,       1.15,      1.10,        1.10,       1.10,          {}}, -- 2
    {'英雄',           2,       1.50,     1.35,     1.35,       1.30,      1.20,        1.20,       1.20,          {}}, -- 3
    {'首领',           3,       1.75,     1.45,     1.45,       1.45,      1.30,        1.30,       1.30,          {}}, -- 4
    {'特殊',           3,       4.15,        1,        1,          1,         1,           1,          1,          {}}, -- 5
}

templ_set = {
    newbie = {{0.85, 0.15}, {enemy_template[1], enemy_template[2]}},
}

loot_lst = {
    newbie = {{1}, {4}},
}

-- 攻击类型：1近战，2远程，3魔法

enemys = {
    --1名字,	  2挑战等级,   3HP,   4MP,    5攻击类型,6最小伤害,7最大伤害,    8防御, 9抗性,  10护甲,    11前缀集合,  12       模板集合,        13掉落列表,         14最大掉落数,    15技能列表,   4说明
    {'碧油鸡',	    1,    10,    0,         1,         2,       4,      12,    10,     8,          {},   templ_set.newbie,      loot_lst.newbie,           1,          {}, '一只绿油油的鸡，总在隐蔽的地方出现。但有时也在大庭广众之下游荡'}, -- 1
    {'迷路的鹌鹑',	1,    10,    0,         1,         2,       4,      12,    10,     8,          {},   templ_set.newbie,      loot_lst.newbie,           1,          {}, '一只惊慌失措的鹌鹑……鹌鹑你晓得吧？新手也可以轻松虐之'}, -- 2
    {'饥饿的野狗',    3,    20,    0,         1,         4,       8,      14,    10,     8,          {},   templ_set.newbie,      loot_lst.newbie,           1,          {}, '一条干瘦的狗，平时徘徊在垃圾堆附近寻找食物。小心别被咬到了，谁知道它有什么病。'}, -- 3
    {'虎斑猫',		2,    15,    0,         1,         3,       6,      13,    10,     8,          {},   templ_set.newbie,      loot_lst.newbie,           1,          {}, '一只漂亮的虎斑猫，动作优雅敏捷，但再敏捷也不过是只猫。'}, -- 4
    {'巨大的瓢虫',    2,    5,     0,         2,         3,       6,      10,     4,    12,          {},   templ_set.newbie,      loot_lst.newbie,           1,          {}, '一只硕大的瓢虫，外壳闪闪发光，很坚硬的样子。巨大的口器摩擦出刺耳的声音'}, -- 5
    {'魔法果冻',	    1,    10,    225,       3,          2,       4,       6,    10,     8,         {},   templ_set.newbie,      loot_lst.newbie,           1,          {}, '一颗会走路的果冻，半透明的身体里流动着魔法的蓝光，常见的魔法生物。'}, -- 6
}

-- 怪物集合
enemy_set = {
    -- 会出现在新手村的怪物
    newbie = {1,2,3,4,5,6},
}

-- 敌人
-- 这个方法应在随机生成敌人id之后被调用，同时在之后通过这个类取得敌人相关的参数。
Enemy = Class(function(self, data)
    self.data = data
    self.hp = data[3]
    self.mp = data[4]
    self.fight_attr = {change={}, scale={}}
    
    -- 计算怪物模板
    
    -- 计算词缀
    
end)

-- 返回经验和掉落
function Enemy:Killed()
    return self:GetExp(), self:GetLoot()
end

-- 获取杀死这个怪物能够得到的经验值数量
function Enemy:GetExp()
    local level = self:GetAttr('level')
    return math.ceil(50*level*(1+level/30)^(1+level/2))
end

-- 根据LOOT列表随机生成掉落
-- @param num 随机次数，默认为怪物所默认的值，假设怪物的掉率加起来是100%，那么就会掉落num件物品
function Enemy:GetLoot(num)
    local num = num or self.data[14]
    local ret = {}
    for i=1,num do
        table.insert(ret, table.random(self.data[13][1], self.data[13][2]))
    end
    return ret
end

-- 数据减少
function Enemy:Dec(key, num)
    if key == 'hp' then
        return self:Inc(key, 0-num)
    elseif key == 'mp' then
        return self:Inc(key, 0-num)
    end
end

-- 数据增加
function Enemy:Inc(key, num)
    if key == 'hp' then
        local hp_max = self:GetAttr('hp_max')
        self.hp = self.hp + num
        if self.hp > hp_max then
            self.hp = hp_max
        end
        if self.hp < 0 then
            self.hp = 0
        end
        return self.hp
    elseif key == 'mp' then
        local mp_max = self:GetAttr('mp_max')
        self.mp = self.mp + num
        if self.mp > mp_max then
            self.mp = mp_max
        end
        if self.mp < 0 then
            self.mp = 0
        end
        return self.mp
    end
end

-- 怪物攻击玩家
-- 与玩家不同，way可以置空，这样会去自动查询怪物数据决定攻击的伤害形式
function Enemy:Attack(ch, way)
    -- way 1 物理
    -- way 2 远程
    -- way 3 魔法
    local way = way or self:GetAttr('atkway')
    local amr, atk_min, atk_max
    local def = self:GetAttr('defense')

    if way == 1 then
        amr = ch:GetAttr('armor')
        atk_min, atk_max = self:GetAttr('atk_min'), self:GetAttr('atk_max')
    elseif way == 2 then
        amr = ch:GetAttr('armor')
        atk_min, atk_max = self:GetAttr('atk_range_min'), self:GetAttr('atk_range_max')
    elseif way == 3 then
        amr = ch:GetAttr('resist')
        atk_min, atk_max = self:GetAttr('atk_magic_min'), self:GetAttr('atk_magic_max')
    end

    return math.ceil((math.random(atk_min, atk_max) + math.floor(atk_max - atk_min) - amr/5) * (1-def ^ 0.5 / 35))
end

-- 获取怪物的某个属性
-- 说明：这个函数会得到玩家经过buff和nerf以后的属性
function Enemy:GetAttr(key)

    local value

    if self[key] then
        value = self[key]
    elseif key == 'hp_max' then
        value = self.data[3]
    elseif key == 'mp_max' then
        value = self.data[4]
    else
        local hashmap = {
            name    = 1,
            level   = 2,
            atkway  = 5,
            armor   = 8,
            resist  = 9,
            defense =10,
        }
        if self.data[5] == 1 then
            hashmap.atk_min = 6
            hashmap.atk_max = 7
        elseif self.data[5] == 2 then
            hashmap.atk_range_min = 6
            hashmap.atk_range_max = 7
        elseif self.data[5] == 3 then
            hashmap.atk_magic_min = 6
            hashmap.atk_magic_max = 7
        end

        local index = hashmap[key]
        if not index then
            return 0
        end
        value = self.data[index]
    end

    if type(value) == 'number' then

        if self.fight_attr.change[key] then
            value = value + self.fight_attr.change[key]
        end

        local scale = 1
        if self.fight_attr.scale[key] then
            scale = scale + self.fight_attr.scale[key]
        end

        return value * scale

    else
        return value
    end

end
