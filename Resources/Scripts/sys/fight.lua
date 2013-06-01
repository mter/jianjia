
FightSession = Class(function(self, random_enm_lst, enm_lst, maxnum)
    -- 获得初始信息
    if not random_enm_lst then
        print('没有随机敌人列表， FightSession 初始化失败！')
        return
    end

    -- 初始化敌人数量，敌人数量不会超过角色总数 + 1
    local maxnum = maxnum or #data.ch + 1
    if maxnum > 4 then
        maxnum = 4
    end
    local num = math.random(1, maxnum)
    self.enemy = {}
    
    -- 构造固定敌人
    if enm_lst then
        for k,v in pairs(enm_lst) do
            table.insert(self.enemy, Enemy(enemys[v]))
        end
    end

    -- 随机生成敌人对象并加入列表
    for i = #self.enemy+1, num do
        local index = math.random(1, #random_enm_lst)
        table.insert(self.enemy, Enemy(enemys[random_enm_lst[index]]))
    end
    
    -- 初始化出场角色
    data.chfight = {}
    for k,v in pairs(data.ch) do
        if v:GetAttr('hp') > 0 then
            table.insert(data.chfight, v)
        end
    end
    
    -- 保存索引
    for k,v in pairs(self.enemy) do
        v.index = k
    end

    for k,v in pairs(data.chfight) do
        v.index = k
    end

    -- 完成并初始化变量
    self.fightret = nil
    self.turn = 0   -- 当前轮数
    self.atk_list = {} -- 行动顺序
    self:RefreshRound() -- 开始第一回合

end)


-- 新回合开始
-- 对行动顺序进行排列
-- 内部函数 一般不需要调用
function FightSession:RefreshRound()
    -- 刷新攻击顺序
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
        -- 行动值高的会首先动作，相同行动值就看运气了
        return a:GetAttr('spd') > b:GetAttr('spd')
    end)    
end

-- 获得下一个攻击者
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

-- 检查战斗是否结束，胜利或是失败。
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

-- 进行回合操作
-- 如果是角色进行攻击，那么需要填写全部参数，如果是敌人，只传入一个敌人对象即可，会自动调用AI。
-- 注意：先阶段支持攻击单体目标，无论是角色还是怪物。
-- @param obj 攻击者，一个角色或者是敌人
-- @param way 攻击方式，魔法或者普通攻击，1是普通攻击，2是技能，3是道具，4是防御，若为2或3第三个参数应为道具或技能id，对敌人对象来说不需要填写这一项，因为AI会自动作出判断
-- @param ... 被攻击者，可以为多个，对敌人对象来说不需要填写这一项
-- 返回值：攻击者, {目标1, 目标2, ...}, {造成伤害1, 造成伤害2, ...}
function FightSession:DoAction(obj, way, ...)

    if #self.atk_list == 0 then
        self:RefreshRound()
    end

    if obj.is_character then
        -- 更新物品列表
        Items:ClearQueue(obj)
        if way == 1 then
            -- 获取目标信息
            local aim = {...}
            for k,v in pairs(aim) do
                if type(v) == 'number' then
                    aim[k] = self.enemy[v]
                end
            end

            -- 记录伤害
            local dmg = {}
            for k,v in pairs(aim) do
                local _dmg = obj:Attack(v, 1)
                v:Dec('hp', _dmg)
                table.insert(dmg, _dmg)
            end
            return obj, aim, dmg
        elseif way == 2 then
            -- 技能
            local aim = {...}
            local spell_id = aim[1]
            table.remove(aim, 1)
            ;
        elseif way == 3 then
            -- 道具
            --local aim = {...}
            --local item_id = aim[1]
            --table.remove(aim, 1)
            --Items:Use(obj, item_id, true)
            --注意：现阶段使用物品是独立的Screen，所以这边主要作用是 RunQueue
        elseif way == 4 then
            -- 防御
        end
        -- 应用物品列表
        Items:RunQueue(obj)
        if obj.is_character then
            obj:UpdateFightAttr()
        end
    else
        -- 怪物普通攻击
        -- 首先选择一个活着的玩家目标
        local i = math.random(1, #data.chfight)
        while data.chfight[i]:GetAttr('hp') <= 0 do
            i = math.random(1, #data.chfight)
        end
        -- 开始攻击
        local dmg = obj:Attack(data.chfight[i])
        -- 扣除血量
        data.chfight[i]:Dec('hp', dmg)
        -- 返回数据
        return obj, {data.chfight[i]}, {dmg}
    end
end

-- 计算上次战斗收益，同时进行死亡惩罚
-- 同时更新角色信息并刷新
function FightSession:GetLastFightResult()
    if not self.fightret then
        return
    end
    
    -- 胜利收获
    if self.fightret == 2 then
        -- 计算收益
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
        -- 经验增加
        local levelup = {}
        for k,v in pairs(data.chfight) do
            local lv = v:Inc('exp', exp)
            if lv then
                table.insert(levelup, {v, lv})
            end
        end
        -- 获得掉落
        for k,v in pairs(loot) do
            Items:GetItem(k, v)
        end
        return self.fightret, exp, loot, levelup
    -- 死亡惩罚
    elseif self.fightret == 1 then
        return self.fightret
    end
end
