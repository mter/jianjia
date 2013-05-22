
spells = {
    --id, ���֣�                              ����,      ����,   ��ѧ������ ����˵��
    { _'������˹֮����',id=1,  req={ lt = {}, eq = {}, gt = {} }, cost={ mp = 300 }, effect={ { need_cast = true, action_on = 1, change = { level = 999 }, scale = { hp_max = 0.3 }, delay = 3, round = 999, each_round = false, } }, txt='������˹֮�������������߳ɹ������Է���֮���������ְ֮��' },
    { _'����������', id=2,  req={ lt= {}, eq = {}, gt = {} }, cost={ mp = 10 }, effect={ { need_cast = true, action_on = 1, change = {}, scale = { hp = 0.3, atk_min = 1, atk_min = 1 }, delay = 0, round = 999, each_round = false, } }, txt='�ظ�����ֵ 30%' },
}

Spell = Class()

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

--�ͷż���
function Spell:Cast(from, to, spl)
    local result = {}
    --�۳�����
    for k, v in pairs(spl.cost) do
        from:Dec(k, v)
    end
--    local con = spl.effect
    --��������
    for k, v in pairs(spl.effect[1].change) do
        local r = to:GetAttr(k) - v
        to:Inc(k, r)
        result[k] = r
    end
    --��������
    for k, v in pairs(spl.effect[1].scale) do
        local r = to:GetAttr(k) * v
        to:Inc(k, r)
        result[k] = r
    end
    return result
end
