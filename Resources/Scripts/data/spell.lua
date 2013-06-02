
spells = {
    --id, 名字，                      消耗,            数学描述， 技能说明
    {_'卡尔萨斯之化身',         id=1,  cost={mp=300},   effect={{need_cast=true, action_on=1, change={level=999}, scale={hp_max=0.3}, delay=3, round=999, each_round=false,}}, txt='奈瑟时代的奥术至高成果，以凡人之躯纂夺神明之职。' },
    {_'初级治疗术',            id=2,  cost={mp=10},    effect={{need_cast=true, action_on=1, scale={hp=0.3}, delay=0, round=999, each_round=false,}}, txt='回复生命值 30%'},
    {_'防御',                 id=3,                   effect={{need_cast=true, action_on=1, scale={defense=0.2}, round=1, lost=true}}, txt='防御'},
}

Spell = Class()
Spell.cast_list = {}

-- 内部方法：根据id获取物品table，若传入的本身就是物品table，则原样返回。
--         这么做的原因是有时需要传id查物品，有时会直接传物品table
function Spell:_getitem(id_or_table)
    local _type = type(id_or_table)
    if _type == 'table' then
        return id_or_table
    elseif _type == 'number' then
        return spells[id_or_table]
    end
end

-- 重置队列，在一场战斗开始前或结束后调用。
function Spell:ResetQueue()
    self.cast_list = {}
end

-- 执行队列，当前角色回合开始并作出操作后调用
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

-- 清理并更新队列，当前角色回合开始前调用
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

-- 使用技能
function Spell:Cast(ch, spl, level, in_fight)
    local in_fight = in_fight or false
    local spl = self:_getitem(spl)

    -- 若此物品不能在战斗中使用，则返回 false
    if spl.fight == in_fight then
        return false, '这件物品只能在战斗中使用'
    end
    -- 若此物品具有buff效果，buff列表中存在则延长其时间，不存在则创建
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
    -- 不在战斗中的话 直接执行队列并更新数据
    if not in_fight then
        Items:RunQueue(ch)
        ch:UpdateFightAttr()
    end
    return true
end

-- 是否达到释放条件（未完成）
-- 说明：会对角色和怪物进行分别处理
function Spell:CanCast(obj, spl, level)

    if type(spl) == 'number' then
        spl = spells[spl]
    end

    local req = spl.req
    local cost = spl.cost

    -- 若是一个角色，判断所有属性、要求以及技能消耗
    if obj.is_character then
        -- 判断属性和要求
        -- return false, 1, '没有达到使用技能要求'

        -- 判断消耗
        for k, v in pairs(cost) do
            if v > obj:GetAttr(k) then
                return false, 2, '无法满足技能消耗'
            end
        end
    else
        -- 若不是角色，判断所有要求和技能消耗
        -- 判断要求

        -- 判断消耗
        for k, v in pairs(cost) do
            if v > obj:GetAttr(k) then
                return false, 2, '无法满足技能消耗'
            end
        end
    end

    return true
end
