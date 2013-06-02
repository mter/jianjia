
FightSession = Class(function(self, random_enm_lst, enm_lst, maxnum)
    -- ��ó�ʼ��Ϣ
    if not random_enm_lst then
        print('û����������б� FightSession ��ʼ��ʧ�ܣ�')
        return
    end

    -- ��ʼ�����������������������ᳬ����ɫ���� + 1
    local maxnum = maxnum or #data.ch + 1
    if maxnum > 4 then
        maxnum = 4
    end
    local num = math.random(1, maxnum)
    self.enemy = {}
    
    -- ����̶�����
    if enm_lst then
        for k,v in pairs(enm_lst) do
            table.insert(self.enemy, Enemy(enemys[v]))
        end
    end

    -- ������ɵ��˶��󲢼����б�
    for i = #self.enemy+1, num do
        local index = math.random(1, #random_enm_lst)
        table.insert(self.enemy, Enemy(enemys[random_enm_lst[index]]))
    end
    
    -- ��ʼ��������ɫ
    data.chfight = {}
    for k,v in pairs(data.ch) do
        if v:GetAttr('hp') > 0 then
            table.insert(data.chfight, v)
        end
    end
    
    -- ��������
    for k,v in pairs(self.enemy) do
        v.index = k
    end

    for k,v in pairs(data.chfight) do
        v.index = k
    end

    -- ��ɲ���ʼ������
    self.fightret = nil
    self.turn = 0   -- ��ǰ����
    self.atk_list = {} -- �ж�˳��
    self:RefreshRound() -- ��ʼ��һ�غ�

end)


-- �»غϿ�ʼ
-- ���ж�˳���������
-- �ڲ����� һ�㲻��Ҫ����
function FightSession:RefreshRound()
    -- ˢ�¹���˳��
    self.atk_list = {}
    self.turn = self.turn + 1

    for k,v in pairs(data.chfight) do
        if v:GetAttr('hp') > 0 then
            table.insert(self.atk_list, v)
        end
    end

    for k,v in pairs(self.enemy) do
        if v:GetAttr('hp') > 0 then
            table.insert(self.atk_list, v)
        end
    end

    table.sort(self.atk_list, function(a, b)
        -- �ж�ֵ�ߵĻ����ȶ�������ͬ�ж�ֵ�Ϳ�������
        return a:GetAttr('spd') > b:GetAttr('spd')
    end)    
end

-- �����һ��������
function FightSession:GetNext()
    for k,v in pairs(self.atk_list) do
        if v:GetAttr('hp') <= 0 then
            table.remove(self.atk_list, k)
        end
    end
    
    if #self.atk_list == 0 then
        return
    end

    local ret = self.atk_list[1]
    table.remove(self.atk_list, 1)
    return ret
end

-- ���ս���Ƿ������ʤ������ʧ�ܡ�
function FightSession:CheckOver()
    local player_dead = true
    for k,v in pairs(data.chfight) do
        if v:GetAttr('hp') > 0 then
            player_dead = false
        end
    end

    local ememy_dead = true
    for k,v in pairs(self.enemy) do
        if v:GetAttr('hp') > 0 then
            ememy_dead = false
        end        
    end

    if player_dead then
        self.fightret = 1
    end

    if ememy_dead and (not player_dead) then
        self.fightret = 2
    end
    return self.fightret
end

-- ���лغϲ���
-- ����ǽ�ɫ���й�������ô��Ҫ��дȫ������������ǵ��ˣ�ֻ����һ�����˶��󼴿ɣ����Զ�����AI��
-- ע�⣺�Ƚ׶�֧�ֹ�������Ŀ�꣬�����ǽ�ɫ���ǹ��
-- @param obj �����ߣ�һ����ɫ�����ǵ���
-- @param way ������ʽ��ħ��������ͨ������1����ͨ������2�Ǽ��ܣ�3�ǵ��ߣ�4�Ƿ�������Ϊ2��3����������ӦΪ���߻���id���Ե��˶�����˵����Ҫ��д��һ���ΪAI���Զ������ж�
-- @param ... �������ߣ�����Ϊ������Ե��˶�����˵����Ҫ��д��һ��
-- ����ֵ��������, {Ŀ��1, Ŀ��2, ...}, {����˺�1, ����˺�2, ...}
function FightSession:DoAction(obj, way, ...)

    if #self.atk_list == 0 then
        self:RefreshRound()
    end

    if obj.is_character then
        -- ������Ʒ�б�
        Items:ClearQueue(obj)
        if way == 1 then
            -- ��ȡĿ����Ϣ
            local aim = {...}
            for k,v in pairs(aim) do
                if type(v) == 'number' then
                    aim[k] = self.enemy[v]
                end
            end

            -- ��¼�˺�
            local dmg = {}
            for k,v in pairs(aim) do
                local _dmg = obj:Attack(v, 1)
                v:Dec('hp', _dmg)
                table.insert(dmg, _dmg)
            end
            return obj, aim, dmg
        elseif way == 2 then
            -- ����
            local aim = {...}
            local spell_id = aim[1]
            table.remove(aim, 1)
            ;
        elseif way == 3 then
            -- ����
            --local aim = {...}
            --local item_id = aim[1]
            --table.remove(aim, 1)
            --Items:Use(obj, item_id, true)
            --ע�⣺�ֽ׶�ʹ����Ʒ�Ƕ�����Screen�����������Ҫ������ RunQueue
        elseif way == 4 then
            -- ����
        end
        -- Ӧ����Ʒ�б�
        Items:RunQueue(obj)
        if obj.is_character then
            obj:UpdateFightAttr()
        end
    else
        -- ������ͨ����
        -- ����ѡ��һ�����ŵ����Ŀ��
        local i = math.random(1, #data.chfight)
        while data.chfight[i]:GetAttr('hp') <= 0 do
            i = math.random(1, #data.chfight)
        end
        -- ��ʼ����
        local dmg = obj:Attack(data.chfight[i])
        -- �۳�Ѫ��
        data.chfight[i]:Dec('hp', dmg)
        -- ��������
        return obj, {data.chfight[i]}, {dmg}
    end
end

-- �����ϴ�ս�����棬ͬʱ���������ͷ�
-- ͬʱ���½�ɫ��Ϣ��ˢ��
function FightSession:GetLastFightResult()
    if not self.fightret then
        return
    end
    
    -- ʤ���ջ�
    if self.fightret == 2 then
        -- ��������
        local exp=0
        local loot = {}
        for k,v in pairs(self.enemy) do
            local _exp, _loot = v:Killed()
            exp = exp + _exp
            for _, _v in pairs(_loot) do
                if loot[_v] then
                    loot[_v] = loot[_v] + 1
                else
                    loot[_v] = 1
                end
            end
        end
        -- ��������
        local levelup = {}
        for k,v in pairs(data.chfight) do
            local lv = v:Inc('exp', exp)
            if lv then
                table.insert(levelup, {v, lv})
            end
        end
        -- ��õ���
        for k,v in pairs(loot) do
            Items:GetItem(k, v)
        end
        return self.fightret, exp, loot, levelup
    -- �����ͷ�
    elseif self.fightret == 1 then
        return self.fightret
    end
end
