
spells = {
    --id, 名字，                              条件,      消耗,   数学描述， 技能说明
    { _'卡尔萨斯之化身',id=1,  req={ lt = {}, eq = {}, gt = {} }, cost={ mp = 300 }, effect={ { need_cast = true, action_on = 1, change = { level = 999 }, scale = { hp_max = 0.3 }, delay = 3, round = 999, each_round = false, } }, txt='卡尔萨斯之化身，奥术的至高成果，能以凡人之躯纂夺神明之职。' },
    { _'初级治疗术', id=2,  req={ lt= {}, eq = {}, gt = {} }, cost={ mp = 10 }, effect={ { need_cast = true, action_on = 1, change = {}, scale = { hp = 0.3, atk_min = 1, atk_min = 1 }, delay = 0, round = 999, each_round = false, } }, txt='回复生命值 30%' },
}

Spell = Class()

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

--释放技能
function Spell:Cast(from, to, spl)
    local result = {}
    --扣除所需
    for k, v in pairs(spl.cost) do
        from:Dec(k, v)
    end
--    local con = spl.effect
    --更改属性
    for k, v in pairs(spl.effect[1].change) do
        local r = to:GetAttr(k) - v
        to:Inc(k, r)
        result[k] = r
    end
    --增益属性
    for k, v in pairs(spl.effect[1].scale) do
        local r = to:GetAttr(k) * v
        to:Inc(k, r)
        result[k] = r
    end
    return result
end
