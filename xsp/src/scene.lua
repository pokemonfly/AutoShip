local module = {}

module['main'] = {
	name = '主界面',
	route = {
		['event'] = {695,117,813,239}
	},
	check = function ()
		-- 油上角的 +号
		local	pointA = findColors({1370, 18, 1429, 66},
			"0|0|0xf7d339,0|-5|0xffd739,9|-7|0x424142,9|3|0xf7cf39,11|13|0x424142,0|12|0xf7c331,-11|12|0x424142,-18|15|0x424542",
			80, 0, 0, 0)
		local  pointB = findColors({979, 400, 1185, 506}, 
			"0|0|0x109aef,11|0|0x31dbef,50|2|0xefaa08,71|1|0xefaa10",
			80, 0, 0, 0)
		
		return #pointA  ~= 0  and  #pointB  ~= 0
	end
}


module['event'] = {
	name = '活动出击',
	route = {
		['C1'] = {365,222,645,289}
	},
	check = function ()
		return isBattle()
	end
}

module['battleComfirm'] = {
	name = '出击确认',
	route = {
		['go'] = {928,496,1166,585}
	},
	check = function ()
		return findImg ("battleComfirm.png", 928,496,1166,585);
	end
}
module['fleetSelect'] = {
	name = '舰队选择',
	route = {
		['go'] = {1034,601,1282,687}
	},
	check = function ()
		return findImg ("shipComfirm.png", 104,99,360,184);
	end,
	afterCallback = function (opt)
		if opt and opt.round then
			--  出击次数
			opt.round = 0
		end 
	end
}
-- 战斗网格地图
module['battleMap'] = {
	name = '出击中',
	check = function ()
		--屏幕下方3色按钮
		local ret=  findColor({733, 690, 1331, 796}, 
			"0|0|0xc60000,251|-9|0x424142,498|-7|0xde7508,-150|-61|0x210c08",
			80, 0, 0, 0)
		return ret > -1
	end
}
module['farmation'] = {
	name = '编队',
	route = {
		['go'] = {1036,663,1334,762}
	},
	check = function ()
		return findImg ("farmation.png", 87,3,245,56);
	end,
	afterCallback = function (opt)
		if opt and opt.round then
			--  出击次数
			opt.round  = opt.round + 1
			return opt.round
		end 
	end
}
module['win'] = {
	name = '战斗结束',
	route = {
		['go'] = {1155,660,1348,716}
	},
	check = function ()
		local 	pointA = findColors({1340, 389, 1355, 404},
			"0|0|0xa56500,3|3|0xa56500,6|6|0xa56500,9|9|0xa56500",
			95, 0, 0, 0)
		local	pointB = findColors({541, 130, 901, 207}, 
			"0|0|0xf7b673,11|25|0xffb252,39|27|0xffbe4a,83|27|0xf7d78c,103|9|0xffe38c,162|26|0xfffbe7,195|14|0xffef5a,246|27|0xffffe7,286|1|0xffba73",
			80, 0, 0, 0)
		local  pointC = findColors({23, 668, 102, 740}, 
			"0|0|0x42d3e7,-1|-16|0xf7f7f7,19|-18|0xffffff,33|-19|0xefffff,44|4|0x42d3e7,44|17|0xcecfce,26|29|0xadaead,2|27|0xa5a2a5,-3|18|0xcecfce",
			80, 0, 0, 0)
		
		return  #pointA ~= 0 or #pointB ~= 0 or #pointC ~= 0
	end
}
module['fighting'] = {
	name = '战斗中',
	check = function ()
		 local point = findColors({1323, 13, 1426, 90},
			"0|0|0xf7f3f7,6|10|0xd6d3d6,15|20|0x393839,23|28|0xdedfde,31|34|0x313431,36|45|0xdedfde,44|4|0xe7e3e7,31|16|0x212421,4|35|0xdedfde,-2|49|0xdedfde",
			80, 0, 0, 0)
		return  #point ~= 0
	end
}
module['ambush'] = {
	name = '埋伏',
	route = { ['go'] = {932,400,1123,458}},
	check = function ()
		local     point = findColors({629, 362, 1028, 481},
			"0|0|0xffdb42,13|14|0xffcf39,28|36|0xffaa10,40|49|0xffb218,55|36|0xffa618,151|-7|0xe7e7e7,162|10|0xdedfde,173|23|0xbdbabd,189|37|0xc6bebd,202|51|0xd6d3ce",
			80, 0, 0, 0)
		return  #point ~= 0
	end
}
module['info'] = {
	name = '提示',
	route = { ['go'] = {814,528,952,577}},
	check = function ()
		local     point = findColors({517, 496, 872, 611},
			"0|0|0xce9a21,20|15|0xf7d342,34|40|0xf7aa18,51|56|0xf7a210,77|56|0xf7a210,112|55|0xf7a210,149|54|0xf7a210,170|39|0xf7aa21,184|24|0xf7cb39,207|14|0x9c4908",
			80, 0, 0, 0)
		return  #point ~= 0
	end
}


function isBattle ()
	return findImg("battle.png", 87,0,244,54);
end

findImg = function (img ,x1, y1, x2, y2)
	local x, y = findImageInRegionFuzzy(img, 80, x1, y1, x2, y2, 0);
	return x ~= -1 and y ~= -1
end
return module
