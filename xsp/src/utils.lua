local ins = require("lib.inspect")
local scene = require("scene")
local utils = { hid , tarArr }

-- local bb = require("badboy")


utils.log = function (...)
	if not _isDebug then
		do return end
	end
	local args = {...}
	if #args == 1 then
		args = args[1]
	end
	sysLog("[Debug Log]" .. ins(args))
end
--[[
utils.click({
		x = 462,
		y= 552
	})
utils.click (458,534,482,561);
]]--
utils.click = function (...)
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))  --设置随机数种子
	local args = {...}
	local opt
	if #args == 1 then
		opt  = args[1]
		if #opt == 4 then 			
			opt = {
				x = math.random(opt[1], opt[3]),
				y = math.random(opt[2], opt[4])
			}
		end
	else 
		opt = {
			x = math.random(args[1], args[3]),
			y = math.random(args[2], args[4])
		}
	end
	local x, y, range, delay = opt.x, opt.y, opt.range or 3, opt.delay or 0
	local index = math.random(1, 5) --手指序号，用于多点触控中标记多只手指，分别控制它们的移动
	x = x + math.random(-1 * range, range)
	y = y + math.random(-1 * range, range)
	touchDown(index, x, y)
	utils.showCur( x, y)
	mSleep(math.random(70, 90) + delay)
	touchUp(index, x, y)
	mSleep(500)
end

-- 	utils.swip (479,696,1192,718);
utils.swip = function (...)
	local args = {...}
	local opt
	if #args == 1 then
		opt  = args[1]
	else
		opt = {
			x1 = args[1],
			y1 = args[2],
			x2 = args[3],
			y2 = args[4]
		}
	end
	
	local x, y, x2, y2, range, delay = opt.x1, opt.y1, opt.x2, opt.y2, opt.range or 5, opt.delay or 0
	local step, index = 20,  math.random(1, 5)
	-- 模糊起始位置
	x = x + math.random(-1 * range, range)
	y = y + math.random(-1 * range, range)
	x2 = x2 + math.random(-1 * range, range)
	y2 = y2 + math.random(-1 * range, range)
	local x1, y1 = x,y
	touchDown(index, x, y)
	local hid = utils.showCur( x, y , true)
	local move = function (from, to)
		if from > to then
			do
				return - 1 * step + math.random(-5, 5)
			end
		else
			return step+ math.random(-5, 5)
		end
	end
	
	while (math.abs(x - x2) >= step) or (math.abs(y - y2) >= step) do
		if math.abs(x - x2) >= step then
			x = x + move(x1, x2)
		end
		if math.abs(y - y2) >= step then
			y = y + move(y1, y2)
		end
		touchMove(index, x, y)
		utils.showCur( x, y, hid)
		mSleep(20)
	end
	
	touchMove(index, x2, y2)
	mSleep(30)
	touchUp(index, x2, y2)
	utils.showCur( x2, y2, hid)
	mSleep(500)
	-- 真实位移
	return x2 - x1, y2 - y1
end

utils.showCur = function (x, y, lastId)
	local hid
	if  type( lastId)  == 'number'  then
		hid = lastId
	else
		 hid  = createHUD()
	end
	--pos  0 - 左上角，1 - 居中，2 - 水平居中， 3 - 垂直居中
	showHUD(hid, '', 40,"0xffffff00" , 'cur.png', 0, x-25, y-25, 50,50)
	if lastId then
		 do return hid  end
	end
	mSleep(1000)
	hideHUD(hid)
end

function utils:showTar (x, y)
	local hid = createHUD()
	--pos  0 - 左上角，1 - 居中，2 - 水平居中， 3 - 垂直居中
	showHUD(hid, '', 40,"0xffffff00" , 'target.png', 0, x -25, y-25, 50,50)
	self.tarArr  = self.tarArr  or {}
	table.insert(self.tarArr  , hid)
end
function utils:hideTar() 
	local arr  = self .tarArr
	if  arr then 
		for k,v in pairs(arr) do
			hideHUD(v)
		end
	end
	self.tarArr = nil
end

utils.showRange = function (x1,y1, x2 , y2)
	local hid  = createHUD()
	showHUD(hid, '', 0,"0xffffff00" , '0xb7dc3061', 0, x1, y1, x2 - x1,y2 -y1)
	mSleep(10000)
	hideHUD(hid)
end
utils.setMsg = function (str)
	return utils:_setMsg (str)
end

function   utils:_setMsg   (str)
	if not self.hid  then
		self.hid = createHUD()
	end
	showHUD(self.hid, str, 32, '0xfff7f8fa', '0xb73089dc', 2, 0, 60, 800, 40)
end


utils.getCurrentScene  = function ()
	for key, sceneItem in pairs(scene) do
		local     ret  = sceneItem.check()
		if ret then
			do return key, sceneItem end
		end
	end
	return nil
end

return utils
