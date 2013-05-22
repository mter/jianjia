spells = {
    --id, 名字，                              条件,      消耗,   数学描述， 技能说明
    { _'卡尔萨斯之化身A',id=1,  condition={ lt = {}, eq = {}, gt = {} }, loss={ mp = 300 }, describe={ { need_cast = true, action_on = 1, change = { level = 999 }, change_scale = { hp_max = 0.3 }, delay = 3, round = 999, each_round = false, } }, txt='1卡尔萨斯之化身，奥术\n的至高成果，能以凡人\n之躯纂夺神明之职。' }, -- 1
    { _'卡尔萨斯之化身B',id=2,  condition={ lt = {}, eq = {}, gt = {} }, loss={ mp = 100 }, describe={ { need_cast = true, action_on = 1, change = { level = 999 }, change_scale = { hp_max = 0.3 }, delay = 3, round = 999, each_round = false, } }, txt='2卡尔萨斯之化身，奥术\n的至高成果，能以凡人\n之躯纂夺神明之职。' }, -- 1
    { _'卡尔萨斯之化身C',id=3,  condition={ lt = {}, eq = {}, gt = {} }, loss={ mp = 300 }, describe={ { need_cast = true, action_on = 1, change = { level = 999 }, change_scale = { hp_max = 0.3 }, delay = 3, round = 999, each_round = false, } }, txt='3卡尔萨斯之化身，奥术\n的至高成果，能以凡人\n之躯纂夺神明之职。' }, -- 1
    { _'卡尔萨斯之化身D',id=4,  condition={ lt = {}, eq = {}, gt = {} }, loss={ mp = 300 }, describe={ { need_cast = true, action_on = 1, change = { level = 999 }, change_scale = { hp_max = 0.3 }, delay = 3, round = 999, each_round = false, } }, txt='4卡尔萨斯之化身，奥术\n的至高成果，能以凡人\n之躯纂夺神明之职。' }, -- 1
    { _'卡尔萨斯之化身E',id=5,  condition={ lt = {}, eq = {}, gt = {} }, loss={ mp = 300 }, describe={ { need_cast = true, action_on = 1, change = { level = 999 }, change_scale = { hp_max = 0.3 }, delay = 3, round = 999, each_round = false, } }, txt='5卡尔萨斯之化身，奥术\n的至高成果，能以凡人\n之躯纂夺神明之职。' }, -- 1
    { _'卡尔萨斯之化身F',id=6,  condition={ lt = {}, eq = {}, gt = {} }, loss={ mp = 300 }, describe={ { need_cast = true, action_on = 1, change = { level = 999 }, change_scale = { hp_max = 0.3 }, delay = 3, round = 999, each_round = false, } }, txt='6卡尔萨斯之化身，奥术\n的至高成果，能以凡人\n之躯纂夺神明之职。' }, -- 1
    { _'卡尔萨斯之化身G',id=7,  condition={ lt = {}, eq = {}, gt = {} }, loss={ mp = 300 }, describe={ { need_cast = true, action_on = 1, change = { level = 999 }, change_scale = { hp_max = 0.3 }, delay = 3, round = 999, each_round = false, } }, txt='7卡尔萨斯之化身，奥术\n的至高成果，能以凡人\n之躯纂夺神明之职。' }, -- 1
    { _'卡尔萨斯之化身H',id=8,  condition={ lt = {}, eq = {}, gt = {} }, loss={ mp = 300 }, describe={ { need_cast = true, action_on = 1, change = { level = 999 }, change_scale = { hp_max = 0.3 }, delay = 3, round = 999, each_round = false, } }, txt='8卡尔萨斯之化身，奥术\n的至高成果，能以凡人\n之躯纂夺神明之职。' }, -- 1
    { _'加血',id=9,  condition={ lt= {}, eq = {}, gt = {} }, loss={ mp = 100 }, describe={ { need_cast = true, action_on = 1, change = {}, change_scale = { hp = 0.3, atk_min = 1, atk_min = 1 }, delay = 0, round = 999, each_round = false, } }, txt='加血30%' },
}

Spell = Class()

-- 是否达到释放条件（未完成）
-- 说明：会对角色和怪物进行分别处理
function Spell:CanCast(obj, spl)
    local req = spl.condition
    local cost = spl.loss

    -- 若是一个角色，判断所有属性、要求以及技能消耗
    if obj.is_character then
        -- 判断属性和要求

        -- 判断消耗
        for k, v in pairs(cost) do
            if v > obj:GetAttr(k) then
                return false
            end
        end
    else
        -- 若不是角色，判断所有要求和技能消耗
        -- 判断要求

        -- 判断消耗
        for k, v in pairs(cost) do
            if v > obj:GetAttr(k) then
                return false
            end
        end
    end

    return true
end

--释放技能
function Spell:Cast(from, to, spl)
    local result = {}
    --扣除所需
    for k, v in pairs(spl.loss) do
        from:Dec(k, v)
    end
--    local con = spl.describe
    --更改属性
    for k, v in pairs(spl.describe[1].change) do
        local r = to:GetAttr(k) - v
        to:Inc(k, r)
        result[k] = r
    end
    --增益属性
    for k, v in pairs(spl.describe[1].change_scale) do
        local r = to:GetAttr(k) * v
        to:Inc(k, r)
        result[k] = r
    end
    return result
end
