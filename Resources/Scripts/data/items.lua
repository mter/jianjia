
-- װ����λ id
-- 1ͷ����2�·���3���ס�4������5Ь�ӡ�6��Ʒ

item_prefix = {
    {'ǿ����', change={}, scale={}, spell={}}, -- 1
}

items = {
    -- ���֣�            ����,
    {_'����',           id=1, req={ge={level=5}},  equip={pos=1, change={}, scale={hp_max=0.1}}, use=nil, spell=nil, prefix={}, txt=_'�������ɱ仯��С��˫���ؽ���'}, -- 1
    {_'��ʿ�̵�',        id=2, equip={pos=1, change={}, scale={}}, prefix={{0.1}, {1}}, txt=_'ֻ�����߲���ӵ�еĶ̵�!'}, -- 2
    {_'��������֮��',     id=3, txt=_'��ǰ����һ���ݴԡ���'},
    {_'��������ҩ��',     id=4, use={change={hp=150}}, txt='�ظ� 150 ��HP��'},  -- delay = 0, round = 3, each_round = false, lost = true
    {_'����ħ��ҩ��',     id=5, use={change={mp=150}}, txt='�ظ� 150 ��MP��'},
    {_'���������ظ�ҩ��',  id=6, use={change={hp=70}, round=3, each_round=true, fight=true, is_buff=true}, txt='ÿ�غϻظ� 70 ��HP������3�غϡ��ظ�ʹ��Ч�������ӣ���ʱ����ӳ���ֻ����ս����ʹ�á�'},
}

-- ���ǿ����ظ����ӵ���Ʒ�������buff�б�

Items = Class()
Items.cast_list = {}

-- �ڲ�����������id��ȡ��Ʒtable��������ı��������Ʒtable����ԭ�����ء�
--         ��ô����ԭ������ʱ��Ҫ��id����Ʒ����ʱ��ֱ�Ӵ���Ʒtable
function Items:_getitem(id_or_table)
    local _type = type(id_or_table)
    if _type == 'table' then
        return id_or_table
    elseif _type == 'number' then
        return items[id_or_table]
    end
end

-- ���ö��У���һ��ս����ʼǰ���������á�
function Items:ResetQueue()
    self.cast_list = {}
end

-- ִ�ж��У���ǰ��ɫ�غϿ�ʼ���������������
function Items:RunQueue(obj)

    for k,v in pairs(self.cast_list) do
        local round, ch, item = v[1], v[2], v[3]
        if ch == obj and (item.use.each_round or item.use.round == round) then
            if item.use.scale then
                for k,v in pairs(item.use.scale) do
                    ch.fight_attr.scale[k] = ch.fight_attr.scale[k] or 0 + v
                end
            end

            if item.use.change then
                for k,v in pairs(item.use.change) do
                    ch.fight_attr.change[k] = ch.fight_attr.change[k] or 0 + v
                end
            end
        end
    end

end

-- �������¶��У���ǰ��ɫ�غϿ�ʼǰ����
function Items:ClearQueue(obj)

    for k,v in pairs(self.cast_list) do
        if ch == obj and v[1] then
            v[1] = v[1] - 1
            if v[1] <= 0 then
                if item.use.is_buff then
                    ch:RemoveBuff(item.id, true)
                end
                if item.use.lost then
                    if item.use.scale then
                        for k,v in pairs(item.use.scale) do
                            ch.fight_attr.scale[k] = ch.fight_attr.scale[k] + v
                        end
                    end

                    if item.use.change then
                        for k,v in pairs(item.use.change) do
                            ch.fight_attr.change[k] = ch.fight_attr.change[k] - v
                        end
                    end
                end
                table.remove(self.cast_list, k)
            end
        end
    end

end

-- ʹ����Ʒ
function Items:Use(ch, item, in_fight)
    local in_fight = in_fight or false
    local item = self:_getitem(item)
    -- ������Ʒ��һ������Ʒ
    if self:IsConsumable(item) then
        -- ������Ʒ������ս����ʹ�ã��򷵻� false
        if item.use.fight == in_fight then
            return false, '�����Ʒֻ����ս����ʹ��'
        end
        -- ������Ʒ����buffЧ����buff�б��д������ӳ���ʱ�䣬�������򴴽�
        if item.use.is_buff then
            if ch:GetBuff(item.id, true) then
                for k,v in pairs(self.cast_list) do
                    if ch == v[2] and item == v[3] then
                        v[1] = v[1] + item.use.round
                        break
                    end
                end
            else
                ch:AddBuff(item.id, true)
                table.insert(self.cast_list, {item.use.round, ch, item})
            end
        else
            table.insert(self.cast_list, {item.use.round, ch, item})
        end
        --self:LostItem(item)
        -- ����ս���еĻ� ֱ��ִ�ж��в���������
        if not in_fight then
            Items:RunQueue(ch)
            ch:UpdateFightAttr()
        end
    -- ������Ʒ��һ��װ��
    elseif self:IsEquipment(item) then
        if in_fight then
           return false, 'ս�����޷�����װ��'
        end
        ch:Equip(item.id)
    -- ��ֻ��һ������Ʒ��
    elseif self:IsItem(item) then
        return false, '�޷�ʹ�������Ʒ'
    end
    return true
