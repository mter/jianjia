
-- table_ext.lua
-- 对 table 的部分扩展

function table.empty(t)
    return _G.next( t ) == nil
end

function table.get_next(t, key)
	local flag
	for k,v in pairs(t) do
		if flag then
			return k,v
		end
		if key == k then
			flag = true
		end
	end
end

function table.get_prev(t, key)
	local lastk, lastv
	for k,v in pairs(t) do
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
	for k,v in pairs(t) do
		lastk, lastv = k, v
	end
	return lastk, lastv
end
