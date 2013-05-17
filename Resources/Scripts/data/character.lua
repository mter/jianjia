
character = {}
function character.new(name, txt)
    local txt = txt or ''
    return {
		name = name,
        txt = txt,
		exp_max = 1,
		exp = 0,
		level = 1,

		-- 血蓝
		hp_max = 0,
		mp_max = 0,
		hp = 0,
		mp = 0,

		-- 三伤：近战，远程，法术
		atk_min = 0,
		atk_max = 0,
		atk_range_min = 0,
		atk_range_max = 0,
		atk_magic_min = 0,
		atk_magic_max = 0,

		-- 四抗：护甲（直接减少伤害）、法术抗性、防御（影响伤害减免）
		armor = 0,
		resist = 0,
		defense = 0,

		-- 四系数：平衡，暴击伤害倍数，释放成功系数，暴击率
		balance = 5,
		crit_dmg = 0,
		cast = 0,
		cast_success_rate = 0,
		crit_rate = 0,

		-- 六边
		strength = 5,
		agility = 5,
		intelligence = 5,
		spellpower = 5,
		endurance = 5,
		will = 5,

        -- 法术、装备列表
        skills = {},
        equip = {},

        -- 装备属性加成和战斗属性加成
        equip_attr = {change={}, scale={}},
        fight_attr = {change={}, scale={}},
    }
end

Character = Class()

-- 装备物品
-- 说明：内部方法，请勿从外面调用
function Character:_Equip(ch, item_id)
    local i = items[item_id]
    for k,v in pairs(i.equip.change) do
        if not ch.equip_attr.change[k] then
            ch.equip_attr.change[k] = 0
        end
        ch.equip_attr.change[k] = ch.equip_attr.change[k] + v
    end
    for k,v in pairs(i.equip.scale) do
        if not ch.equip_attr.scale[k] then
            ch.equip_attr.scale[k] = 0
        end
        ch.equip_attr.scale[k] = ch.scale.change[k] + v
    end
    ch.equip[i.equip.pos] = item_id
end

-- 装备某样物品
-- 说明:装备部位 1头部、2衣服、3手套、4腰带、5鞋子、6饰品
--      item_id 是装备id
function Character:Equip(ch, item_id)
    local i = items[item_id]
    local pos = i.equip.pos

    -- 首先脱下旧的装备(如果有的话)
    Character:Unequip(ch, pos)
    -- 然后装备新的
    Character:_Equip(ch, item_id)
end

-- 脱下某部位的装备
-- 说明:装备部位 1头部、2衣服、3手套、4腰带、5鞋子、6饰品
function Character:Unequip(ch, pos)
    if ch.equip[pos] then
        local i = items[ch.items[pos]]
        for k,v in pairs(i.equip.change) do
            ch.equip_attr.change[k] = ch.equip_attr.change[k] - v
        end
        for k,v in pairs(i.equip.scale) do
            ch.equip_attr.scale[k] = ch.scale.change[k] - v
        end
        ch.equip[pos] = nil
    end
end

-- 获取角色的某个属性
-- 说明：这个函数会得到玩家经过装备和战斗buff加成以后的属性
function Character:GetAttr(ch, key)
    local value = ch[key]
    if ch.equip_attr.change[key] then
        value = value + ch.equip_attr.change[key]
    end
    if ch.fight_attr.change[key] then
        value = value + ch.fight_attr.change[key]
    end

    local scale = 1
    if ch.equip_attr.scale[key] then
        scale = scale + ch.equip_attr.scale[key]
    end
    if ch.fight_attr.scale[key] then
        scale = scale + ch.fight_attr.scale[key]
    end

    return value * scale
end

-- 获取玩家的某个属性
-- 说明：这个函数会得到玩家的原始属性
function Character:GetRawAttr(ch, key)
    return ch[key]
end

-- 更新装备属性
-- 说明：重置装备强化值为0，并将其更新
function Character:UpdateEquipAttr(ch)
    ch.equip_attr.change = {}
    ch.equip_attr.scale = {}

    for k,v in pairs(ch.equip) do
        Character:_Equip(ch, v)
    end
end

-- 重置战斗强化
-- 说明：将战斗中获得的强化归零
function Character:ResetFightAttr(ch)
    ch.fight_attr.change = {}
    ch.fight_attr.scale = {}    
end

-- 生命值增加
function character.hp_inc(p, num)
    p.hp = p.hp + num
    if p.hp > p.hp_max then
        p.hp = p.hp_max
    end
end

-- 生命值减少，减到小于 0，返回false，人物死亡
function character.hp_dec(p, num)
    p.hp = p.hp - num
    local check = p.hp > 0
    if not check then p.hp = 0 end
    return check
