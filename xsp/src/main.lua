local scene = require("scene")
local action = require("action")
local utils = require('utils')
local battle = require ("battle")
local bb = require("badboy")

_isDebug = true;
function main ()
	-- "0"  自动使用当前运行的应用  ,  0 - 竖屏， 1 - Home键在右边， 2 - Home键在左边
	init("0", 1);
	local ret, setting = showUI("ui.json")
	if ret ~= 1 then
		       lua_exit();
	end
	
	local curScene , sceneKey, nextSceneKey
	local curAction = action['c1']
	local dispatch = curAction.dispatch;
	local status = { round = 0}
	utils.setMsg ('摸鱼准备中')
	while true do
		-- 检查当前应用
		appid = frontAppName()   -- com.bilibili.azurlane
		if appid == 'com.bilibili.azurlane' then
			sceneKey ,curScene = utils.getCurrentScene()
			if curScene then
				utils.setMsg(curScene.name)
				nextSceneKey = dispatch[sceneKey]
				if  curScene.route  then
					utils.log( curScene.name  .. ' -> ' ..  (nextSceneKey or 'go'))
					utils.click(curScene .route [nextSceneKey or 'go'])
					if curScene.afterCallback then 
						 local ret =  curScene.afterCallback (status)
						 if ret then 
						 utils.setMsg(curScene.name .. ' - ' ..ret)
						 end 
					end
				else
					if sceneKey == 'battleMap' then
						battle.seekEnemy(status)
					end
				end
			 else
				utils.setMsg('未知区域')
				mSleep(3000)
			end
		else
			mSleep(3000)
		end
	end
end

function onError(msg)
	local str = '[======Uncache Error======] ' .. msg;
	utils.log(msg)
end
-- 摸鱼入口
xpcall(main, onError)
