
-- 装备部位 id
-- 1头部、2衣服、3手套、4腰带、5鞋子、6饰品

item_prefix = {
    {'强力的', change={}, scale={}, spell={}}, -- 1
}

items = {
    -- 名字，            条件,
    {_'眷恋',           id=1, req={ge={level=5}},  equip={pos=1, change={}, scale={hp_max=0.1}}, use=nil, spell=nil, prefix={}, txt=_'可以自由变化大小的双手重剑。'}, -- 1
    {_'勇士短刀',        id=2, equip={pos=1, change={}, scale={}}, prefix={{0.1}, {1}}, txt=_'只有勇者才能拥有的短刀!'}, -- 2
    {_'德玛西亚之力',     id=3, txt=_'从前，有一个草丛……'},
    {_'初级生命药剂',     id=4, use={change={hp=150}}, txt='回复 150 点HP。'},  -- delay = 0, round = 3, each_round = false, lost = true
    {_'初级魔法药剂',     id=5, use={change={mp=150}}, txt='回复 150 点MP。'},
    {_'初级缓慢回复药剂',  id=6, use={change={hp=70}, round=3, each_round=true, fight=true, is_buff=true}, txt='每回合回复 70 点HP，持续3回合。重复使用效果不叠加，但时间会延长。只能在战斗中使用。'},
}

-- 凡是可以重复叠加的物品都会进入buff列表

Items = Class()
Items.cast_list = {}

-- 内部方法：根据id获取物品table，若传入的本身就是物品table，则原样返回。
--         这么做的原因是有时需要传id查物品，有时会直接传物品table
function Items:_getitem(id_or_table)
    local _type = type(id_or_table)
    if _type == 'table' then
        return id_or_table
    elseif _type == 'number' then
        return items[id_or_table]
    end
end

-- 重置队列，在一场战斗开始前或结束后调用。
function Items:ResetQueue()
    self.cast_list = {}
end

-- 执行队列，当前角色回合开始并作出操作后调用
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

-- 清理并更新队列，当前角色回合开始前调用
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

-- 使用物品
function Items:Use(ch, item, in_fight)
    local in_fight = in_fight or false
    local item = self:_getitem(item)
    -- 若此物品是一个消耗品
    if self:IsConsumable(item) then
        -- 若此物品不能在战斗中使用，则返回 false
        if item.use.fight == in_fight then
            return false, '这件物品只能在战斗中使用'
        end
        -- 若此物品具有buff效果，buff列表中存在则延长其时间，不存在则创建
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
        -- 不在战斗中的话 直接执行队列并更新数据
        if not in_fight then
            Items:RunQueue(ch)
            ch:UpdateFightAttr()
        end
    -- 若此物品是一件装备
    elseif self:IsEquipment(item) then
        if in_fight then
           return false, '战斗中无法更换装备'
        end
        ch:Equip(item.id)
    -- 若只是一件“物品”
    elseif self:IsItem(item) then
        return false, '无法使用这件物品'
    end
    return true
end

-- 玩家获得物品
-- @param item 物品的id或者描述物品的表
-- @param num 获得该物品的数量
-- 物品存放： data.items = {{物品id1, 物品数量}, {物品id2, 物品数量}}
function Items:GetItem(item, num)
    data.items = data.items or {}
    num = num or 1
    local item = self:_getitem(item)
    if item then
        local is_equip = Items:IsEquipment(item) or Items:IsItem(item)
        -- 如果是一件装备或物品，那么装备/物品永远占一格，不会堆叠
        if is_equip then
            for i=1,num do
                table.insert(data.items, {item.id, 1})
            end
        -- 如果是消耗品，那么可以堆叠
        else
            -- 如果存在于列表中，增加数量
            for k,v in pairs(data.items) do
                if v[1] == item.id then
                    v[2] = v[2] + num
                    return
                end
            end
            -- 若不存在，直接插入
            table.insert(data.items, {item.id, num})
        end
    end
end

-- 玩家失去物品
-- @param item 物品的id或者描述物品的表
-- @param num 失去该物品的数量，如果这个数目大于玩家拥有的数目，函数就会失败
-- @retval 若执行成功 返回现在的物品数量，失败返回 nil
function Items:LostItem(item, num)
    data.items = data.items or {}
    num = num or 1
    local item = self:_getitem(item)
    if item then
        -- 检查是否存在于装备列表中
        for k,v in pairs(data.items) do
            if v[1] == item.id then
                if v[2] >= num then
                    v[2] = v[2] - num
                    local ret = v[2]
                    if v[2] == 0 then
                        -- 如果数量为0，从物品列表中移除
                        table.remove(data.items, k)
                    end
                    return ret
                end
            end
        end
    end
    return nil, '物品数量不足！'
end

-- 是否是一件装备物品
-- 说明：若可以装备，则为装备物品
function Items:IsEquipment(item)
    return Items:_getitem(item).equip
end

-- 是否是消耗品
-- 说明：若该物品可以被使用，定义为消耗品
function Items:IsConsumable(item)
    return self:_getitem(item).use
end

-- 是否是一个“物品”
-- 说明：若该物品不能装备，同时无法作为消耗品使用，视为“物品”
function Items:IsItem(item)
    local i = Items:_getitem(item)
    return (not i.equip) and (not i.use)
end

-- 检查是否能装备或使用某物品
-- 返回值：第一个为 true 或 false，第二个为原因
function Items:CanUse(ch, item)
    local i = Items:_getitem(item)
    if not i then
        return false, _'无法找到对应物品'
    end

    -- 条件：大于等于，当遇到小于情况时返回错误
    if i.ge then
        for k,v in pairs(i.ge) do
            if v < ch[k] then
                return false, _'人物属性不能达到要求'
            end
        end        
    end
    
    -- 条件：大于，当遇到小于等于情况时返回错误
    if i.gt then
        for k,v in pairs(i.gt) do
            if v <= ch[k] then
                return false, _'人物属性不能达到要求'
            end
        end
    end

    -- 条件：等于，遇到不等于时返回错误
    if i.eq then
        for k,v in pairs(i.eq) do
            if v ~= ch[k] then
                return false, _'人物属性不能达到要求'
            end
        end
    end

    -- 条件：相等，遇到不等于时返回错误
    if i.eq then
        for k,v in pairs(i.eq) do
            if v ~= ch[k] then
                return false, _'人物属性不能达到要求'
            end
        end
    end

    -- 条件：小于，遇到大于等于时返回错误
    if i.lt then
        for k,v in pairs(i.lt) do
            if v >= ch[k] then
                return false, _'人物属性超过要求'
            end
        end
    end

    -- 条件：小于等于，遇到大于时返回错误
    if i.le then
        for k,v in pairs(i.le) do
            if v > ch[k] then
                return false, _'人物属性超过要求'
            end
        end
    end
    
    return true, _'可以使用'
end

Items.CanEquip = Items.CanUse
