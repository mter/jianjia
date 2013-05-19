
-- 装备部位 id
-- 1头部、2衣服、3手套、4腰带、5鞋子、6饰品

item_prefix = {
    {'强力的', change={}, scale={}, spell={}}, -- 1
}

items = {
    -- 名字，          条件,
    {_'眷恋',         id=1, req={ge={level=5}},  equip={pos=1, change={}, scale={hp_max=0.1}}, use=nil, spell=nil, prefix={}, txt=_'可以自由变化大小的双手重剑。'}, -- 1
    {_'勇士短刀',      id=2, equip={pos=1, change={}, scale={}}, use=nil, spell=nil, prefix={{0.1}, {1}}, txt=_'只有勇者才能拥有的短刀!'}, -- 2
    {_'德玛西亚之力',   id=3, txt=_'从前，有一个草丛……'},
    {_'初级生命药剂',   id=4, use={change={hp=150}}, txt='初级生命药剂，回复 150 点HP。'},
}

Items = Class()

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

-- 玩家获得物品
-- @param item 物品的id或者描述物品的表
-- @param num 获得该物品的数量
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

-- 是否是一件装备物品
-- 说明：若可以装备，则为装备物品
function Items:IsEquipment(item)
    return Items:_getitem(item).equip
end

-- 是否是消耗品
-- 说明：若该物品可以被使用，定义为消耗品
function Items:IsConsumable(item)
    return Items:_getitem(item).use
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
