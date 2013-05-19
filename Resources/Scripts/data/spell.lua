
spells = {
    --id, 名字，                              条件,      消耗,   数学描述， 技能说明
    {1,'卡尔萨斯之化身A',   {lt={}, eq={}, gt={}}, {mp=300},   {{need_cast=true,  action_on=1,  change={level=999}, change_scale={hp_max=0.3}, delay=3, round=999, each_round=false,}}, '1卡尔萨斯之化身，奥术\n的至高成果，能以凡人\n之躯纂夺神明之职。'}, -- 1
    {2,'卡尔萨斯之化身B',   {lt={}, eq={}, gt={}}, {mp=100},   {{need_cast=true,  action_on=1,  change={level=999}, change_scale={hp_max=0.3}, delay=3, round=999, each_round=false,}}, '2卡尔萨斯之化身，奥术\n的至高成果，能以凡人\n之躯纂夺神明之职。'}, -- 1
    {3,'卡尔萨斯之化身C',   {lt={}, eq={}, gt={}}, {mp=300},   {{need_cast=true,  action_on=1,  change={level=999}, change_scale={hp_max=0.3}, delay=3, round=999, each_round=false,}}, '3卡尔萨斯之化身，奥术\n的至高成果，能以凡人\n之躯纂夺神明之职。'}, -- 1
    {4,'卡尔萨斯之化身D',   {lt={}, eq={}, gt={}}, {mp=300},   {{need_cast=true,  action_on=1,  change={level=999}, change_scale={hp_max=0.3}, delay=3, round=999, each_round=false,}}, '4卡尔萨斯之化身，奥术\n的至高成果，能以凡人\n之躯纂夺神明之职。'}, -- 1
    {5,'卡尔萨斯之化身E',   {lt={}, eq={}, gt={}}, {mp=300},   {{need_cast=true,  action_on=1,  change={level=999}, change_scale={hp_max=0.3}, delay=3, round=999, each_round=false,}}, '5卡尔萨斯之化身，奥术\n的至高成果，能以凡人\n之躯纂夺神明之职。'}, -- 1
    {6,'卡尔萨斯之化身F',   {lt={}, eq={}, gt={}}, {mp=300},   {{need_cast=true,  action_on=1,  change={level=999}, change_scale={hp_max=0.3}, delay=3, round=999, each_round=false,}}, '6卡尔萨斯之化身，奥术\n的至高成果，能以凡人\n之躯纂夺神明之职。'}, -- 1
    {7,'卡尔萨斯之化身G',   {lt={}, eq={}, gt={}}, {mp=300},   {{need_cast=true,  action_on=1,  change={level=999}, change_scale={hp_max=0.3}, delay=3, round=999, each_round=false,}}, '7卡尔萨斯之化身，奥术\n的至高成果，能以凡人\n之躯纂夺神明之职。'}, -- 1
    {8,'卡尔萨斯之化身H',   {lt={}, eq={}, gt={}}, {mp=300},   {{need_cast=true,  action_on=1,  change={level=999}, change_scale={hp_max=0.3}, delay=3, round=999, each_round=false,}}, '8卡尔萨斯之化身，奥术\n的至高成果，能以凡人\n之躯纂夺神明之职。'}, -- 1
    {9,'加血',   {lt={}, eq={}, gt={}}, {mp=100},   {{need_cast=true,  action_on=1,  change={}, change_scale={hp=0.3,atk_min=1,atk_min=1}, delay=3, round=999, each_round=false,}}, '加血30%'},
}

Spell = Class()

-- 是否达到释放条件（未完成）
-- 说明：会对角色和怪物进行分别处理
function Spell:CanCast(obj, spl)
    local req = spl[3]
    local cost = spl[4]

    -- 若是一个角色，判断所有属性、要求以及技能消耗
    if obj.is_character then
        -- 判断属性和要求
        
        -- 判断消耗
        for k,v in pairs(cost) do
            if v > obj:GetAttr(k) then
                return false
            end
        end
    else
    -- 若不是角色，判断所有要求和技能消耗
        -- 判断要求
        
        -- 判断消耗
        for k,v in pairs(cost) do
            if v > obj:GetAttr(k) then
                return false
            end
        end
    end
    
    return true
end

--释放技能
function Spell:Cast(from, to, spl)
    ;
end
