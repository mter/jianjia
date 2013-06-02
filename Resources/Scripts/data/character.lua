-- ���ֹ��췽ʽ��һ���Ǽ��أ�����һ�� table ��Ϊ��Ϣ��һ�����½���
Character = Class(function(self, name, txt)
    if type(name) == 'table' then
        self.data = name
    else
        local txt = txt or ''
        -- self.data ����Ҫ���������
        -- ���� hp �� mp������û������д��
        self.data = {
            name = name,
            txt = txt,
            exp = 0,

            -- ����
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

-- װ����Ʒ��������ӱ������Ƴ������Ʒ��Ҳ�������¾ɵ�װ��������֮��ֻ���ý�ɫ������װ�������ԡ�
-- ˵�����ڲ�������������������
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

-- ����װ����������װ���Żر���
-- ˵�����ڲ�������������������
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

-- װ��ĳ����Ʒ
-- ˵��:װ����λ 1ͷ����2�·���3���ס�4������5Ь�ӡ�6��Ʒ
--      item_id ��װ��id
function Character:Equip(item_id)
    local i = items[item_id]
    local pos = i.equip.pos

    -- �������¾ɵ�װ��(����еĻ�)
    self:Unequip(pos)
    -- Ȼ��װ���µ�
    self:_Equip(item_id)
    -- ����Ʒ�б����Ƴ��µ�װ��
    Item:LostItem(item_id)
end

-- ����ĳ��λ��װ��
-- ˵��:װ����λ 1ͷ����2�·���3���ס�4������5Ь�ӡ�6��Ʒ
function Character:Unequip(pos)
    -- ����װ���������������Ʒ�б�
    local item_id = self:_Unequip(pos)
    Item:GetItem(item_id)
end

-- ѧϰ���ܣ�ͬʱҲ���Ե����������ܵȼ���ʹ��
-- @param spl ����ID�����Ǵ�ż������ݵ�table
-- @param level �ȼ���Ĭ��Ϊ1��Ϊ0������ʱ�Ӽ����б���ȥ���������
function Character:LearnSpell(spl, level)
    local spells = self.data.spells

    --  �����ܵȼ�С�ڵ���0������б���ɾ��
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

-- ʧȥ����
function Character:LostSpell(spl, level)
    self:LearnSpell(spl, 0-level)
end

-- ��ü����б�
function Character:GetSpells(spl, level)
    return self.data.spells
end

-- ��ȡ��ɫ��ĳ������
-- ˵�������������õ���Ҿ���װ����ս��buff�ӳ��Ժ������
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

-- ��ȡ��ҵ�ĳ������
-- ˵�������������õ���ҵ�ԭʼ����
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

-- ���ݼ���
function Character:Dec(key, num)
    if key == 'hp' then
        return self:Inc(key, 0 - num)
    elseif key == 'mp' then
        return self:Inc(key, 0 - num)
    end
end

-- ��������
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


-- ���ݾ����ȡ�ȼ�
function Character:GetLevel(exp)
    return math.ceil(math.sqrt(math.sqrt(exp + 1)))
end

-- ���ݵȼ�������������
function Character:UpdateBaseAttr()

    -- ��������
    local data = self.data
    local ex = self.extra

    -- ���µȼ�
    ex.level = Character:GetLevel(data.exp)

    -- Ѫ�� = 140 + ���� * 15 + �ȼ� * 10
    ex.hp_max = 140 + self:GetAttr('endurance') * 15 + self:GetAttr('level') * 10

    -- ���� = 90 + ħ�� * 25 + �ȼ� * 10
    ex.mp_max = 90 + self:GetAttr('spellpower') * 25 + self:GetAttr('level') * 10

    -- ��ս������ = [����*0.75 + �ȼ�*0.5, ����*1.1 + �ȼ�*0.75]
    ex.atk_min = math.ceil(self:GetAttr('strength') * 0.75 + self:GetAttr('level') * 0.5)
    ex.atk_max = math.ceil(self:GetAttr('strength') * 1.1 + self:GetAttr('level') * 0.75)

    -- Զ�̹����� = [����*0.66 + ��ս����*0.15 + �ȼ�*0.2, ����*1.5 + ��ս����*0.35 + �ȼ�*1]
    ex.atk_range_min = math.ceil(self:GetAttr('agility') * 0.66 + self:GetAttr('atk_min') * 0.15 + self:GetAttr('level') * 0.2)
    ex.atk_range_max = math.ceil(self:GetAttr('agility') * 1.5 + self:GetAttr('atk_max') * 0.35 + self:GetAttr('level'))

    -- ħ������ = [����*0.75, ����*3.5]
    ex.atk_magic_min = math.ceil(self:GetAttr('intelligence') * 0.75)
    ex.atk_magic_max = math.ceil(self:GetAttr('intelligence') * 3.5)

    -- ���� = ���� * 1.5 + �ȼ�*0.25
    ex.armor = math.ceil(self:GetAttr('strength') * 1.5 + self:GetAttr('level') * 0.25)
    -- ���� = ħ�� * 1.7 + �ȼ�*1.5
    ex.resist = math.ceil(self:GetAttr('spellpower') * 1.7 + self:GetAttr('level') * 1.5)
    -- ���� = ���� * 2 + �ȼ� * 2.25
    ex.defense = math.ceil(self:GetAttr('endurance') * 2 + self:GetAttr('level') * 2.25)

    -- �����˺����� = (���� / 150) ^ 1.25 + 1
    ex.crit_dmg = (self:GetAttr('agility') / 150) ^ 1.25 + 1

    -- ʩ���ɹ�ϵ�� - ��ʱ�Ƴ���̫������
    -- ex.cast = math.ceil(data.intelligence ^ 1.35 + ex.level * 7)
    -- ex.cast_success_rate =  ex.cast ^ 0.8 / 998

    -- ��������
    ex.crit_rate = (self:GetAttr('will') / 400) ^ 0.8

    if not data.hp then
        data.hp = self:GetAttr('hp_max')
    end

    if not data.mp then
        data.mp = self:GetAttr('mp_max')
    end
end

-- ˢ��ս��ǿ������
-- ��������Ὣ fight_attr ��һЩ������ļӳɣ�����hp�ȣ��鲢��ԭʼ�����ڡ�
-- ��Ҫע������������ִ�к󣬽�ɫ���ܻ�������
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

-- ����װ������
-- ˵��������װ��ǿ��ֵΪ0�����������
function Character:UpdateEquipAttr()
    self.equip_attr.change = {}
    self.equip_attr.scale = {}

    for k, v in pairs(self.data.equip) do
        Character:_Equip(ch, v)
    end
end

-- ����ս��ǿ��
-- ˵������ս���л�õ�ǿ������
function Character:ResetFightAttr()
    self.fight_attr.change = {}
    self.fight_attr.scale = {}
end

-- [roll������min������max��+ ������max-����min)*��־^0.5/50 - ����/ħ��]*(1-�˺��ֵ���* ��������

-- �����˺���ֵ
function Character:Attack(enm, way)
    -- way 1 ����
    -- way 2 Զ��
    -- way 3 ħ��
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

-- �鿴�б����Ƿ���ĳ��buff
function Character:GetBuff(id, is_item)
    if is_item then
        local id = id + 50000
    end
    return self.buff[id]
end

-- ����Buff�б�
function Character:AddBuff(id, is_item)
    if is_item then
        local id = id + 50000
    end
    self.buff[id] = self.buff[id] or 0 + 1
end

-- �� Buff �б����Ƴ�
function Character:RemoveBuff(id, is_item)
    if is_item then
        local id = id + 50000
    end
    self.buff[id] = nil
end
