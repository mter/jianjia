
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

--深度复制
function table.copy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[table.copy(orig_key)] = table.copy(orig_value)
        end
        setmetatable(copy, table.copy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

--根据位置查找不按顺序存放的key,value
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
function table.length(t)
    local i = 0
    for k, v in pairs(t) do
        i = i + 1
    end
    return i
end
