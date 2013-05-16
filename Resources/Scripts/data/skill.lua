
skills = {
    -- 名字，          条件,     消耗,   数学描述， 技能说明
    {'卡尔萨斯之化身',   {lt={}, eq={}, gt={}}, {mp=300},   {{need_cast=true,  action_on=1,  change={level=999}, change_scale={hp_max=-0.7}, delay=3, round=999, each_round=false,}}, '卡尔萨斯之化身，奥术的至高成果，能以凡人之躯纂夺神明之职。'}, -- 1
}

skill = {}
function skill.can_cast(ch, skl)
    local need = skl[3]
    local ret = false

    for k,v in pairs(need) do
        if v > ch[k] then
            return false
        end
    end
    return true
end

function skill.cast(ch, skl, enm)
    
end
