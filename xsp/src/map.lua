local map = {}
--  -1 障碍物  9 舰队  0  空位 5 boss
map[6] = {
	n1 =  {
	}
}
map.event = {
	c1 = {
		{-1,-1,-1,0,0,-1,-1},
		{9,0,0,0,0,-1,-1},
		{0,0,0,0,0,0,0},
		{9,0,0,-1,0,0,5}
	}
}

return map