end

-- mp增加
function character.mp_inc(p, num)
    p.mp = p.mp + num
    if p.mp > p.mp_max then
        p.mp = p.mp_max
    end
end

-- mp减少，减到小于 0，返回false
function character.mp_dec(p, num)
    local new_mp = p.mp - num
    local check = (new_mp > 0)
    if check then p.mp = p.mp - num end
    return check
end

-- 经验增加
function character.exp_inc(p, exp)
    p.exp = p.exp + exp
    local level = p.level
    p.level = character.get_level(p.exp)
    if p.level ~= level then
        character.update_player_by_level(p)
        return p.level
    end
end

-- 根据经验获取等级
function character.get_level(exp)
	return math.ceil(math.sqrt(math.sqrt(exp+1)))
end

-- get max_exp
function character.get_max_exp(level)
	return math.pow(level, 4)
end

-- 根据等级更新属性
function character.update_player_by_level(p)
	-- exp_max = level ^ 4
	p.exp_max = character.get_max_exp(p.level)
	-- 血量 = 140 + 耐力 * 15 + 等级 * 10
	p.hp_max = 140 + p.endurance * 15 + p.level * 10
	p.hp = p.hp_max
	-- 蓝量 = 90 + 魔能 * 25 + 等级 * 10
	p.mp_max = 90 + p.spellpower * 25 + p.level * 10
	p.mp = p.mp_max

	-- 近战攻击力 = [力量*0.75 + 等级*0.5, 力量*1.1 + 等级*0.75]
	p.atk_min = math.ceil(p.strength * 0.75 + p.level * 0.5)
	p.atk_max = math.ceil(p.strength * 1.1 + p.level * 0.75)
	-- 远程攻击力 = [敏捷*0.66 + 近战攻击*0.15 + 等级*0.2, 敏捷*1.5 + 近战攻击*0.35 + 等级*1]
	p.atk_range_min = math.ceil(p.agility * 0.66 + p.atk_min * 0.15 + p.level*0.2)
	p.atk_range_max = math.ceil(p.agility * 1.5 + p.atk_max * 0.35 + p.level)
	-- 魔法攻击 = [智力*0.75, 智力*3.5]
	p.atk_magic_min = math.ceil(p.intelligence * 0.75)
	p.atk_magic_max = math.ceil(p.intelligence * 3.5)

	-- 护甲 = 力量 * 1.5 + 等级*0.25
	p.armor = math.ceil(p.strength * 1.5 + p.level * 0.25)
	-- 抗性 = 魔能 * 1.7 + 等级*1.5
	p.resist = math.ceil(p.spellpower * 1.7 + p.level * 1.5)
	-- 防御 = 耐力 * 2 + 等级 * 2.25
	p.defense = math.ceil(p.endurance * 2 + p.level * 2.25)

	-- 暴击伤害比率 = (敏捷 / 150) ^ 1.25 + 1
	p.crit_dmg = (p.agility / 150) ^ 1.25 + 1
	-- 施法成功系数
	p.cast = math.ceil(p.intelligence ^ 1.35 + p.level * 7)
	p.cast_success_rate =  p.cast ^ 0.8 / 998
	-- 暴击概率
	p.crit_rate = (p.will / 400) ^ 0.8
end

-- [roll（攻击min，攻击max）+ （攻击max-攻击min)*意志^0.5/50 - 防御/魔抗]*(1-伤害抵挡）* 暴击倍数

-- 返回伤害数值
function Character:Attack(ch, enm, way)
    -- way 1 物理
    -- way 2 远程
    -- way 3 魔法
    local way = way or 1
    local amr, atk_min, atk_max
    local def = self:GetAttr(ch, 'defense')
    local will = self:GetAttr(ch, 'will')

    if way == 1 then
        amr = Enemy:GetAttr(enm, 'armor')
        atk_min, atk_max = self:GetAttr(ch, 'atk_min'), self:GetAttr(ch, 'atk_max')
    elseif way == 2 then
        amr = Enemy:GetAttr(enm, 'armor')
        atk_min, atk_max = self:GetAttr(ch, 'atk_range_min'), self:GetAttr(ch, 'atk_range_max')
    elseif way == 3 then
        amr = Enemy:GetAttr(enm, 'resist')
        atk_min, atk_max = self:GetAttr(ch, 'atk_magic_min'), self:GetAttr(ch, 'atk_magic_max')
    end

    return math.ceil((math.random(atk_min, atk_max) + math.floor((atk_max - atk_min)*will ^ 0.5 / 50) - amr/5) * (1-def ^ 0.5 / 35))
end