end

-- ��һ����Ʒ
-- @param item ��Ʒ��id����������Ʒ�ı�
-- @param num ��ø���Ʒ������
-- ��Ʒ��ţ� data.items = {{��Ʒid1, ��Ʒ����}, {��Ʒid2, ��Ʒ����}}
function Items:GetItem(item, num)
    data.items = data.items or {}
    num = num or 1
    local item = self:_getitem(item)
    if item then
        local is_equip = Items:IsEquipment(item) or Items:IsItem(item)
        -- �����һ��װ������Ʒ����ôװ��/��Ʒ��Զռһ�񣬲���ѵ�
        if is_equip then
            for i=1,num do
                table.insert(data.items, {item.id, 1})
            end
        -- ���������Ʒ����ô���Զѵ�
        else
            -- ����������б��У���������
            for k,v in pairs(data.items) do
                if v[1] == item.id then
                    v[2] = v[2] + num
                    return
                end
            end
            -- �������ڣ�ֱ�Ӳ���
            table.insert(data.items, {item.id, num})
        end
    end
end

-- ���ʧȥ��Ʒ
-- @param item ��Ʒ��id����������Ʒ�ı�
-- @param num ʧȥ����Ʒ����������������Ŀ�������ӵ�е���Ŀ�������ͻ�ʧ��
-- @retval ��ִ�гɹ� �������ڵ���Ʒ������ʧ�ܷ��� nil
function Items:LostItem(item, num)
    data.items = data.items or {}
    num = num or 1
    local item = self:_getitem(item)
    if item then
        -- ����Ƿ������װ���б���
        for k,v in pairs(data.items) do
            if v[1] == item.id then
                if v[2] >= num then
                    v[2] = v[2] - num
                    local ret = v[2]
                    if v[2] == 0 then
                        -- �������Ϊ0������Ʒ�б����Ƴ�
                        table.remove(data.items, k)
                    end
                    return ret
                end
            end
        end
    end
    return nil, '��Ʒ�������㣡'
end

-- �Ƿ���һ��װ����Ʒ
-- ˵����������װ������Ϊװ����Ʒ
function Items:IsEquipment(item)
    return Items:_getitem(item).equip
end

-- �Ƿ�������Ʒ
-- ˵����������Ʒ���Ա�ʹ�ã�����Ϊ����Ʒ
function Items:IsConsumable(item)
    return self:_getitem(item).use
end

-- �Ƿ���һ������Ʒ��
-- ˵����������Ʒ����װ����ͬʱ�޷���Ϊ����Ʒʹ�ã���Ϊ����Ʒ��
function Items:IsItem(item)
    local i = Items:_getitem(item)
    return (not i.equip) and (not i.use)
end

-- ����Ƿ���װ����ʹ��ĳ��Ʒ
-- ����ֵ����һ��Ϊ true �� false���ڶ���Ϊԭ��
function Items:CanUse(ch, item)
    local i = Items:_getitem(item)
    if not i then
        return false, _'�޷��ҵ���Ӧ��Ʒ'
    end

    -- ���������ڵ��ڣ�������С�����ʱ���ش���
    if i.ge then
        for k,v in pairs(i.ge) do
            if v < ch[k] then
                return false, _'�������Բ��ܴﵽҪ��'
            end
        end        
    end
    
    -- ���������ڣ�������С�ڵ������ʱ���ش���
    if i.gt then
        for k,v in pairs(i.gt) do
            if v <= ch[k] then
                return false, _'�������Բ��ܴﵽҪ��'
            end
        end
    end

    -- ���������ڣ�����������ʱ���ش���
    if i.eq then
        for k,v in pairs(i.eq) do
            if v ~= ch[k] then
                return false, _'�������Բ��ܴﵽҪ��'
            end
        end
    end

    -- ��������ȣ�����������ʱ���ش���
    if i.eq then
        for k,v in pairs(i.eq) do
            if v ~= ch[k] then
                return false, _'�������Բ��ܴﵽҪ��'
            end
        end
    end

    -- ������С�ڣ��������ڵ���ʱ���ش���
    if i.lt then
        for k,v in pairs(i.lt) do
            if v >= ch[k] then
                return false, _'�������Գ���Ҫ��'
            end
        end
    end

    -- ������С�ڵ��ڣ���������ʱ���ش���
    if i.le then
        for k,v in pairs(i.le) do
            if v > ch[k] then
                return false, _'�������Գ���Ҫ��'
            end
        end
    end
    
    return true, _'����ʹ��'
end

Items.CanEquip = Items.CanUse
