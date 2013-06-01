-- 两种构造方式，一种是加载，传入一个 table 作为信息，一种是新建。
Character = Class(function(self, name, txt)
    if type(name) == 'table' then
        self.data = name
    else
        local txt = txt or ''
        -- self.data 是需要保存的数据
        -- 包括 hp 和 mp，不过没在这里写。
        self.data = {
            name = name,
            txt = txt,
            exp = 0,

            -- 六边
            strength = 5,
            agility = 5,
            intelligence = 5,
            spellpower = 5,
            endurance = 5,
            will = 5,
            spells = {},
            equip = {},
        }
    end
    self.extra = {}
    self.is_character = true
    self.spells = self.data.spells
    self.equip = self.data.equip

    self.buff = {}
    self.equip_attr = { change = {}, scale = {} }
    self.fight_attr = { change = {}, scale = {} }

    self:UpdateEquipAttr()
    self:UpdateBaseAttr()
end)

-- 装备物品，但不会从背包中移除这个物品，也不会脱下旧的装备。换言之，只是让角色加上新装备的属性。
-- 说明：内部方法，请勿从外面调用
function Character:_Equip(item_id)
    local i = items[item_id]
    for k, v in pairs(i.equip.change) do
        if not self.equip_attr.change[k] then
            self.equip_attr.change[k] = 0
        end
        self.equip_attr.change[k] = self.equip_attr.change[k] + v
    end
    for k, v in pairs(i.equip.scale) do
        if not self.equip_attr.scale[k] then
            self.equip_attr.scale[k] = 0
        end
        self.equip_attr.scale[k] = self.scale.change[k] + v
    end
    self.equip[i.equip.pos] = item_id
end

-- 脱下装备，但不将装备放回背包
-- 说明：内部方法，请勿从外面调用
function Character:_Unequip(pos)
    if self.equip[pos] then
        local i = items[self.items[pos]]
        for k, v in pairs(i.equip.change) do
            self.equip_attr.change[k] = self.equip_attr.change[k] - v
        end
        for k, v in pairs(i.equip.scale) do
            self.equip_attr.scale[k] = self.scale.change[k] - v
        end
        self.equip[pos] = nil
    end
end

-- 装备某样物品
-- 说明:装备部位 1头部、2衣服、3手套、4腰带、5鞋子、6饰品
--      item_id 是装备id
function Character:Equip(item_id)
    local i = items[item_id]
    local pos = i.equip.pos

    -- 首先脱下旧的装备(如果有的话)
    self:Unequip(pos)
    -- 然后装备新的
    self:_Equip(item_id)
    -- 从物品列表中移除新的装备
    Item:LostItem(item_id)
end

-- 脱下某部位的装备
-- 说明:装备部位 1头部、2衣服、3手套、4腰带、5鞋子、6饰品
function Character:Unequip(pos)
    -- 脱下装备并将其添加入物品列表
    local item_id = self:_Unequip(pos)
    Item:GetItem(item_id)
end

