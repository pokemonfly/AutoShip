local utils = require('utils')
local battle = {
	lastTar,
	_ct = 0,
	round = 0
}

-- 去重
function mergeTarget ( tar, arr, x, y, isBoss)
	local step = 50
	for key, val in pairs(arr) do
		local obj = {
			x = val.x + x,
			y = val.y + y
		}
		if (isBoss)  then
			obj.isBoss = true
		end 
		local isFind = false
		for tk, tv in pairs(tar) do
			if (math.abs(tv.x - obj.x) < step) and (math.abs(tv.y - obj.y) < step) then
				isFind = true
				break
			end
		end
		if not isFind then
			table.insert ( tar, obj)
		end
	end
end

battle.findEnemy = function ()
	local target = {}
	-- Boss check
	local    point = findColors({263, 246, 1373, 706},
		"0|0|0x313031,1|45|0x7b0010,-19|24|0xff4d52,22|25|0xff4d52,-19|-4|0x313431,20|-7|0x312831,-6|31|0xe7595a,9|31|0xf75152",
		90, 0, 0, 0)
	if #point ~= 0 then
		mergeTarget (target, point, 17, 26, true)
	end
	
	-- LV check
	point = findColors({263, 246, 1373, 706},
		"0|0|0xfff7c6,0|8|0xefcb73,0|15|0xefcf42,0|20|0xffdf42,5|20|0xefcf42,14|20|0xf7e35a,17|10|0xefba42,10|5|0xffd794,11|14|0xefc34a,22|19|0xf7cf52,23|18|0xefc752",
		80, 0, 0, 0)
	if #point ~= 0 then
		mergeTarget (target, point,   -4 ,-40)
	end
	
	-- 3星
	point = findColors({263, 246, 1373, 706},
		"0|0|0x942c00,12|0|0xbd3400,15|10|0xbd3000,22|22|0xbd3000,7|22|0xbd3000,4|31|0xbd3400,25|30|0x942c00,29|10|0x844121",
		90, 0, 0, 0)
	if #point ~= 0 then
		mergeTarget (target, point,   64 ,53)
	end
	-- 2星
	point = findColors({263, 246, 1373, 706},
		"0|0|0xdeaa00,13|0|0xefa600,26|2|0xd6a610,27|26|0xd69200,20|16|0xe7a218,16|16|0xd69e00,6|17|0xdeaa00,7|13|0xd6a200,-2|11|0xdeaa00",
		70, 0, 0, 0)
	if #point ~= 0 then
		mergeTarget (target, point,   60 ,49)
	end
	
	for v,k  in pairs(target) do
		utils:showTar(k.x, k.y)
	end
	mSleep(1000)
	utils:hideTar()
	return target
end

function  battle:selectEnemy   (points)
	local tar  = nil
	local isIgnore = function (a, b) 
		return  a and  a.ignore  and  a.x ==b.x and a.y ==b.y
	end
	for k,v in pairs(points) do
		if v.isBoss then
			tar = v
			break
		end
		if not tar then 
			tar = v
		elseif not isIgnore(self.lastTar, v) then
			if v.x > tar.x    then 
				tar = v
			 elseif v.y > tar.y   then
				tar = v
			 end 
		end
	end 
	
	
	if   self.lastTar and  self.lastTar.x == tar.x and self.lastTar.y == tar.y    then
		
		if  self._ct > 3 then
			self.lastTar.ignore = true
		end
		self._ct  = self._ct + 1
	else 
		self.lastTar = tar
		self._ct = 0
	end
	
	return tar
end 


battle.seekEnemy = function () 
	local  arr = battle.findEnemy()
	if #arr > 0 then 
		local target  = battle:selectEnemy(arr)
		battle.checkForm();
		utils.click(target)
	else 
		utils.log ('未找到敌舰 - 切换')
		battle.dragMap()
	end
end

battle.dragMap = function() 
	utils.swip(1240,491,691,527)
end

battle.checkForm = function ()
	--单纵
local point1 = findColors({329, 123, 347, 192}, 
"0|0|0x00ebbd,0|10|0x00ebbd,0|20|0x08ebbd,1|30|0x00ebbd,1|42|0x00ebbd,1|52|0x00ebbd",
80, 0, 0, 0)
	--复纵
	local  point2 = findColors({311, 123, 366, 183}, 
		"0|0|0x08d7a5,20|-2|0x00ebbd,-1|18|0x08e3ad,19|16|0x00e3ad,-2|34|0x00ebbd,23|36|0x00ebbd",
		80, 0, 0, 0)
	if   #point1 > 0 then
		utils.click (	1399,367,1428,417)
		mSleep(300)
		utils.click (	1243,372,1325,457)
		mSleep(300)
		utils.click (1182,380,1224,449)
		mSleep(300)
	end
	
end

return battle
