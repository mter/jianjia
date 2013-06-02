
spells = {
    --id, ���֣�                      ����,            ��ѧ������ ����˵��
    {_'������˹֮����',         id=1,  cost={mp=300},   effect={{need_cast=true, action_on=1, change={level=999}, scale={hp_max=0.3}, delay=3, round=999, each_round=false,}}, txt='��ɪʱ���İ������߳ɹ����Է���֮���������ְ֮��' },
    {_'����������',            id=2,  cost={mp=10},    effect={{need_cast=true, action_on=1, scale={hp=0.3}, delay=0, round=999, each_round=false,}}, txt='�ظ�����ֵ 30%'},
    {_'����',                 id=3,                   effect={{need_cast=true, action_on=1, scale={defense=0.2}, round=1, lost=true}}, txt='����'},
}

Spell = Class()
Spell.cast_list = {}

-- �ڲ�����������id��ȡ��Ʒtable��������ı��������Ʒtable����ԭ�����ء�
--         ��ô����ԭ������ʱ��Ҫ��id����Ʒ����ʱ��ֱ�Ӵ���Ʒtable
function Spell:_getitem(id_or_table)
    local _type = type(id_or_table)
    if _type == 'table' then
        return id_or_table
    elseif _type == 'number' then
        return spells[id_or_table]
    end
end

-- ���ö��У���һ��ս����ʼǰ���������á�
function Spell:ResetQueue()
    self.cast_list = {}
end

-- ִ�ж��У���ǰ��ɫ�غϿ�ʼ���������������
function Spell:RunQueue(obj)

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
function Spell:ClearQueue(obj)

    for k,v in pairs(self.cast_list) do
        if ch == obj and v[1] then
            v[1] = v[1] - 1
            if v[1] <= 0 then
                if item.is_buff then
                    ch:RemoveBuff(item.id, true)
                end
                if item.lost then
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

-- ʹ�ü���
function Spell:Cast(ch, spl, level, in_fight)
    local in_fight = in_fight or false
    local spl = self:_getitem(spl)

    -- ������Ʒ������ս����ʹ�ã��򷵻� false
    if spl.fight == in_fight then
        return false, '�����Ʒֻ����ս����ʹ��'
    end
    -- ������Ʒ����buffЧ����buff�б��д������ӳ���ʱ�䣬�������򴴽�
    if item.is_buff then
        if ch:GetBuff(item.id, true) then
            for k,v in pairs(self.cast_list) do
                if ch == v[2] and item == v[3] then
                    v[1] = v[1] + item.round
                    break
                end
            end
        else
            ch:AddBuff(item.id, true)
            table.insert(self.cast_list, {item.round, ch, item})
        end
    else
        table.insert(self.cast_list, {item.round, ch, item})
    end
    --self:LostItem(item)
    -- ����ս���еĻ� ֱ��ִ�ж��в���������
    if not in_fight then
        Items:RunQueue(ch)
        ch:UpdateFightAttr()
    end
    return true
end

-- �Ƿ�ﵽ�ͷ�������δ��ɣ�
-- ˵������Խ�ɫ�͹�����зֱ���
function Spell:CanCast(obj, spl, level)

    if type(spl) == 'number' then
        spl = spells[spl]
    end

    local req = spl.req
    local cost = spl.cost

    -- ����һ����ɫ���ж��������ԡ�Ҫ���Լ���������
    if obj.is_character then
        -- �ж����Ժ�Ҫ��
        -- return false, 1, 'û�дﵽʹ�ü���Ҫ��'

        -- �ж�����
        for k, v in pairs(cost) do
            if v > obj:GetAttr(k) then
                return false, 2, '�޷����㼼������'
            end
        end
    else
        -- �����ǽ�ɫ���ж�����Ҫ��ͼ�������
        -- �ж�Ҫ��

        -- �ж�����
        for k, v in pairs(cost) do
            if v > obj:GetAttr(k) then
                return false, 2, '�޷����㼼������'
            end
        end
    end

    return true
end
