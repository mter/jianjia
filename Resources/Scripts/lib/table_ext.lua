
-- table_ext.lua
-- 对 table 的部分扩展

function table.empty(t)
    return _G.next(t) == nil
end

function table.get_next(t, key)
    local flag
    for k, v in pairs(t) do
        if flag then
            return k, v
        end
        if key == k then
            flag = true
        end
    end
end

function table.get_prev(t, key)
    local lastk, lastv
    for k, v in pairs(t) do
        if key == k then
            return lastk, lastv
        end
        lastk, lastv = k, v
    end
end

function table.get_first(t)
    return _G.next(t)
end

function table.get_last(t)
    local lastk, lastv
    for k, v in pairs(t) do
        lastk, lastv = k, v
    end
    return lastk, lastv
end

-- 根据位置查找不按顺序存放的key,value
-- 准备废弃
function table.find(t, p)
    local i = 1;
    for k, v in pairs(t) do
        if i == p then
            return k, v
        end
        i = i + 1
    end
    return nil
end

--table的长度
-- 准备废弃
function table.length(t)
    local i = 0
    for k, v in pairs(t) do
        i = i + 1
    end
    return i
end

-- 根据表1中存档的概率，在剩下几张表中进行随机，取得随机的项目
-- 返回值有可能为空（没有随机到），支持变长参数
-- t1: {0.1, 0.2225, 0.3} -> 加起来不得大于1
function table.random(t1, ...)

    local params = {...}

    local function get_item_at_pos(i)
        --print(i)
        local oldval = 0
        local newval = 0
        for k,v in pairs(params) do
            newval = oldval + #v
            if i > oldval and i <= newval then
                return v[i - oldval]
            end
            oldval = newval
        end
    end

    local maxvalue = 10000
    local value = 0
    for k,v in pairs(t1) do
        value = value + v*maxvalue
    end
    if value > maxvalue then
        print(_'错误：table.random 遇到问题，传入值给出的概率加起来大于1。')
    end

    local oldval = 0
    local newval = 0
    local _rand = math.random(1, maxvalue)

    for i=1,#t1 do
        newval = oldval + t1[i] * maxvalue
        if _rand > oldval and _rand <= newval then
            -- 如果找到了，那么返回
            return get_item_at_pos(i)
        end
        oldval = newval
    end
end
