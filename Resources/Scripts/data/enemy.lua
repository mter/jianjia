
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

-- 攻击类型：1近战，2远程，3魔法

enemys = {
    --1名字,	  2挑战等级,   3HP,   4MP,    5攻击类型,6最小伤害,7最大伤害,    8防御, 9抗性,  10护甲,    11前缀集合,  12       模板集合,             13技能列表,   4说明
    {'碧油鸡',	    1,    10,    0,         1,         2,       4,      12,    10,     8,          {},   templ_set.newbie,         {}, '一只绿油油的鸡，总在隐蔽的地方出现。但有时也在大庭广众之下游荡'}, -- 1
    {'迷路的鹌鹑',	1,    10,    0,         1,         2,       4,      12,    10,     8,          {},   templ_set.newbie,         {}, '一只惊慌失措的鹌鹑……鹌鹑你晓得吧？新手也可以轻松虐之'}, -- 2
    {'饥饿的野狗',    3,    20,    0,         1,         4,       8,      14,    10,     8,          {},   templ_set.newbie,         {}, '一条干瘦的狗，平时徘徊在垃圾堆附近寻找食物。小心别被咬到了，谁知道它有什么病。'}, -- 3
    {'虎斑猫',		2,    15,    0,         1,         3,       6,      13,    10,     8,          {},   templ_set.newbie,         {}, '一只漂亮的虎斑猫，动作优雅敏捷，但再敏捷也不过是只猫。'}, -- 4
    {'巨大的瓢虫',    2,    5,     0,         2,         3,       6,      10,     4,    12,          {},   templ_set.newbie,         {}, '一只硕大的瓢虫，外壳闪闪发光，很坚硬的样子。巨大的口器摩擦出刺耳的声音'}, -- 5
    {'魔法果冻',	    1,    10,    225,       3,          2,       4,       6,    10,     8,         {},   templ_set.newbie,         {}, '一颗会走路的果冻，半透明的身体里流动着魔法的蓝光，常见的魔法生物。'}, -- 6
}

-- 怪物集合
enemy_set = {
    -- 会出现在新手村的怪物
    newbie = {1,2,3,4,5,6},
}

Enemy = Class()

-- 内部方法：根据id获取敌人数据，若传入的本身就是敌人的数据，则原样返回。
--         这么做的原因是有时需要传id查数据，有时会直接传数据
function Enemy:_getitem(id_or_table)
    local _type = type(id_or_table)
    if _type == 'table' then
        return id_or_table
    elseif _type == 'number' then
        return enemys[id_or_table]
    end
end

-- 获得怪物的一个副本
-- 这个方法应在随机生成敌人之后被调用，因为不应该去直接修改 enemys[x] 的值，
-- 所以要将其复制后进行使用。
function Enemy:Dup(enm)
    local enm = self:_getitem(enm)
    local t = table.copy(enm)
    t.fight_attr = {change={}, scale={}}
    return t
end

-- 获取怪物的某个属性
-- 说明：这个函数会得到玩家经过buff和debuff以后的属性
function Enemy:GetAttr(enm, key)

    local hashmap = {
        name    = 1,
        level   = 2,
        hp      = 3,
        mp      = 4,
        atkway  = 5,
        armor   = 8,
        resist  = 9,
        defense =10,
    }
    if enm[5] == 1 then
        hashmap.atk_min = 6
        hashmap.atk_max = 7
    elseif enm[5] == 2 then
        hashmap.atk_range_min = 6
        hashmap.atk_range_max = 7
    elseif enm[5] == 3 then
        hashmap.atk_magic_min = 6
        hashmap.atk_magic_max = 7
    end

    local index = hashmap[key]
    if not index then
        return 0
    end
    
    local value = enm[index]

    if not enm.fight_attr then
        -- 这时返回其实是不太正常的，因为传入的并非 Enemy:Dup 复制后的对象
        return value
    end

    if enm.fight_attr.change[key] then
        value = value + enm.fight_attr.change[key]
    end
    
    return value
end

-- 获取怪物的经验值
function Enemy:Exp(enm)
    local enm = self:_getitem(enm)
    local level = self:GetAttr(enm, 'level')
    return math.ceil(50*level*(1+level/30)^(1+level/2))
end

-- 怪物攻击玩家
function Enemy:Attack(enm, ch, way)
    -- way 1 物理
    -- way 2 远程
    -- way 3 魔法
    local enm = self:_getitem(enm)
    local way = way or self:GetAttr(enm, 'atkway')
    local amr, atk_min, atk_max
    local def = self:GetAttr(enm, 'defense')

    if way == 1 then
        amr = Character:GetAttr(ch, 'armor')
        atk_min, atk_max = self:GetAttr(enm, 'atk_min'), self:GetAttr(enm, 'atk_max')
    elseif way == 2 then
        amr = Character:GetAttr(ch, 'armor')
        atk_min, atk_max = self:GetAttr(enm, 'atk_range_min'), self:GetAttr(enm, 'atk_range_max')
    elseif way == 3 then
        amr = Character:GetAttr(ch, 'resist')
        atk_min, atk_max = self:GetAttr(enm, 'atk_magic_min'), self:GetAttr(enm, 'atk_magic_max')
    end

    return math.ceil((math.random(atk_min, atk_max) + math.floor(atk_max - atk_min) - amr/5) * (1-def ^ 0.5 / 35))
end
