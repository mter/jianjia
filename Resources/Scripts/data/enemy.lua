
enemy_prefix = {
    -- ����,  ��ս�ȼ�����, ����ٷֱ�, hp�ٷֱ�, mp�ٷֱ�, �˺��ٷֱ�, �����ٷֱ�, ���װٷֱ�, ���԰ٷֱ�, �����б�����
    {'����',             1,       1.2,       1.5,        1,          1,        1.3,        1.3,        1.3,           {}}, -- 1
}

enemy_template = {
    -- ����,  ��ս�ȼ�����,   ����ٷֱ�,   hp�ٷֱ�,  mp�ٷֱ�,   �˺��ٷֱ�,   �����ٷֱ�,  ���װٷֱ�,    ���԰ٷֱ�,    �����б�����
    {'��ͨ',           0,          1,        1,        1,          1,         1,           1,          1,          {}}, -- 1
    {'��Ӣ',           1,       1.25,     1.25,     1.25,       1.15,      1.10,        1.10,       1.10,          {}}, -- 2
    {'Ӣ��',           2,       1.50,     1.35,     1.35,       1.30,      1.20,        1.20,       1.20,          {}}, -- 3
    {'����',           3,       1.75,     1.45,     1.45,       1.45,      1.30,        1.30,       1.30,          {}}, -- 4
    {'����',           3,       4.15,        1,        1,          1,         1,           1,          1,          {}}, -- 5
}

templ_set = {
    newbie = {{0.85, 0.15}, {enemy_template[1], enemy_template[2]}},
}

loot_lst = {
    newbie = {{0.5, 0.5}, {4, 5}},
}

-- �������ͣ�1��ս��2Զ�̣�3ħ��

enemys = {
    --1����,	  2��ս�ȼ�,   3HP,   4MP,    5��������,6��С�˺�,7����˺�,    8����, 9����,  10����,    11ǰ׺����,  12       ģ�弯��,        13�����б�,         14��������,    �ٶ�,   15�����б�,   4˵��
    {'���ͼ�',	    1,    10,    0,         1,         2,       4,      12,    10,     8,          {},   templ_set.newbie,      loot_lst.newbie,           1,     spd=4,      {}, 'һֻ�����͵ļ����������εĵط����֡�����ʱҲ�ڴ�ͥ����֮���ε�'}, -- 1
    {'��·������',	1,    10,    0,         1,         2,       4,      12,    10,     8,          {},   templ_set.newbie,      loot_lst.newbie,           1,     spd=4,      {}, 'һֻ����ʧ������ȡ������������ðɣ�����Ҳ��������Ű֮'}, -- 2
    {'������Ұ��',    3,    20,    0,         1,         4,       8,      14,    10,     8,          {},   templ_set.newbie,      loot_lst.newbie,           1,     spd=6,      {}, 'һ�����ݵĹ���ƽʱ�ǻ��������Ѹ���Ѱ��ʳ�С�ı�ҧ���ˣ�˭֪������ʲô����'}, -- 3
    {'����è',		2,    15,    0,         1,         3,       6,      13,    10,     8,          {},   templ_set.newbie,      loot_lst.newbie,           1,     spd=4,      {}, 'һֻƯ���Ļ���è�������������ݣ���������Ҳ������ֻè��'}, -- 4
    {'�޴��ư��',    2,    5,     0,         2,         3,       6,      10,     4,    12,          {},   templ_set.newbie,      loot_lst.newbie,           1,     spd=4,      {}, 'һֻ˶���ư�棬����������⣬�ܼ�Ӳ�����ӡ��޴�Ŀ���Ħ�����̶�������'}, -- 5
    {'ħ������',	    1,    10,    225,       3,          2,       4,       6,    10,     8,         {},   templ_set.newbie,      loot_lst.newbie,           1,     spd=4,      {}, 'һ�Ż���·�Ĺ�������͸����������������ħ�������⣬������ħ�����'}, -- 6
}

-- ���Ｏ��
enemy_set = {
    -- ����������ִ�Ĺ���
    newbie = {1,2,3,4,5,6},
}

-- ����
-- �������Ӧ��������ɵ���id֮�󱻵��ã�ͬʱ��֮��ͨ�������ȡ�õ�����صĲ�����
Enemy = Class(function(self, data)
    self.data = data
    self.hp = data[3]
    self.mp = data[4]
    self.fight_attr = {change={}, scale={}}
    
    -- �������ģ��
    
    -- �����׺
    
end)

-- ���ؾ���͵���
function Enemy:Killed()
    return self:GetExp(), self:GetLoot()
end

-- ��ȡɱ����������ܹ��õ��ľ���ֵ����
function Enemy:GetExp()
    local level = self:GetAttr('level')
    return math.ceil(50*level*(1+level/30)^(1+level/2))
end

-- ����LOOT�б�������ɵ���
-- @param num ���������Ĭ��Ϊ������Ĭ�ϵ�ֵ���������ĵ��ʼ�������100%����ô�ͻ����num����Ʒ
function Enemy:GetLoot(num)
    local num = num or self.data[14]
    local ret = {}
    for i=1,num do
        table.insert(ret, table.random(self.data[13][1], self.data[13][2]))
    end
    return ret
end

-- ���ݼ���
function Enemy:Dec(key, num)
    if key == 'hp' then
        return self:Inc(key, 0-num)
    elseif key == 'mp' then
        return self:Inc(key, 0-num)
    end
end

-- ��������
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

-- ���﹥�����
-- ����Ҳ�ͬ��way�����ÿգ�������ȥ�Զ���ѯ�������ݾ����������˺���ʽ
function Enemy:Attack(ch, way)
    -- way 1 ����
    -- way 2 Զ��
    -- way 3 ħ��
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

-- ��ȡ�����ĳ������
-- ˵�������������õ���Ҿ���buff��nerf�Ժ������
function Enemy:GetAttr(key)

    local value

    if self[key] then
        value = self[key]
    elseif key == 'hp_max' then
        value = self.data[3]
    elseif key == 'mp_max' then
        value = self.data[4]
    elseif key == 'spd' then
        value = self.data.spd
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