-- 学习技能，同时也可以当做提升技能等级来使用
-- @param spl 技能ID或者是存放技能数据的table
-- @param level 等级，默认为1，为0或以下时从技能列表中去除这个技能
function Character:LearnSpell(spl, level)
    local spells = self.data.spells

    --  若技能等级小于等于0，则从列表中删除
    local function _end(index)
        if spells[index][2] <= 0 then
            table.remove(spells, index)
        end
    end

    if type(spl) == 'table' then
        spl = spl.id
    end
    level = level or 1
    for k,v in pairs(spells) do
        if v[1] == spl then
            v[2] = v[2] + level
            _end(k)
            return
        end
    end
    table.insert(spells, {spl, level})
    _end(#spells)
end

-- 失去技能
function Character:LostSpell(spl, level)
    self:LearnSpell(spl, 0-level)
end

-- 获得技能列表
function Character:GetSpells(spl, level)
    return self.data.spells
end

-- 获取角色的某个属性
-- 说明：这个函数会得到玩家经过装备和战斗buff加成以后的属性
function Character:GetAttr(key)

    local value = self:GetRawAttr(key)

    if type(value) == 'number' then
        if self.equip_attr.change[key] then
            value = value + self.equip_attr.change[key]
        end
        if self.fight_attr.change[key] then
            value = value + self.fight_attr.change[key]
        end

        local scale = 1
        if self.equip_attr.scale[key] then
            scale = scale + self.equip_attr.scale[key]
        end
        if self.fight_attr.scale[key] then
            scale = scale + self.fight_attr.scale[key]
        end

        return value * scale
    else
        return value
    end
end

-- 获取玩家的某个属性
-- 说明：这个函数会得到玩家的原始属性
function Character:GetRawAttr(key)
    local value = self.data[key]
    if key == 'spd' then
        value = math.max(self.data.strength, self.data.agility, self.data.intelligence, self.data.spellpower, self.data.endurance, self.data.will)
    end
    if not value then
        value = self.extra[key]
    end
    if not value then
        return 0
    end
    return value
end

-- 数据减少
function Character:Dec(key, num)
    if key == 'hp' then
        return self:Inc(key, 0 - num)
    elseif key == 'mp' then
        return self:Inc(key, 0 - num)
    end
end

-- 数据增加
function Character:Inc(key, num)
    if key == 'hp' then
        local hp_max = self:GetAttr('hp_max')
        self.data.hp = self.data.hp + num
        if self.data.hp > hp_max then
            self.data.hp = hp_max
        end
        if self.data.hp < 0 then
            self.data.hp = 0
        end
        return self.data.hp
    elseif key == 'mp' then
        local mp_max = self:GetAttr('mp_max')
        self.data.mp = self.data.mp + num
        if self.data.mp > mp_max then
            self.data.mp = mp_max
        end
        if self.data.mp < 0 then
            self.data.mp = 0
        end
        return self.data.mp
    elseif key == 'exp' then
        local level = self.extra.level
        self.data.exp = self.data.exp + num
        self:UpdateBaseAttr()
        if level ~= self.extra.level then
            self.data.hp = self:GetAttr('hp_max')
            self.data.mp = self:GetAttr('mp_max')
            return self.extra.level
        end
    end
end


-- 根据经验获取等级
function Character:GetLevel(exp)
    return math.ceil(math.sqrt(math.sqrt(exp + 1)))
end

-- 根据等级更新人物属性
function Character:UpdateBaseAttr()

    -- 数据引用
    local data = self.data
    local ex = self.extra

    -- 更新等级
    ex.level = Character:GetLevel(data.exp)

    -- 血量 = 140 + 耐力 * 15 + 等级 * 10
    ex.hp_max = 140 + self:GetAttr('endurance') * 15 + self:GetAttr('level') * 10

    -- 蓝量 = 90 + 魔能 * 25 + 等级 * 10
    ex.mp_max = 90 + self:GetAttr('spellpower') * 25 + self:GetAttr('level') * 10

    -- 近战攻击力 = [力量*0.75 + 等级*0.5, 力量*1.1 + 等级*0.75]
    ex.atk_min = math.ceil(self:GetAttr('strength') * 0.75 + self:GetAttr('level') * 0.5)
    ex.atk_max = math.ceil(self:GetAttr('strength') * 1.1 + self:GetAttr('level') * 0.75)

    -- 远程攻击力 = [敏捷*0.66 + 近战攻击*0.15 + 等级*0.2, 敏捷*1.5 + 近战攻击*0.35 + 等级*1]
    ex.atk_range_min = math.ceil(self:GetAttr('agility') * 0.66 + self:GetAttr('atk_min') * 0.15 + self:GetAttr('level') * 0.2)
    ex.atk_range_max = math.ceil(self:GetAttr('agility') * 1.5 + self:GetAttr('atk_max') * 0.35 + self:GetAttr('level'))

    -- 魔法攻击 = [智力*0.75, 智力*3.5]
    ex.atk_magic_min = math.ceil(self:GetAttr('intelligence') * 0.75)
    ex.atk_magic_max = math.ceil(self:GetAttr('intelligence') * 3.5)

    -- 护甲 = 力量 * 1.5 + 等级*0.25
    ex.armor = math.ceil(self:GetAttr('strength') * 1.5 + self:GetAttr('level') * 0.25)
    -- 抗性 = 魔能 * 1.7 + 等级*1.5
    ex.resist = math.ceil(self:GetAttr('spellpower') * 1.7 + self:GetAttr('level') * 1.5)
    -- 防御 = 耐力 * 2 + 等级 * 2.25
    ex.defense = math.ceil(self:GetAttr('endurance') * 2 + self:GetAttr('level') * 2.25)

    -- 暴击伤害比率 = (敏捷 / 150) ^ 1.25 + 1
    ex.crit_dmg = (self:GetAttr('agility') / 150) ^ 1.25 + 1

    -- 施法成功系数 - 暂时移除，太蛋疼了
    -- ex.cast = math.ceil(data.intelligence ^ 1.35 + ex.level * 7)
    -- ex.cast_success_rate =  ex.cast ^ 0.8 / 998

    -- 暴击概率
    ex.crit_rate = (self:GetAttr('will') / 400) ^ 0.8

    if not data.hp then
        data.hp = self:GetAttr('hp_max')
    end

    if not data.mp then
        data.mp = self:GetAttr('mp_max')
    end
end

-- 刷新战斗强化属性
-- 这个函数会将 fight_attr 中一些不合理的加成（例如hp等）归并到原始数据内。
-- 需要注意的是这个函数执行后，角色可能会死亡。
function Character:UpdateFightAttr()
    
    local function change_inc(key)
        local ret
        if self.fight_attr.change[key] then
            ret = self:Inc(key, self.fight_attr.change[key])
            self.fight_attr.change[key] = nil
            return ret
        end
    end

    local function scale_inc(key)
        local ret
        if self.fight_attr.change[key] then
            ret = self:Inc(key, self:GetAttr(key) * self.fight_attr.scale[key])
            self.fight_attr.scale[key] = nil
            return ret
        end
    end

    local ret = change_inc('hp')
    change_inc('mp')
    change_inc('exp')

    ret = scale_inc('hp')
    scale_inc('mp')
    scale_inc('exp')

    if ret == 0 then
        return true
    end

end

-- 更新装备属性
-- 说明：重置装备强化值为0，并将其更新
function Character:UpdateEquipAttr()
    self.equip_attr.change = {}
    self.equip_attr.scale = {}

    for k, v in pairs(self.data.equip) do
        Character:_Equip(ch, v)
    end
end

-- 重置战斗强化
-- 说明：将战斗中获得的强化归零
function Character:ResetFightAttr()
    self.fight_attr.change = {}
    self.fight_attr.scale = {}
end

-- [roll（攻击min，攻击max）+ （攻击max-攻击min)*意志^0.5/50 - 防御/魔抗]*(1-伤害抵挡）* 暴击倍数

-- 返回伤害数值
function Character:Attack(enm, way)
    -- way 1 物理
    -- way 2 远程
    -- way 3 魔法
    local way = way or 1
    local amr, atk_min, atk_max
    local def = self:GetAttr('defense')
    local will = self:GetAttr('will')

    if way == 1 then
        amr = enm:GetAttr('armor')
        atk_min, atk_max = self:GetAttr('atk_min'), self:GetAttr('atk_max')
    elseif way == 2 then
        amr = enm:GetAttr('armor')
        atk_min, atk_max = self:GetAttr('atk_range_min'), self:GetAttr('atk_range_max')
    elseif way == 3 then
        amr = enm:GetAttr('resist')
        atk_min, atk_max = self:GetAttr('atk_magic_min'), self:GetAttr('atk_magic_max')
    end

    return math.ceil((math.random(atk_min, atk_max) + math.floor((atk_max - atk_min) * self:GetAttr('will') ^ 0.5 / 50) - amr / 5) * (1 - def ^ 0.5 / 35))
end

-- 查看列表中是否有某个buff
function Character:GetBuff(id, is_item)
    if is_item then
        local id = id + 50000
    end
    return self.buff[id]
end

-- 加入Buff列表
function Character:AddBuff(id, is_item)
    if is_item then
        local id = id + 50000
    end
    self.buff[id] = self.buff[id] or 0 + 1
end

-- 从 Buff 列表中移除
function Character:RemoveBuff(id, is_item)
    if is_item then
        local id = id + 50000
    end
    self.buff[id] = nil
end
