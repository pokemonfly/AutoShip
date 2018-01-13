local scene = require("scene")
local action = require("action")
local utils = require('utils')
local var = require('var')
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
	
	local curScene , sceneKey, nextScene
	local curAction = action['c1']
	local dispatch = curAction.dispatch;
	local clickArea
	utils.setMsg ('摸鱼准备中')
	while true do
		-- 检查当前应用
		appid = frontAppName()   -- com.bilibili.azurlane
		if appid == 'com.bilibili.azurlane' then
			sceneKey ,curScene = utils.getCurrentScene()
			if curScene then
				utils.setMsg(curScene.name)
				nextScene = dispatch[sceneKey]
				if  curScene.route  then
					utils.click(curScene .route [nextScene or 'go'])
				else
					if sceneKey == 'battleMap' then
						battle.seekEnemy()
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
