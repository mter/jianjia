
enemy_prefix = {
	-- 名字,  挑战等级增加, 经验百分比, hp百分比, mp百分比, 伤害百分比, 防御百分比, 护甲百分比, 抗性百分比, 技能列表增加
	{'坚韧',             1,       1.2,       1.5,        1,          1,        1.3,        1.3,        1.3,           {}}, -- 1
}

enemy_template = {
	-- 名字, 挑战等级增加, 经验百分比, hp百分比, mp百分比, 伤害百分比, 防御百分比, 护甲百分比, 抗性百分比, 技能列表增加
	{'普通',           0,          1,        1,        1,          1,         1,           1,          1,          {}}, -- 1
	{'精英',           1,       1.25,     1.25,     1.25,       1.15,      1.10,        1.10,       1.10,          {}}, -- 2
	{'英雄',           2,       1.50,     1.35,     1.35,       1.30,      1.20,        1.20,       1.20,          {}}, -- 3
	{'首领',           3,       1.75,     1.45,     1.45,       1.45,      1.30,        1.30,       1.30,          {}}, -- 4
	{'特殊',           3,       4.15,        1,        1,          1,         1,           1,          1,          {}}, -- 5
}

templ_set = {
	newbie = {{0.85, 0.15}, {enemy_template[1], enemy_template[2]}},
}

-- 攻击类型：1近战，2远程，3魔法

enemys = {
	--1名字,2挑战等级,   3HP,    4MP, 5攻击类型,6最小伤害,7最大伤害,8防御, 9抗性,10护甲,  11前缀集合,  12       模板集合, 13技能列表, 14说明
	{'碧油鸡',      1,   15,    225,         1,         4,       6,   12,    10,     8,          {},   templ_set.newbie,         {}, '一只绿油油的鸡，总在隐蔽的地方出现。但有时也在大庭广众之下游荡'}, -- 1
}

enemy_set = {
	newbie = {1},
}

enemy = {}
function enemy.exp(level)
	return math.ceil(50*level*(1+level/30)^(1+level/2))
end

function enemy.attack(enm, ch, way)
	-- way 1 物理
	-- way 2 远程
	-- way 3 魔法
	local way = way or 1
	local def
	if way == 1 then
		def = ch.defense
	else
		def = ch.resist
	end
	return math.ceil((math.random(enm[6], enm[7]) + math.floor(enm[7] - enm[6]) - def/5) * (1-ch.armor ^ 0.5 / 35))
end
