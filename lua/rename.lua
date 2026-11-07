--[[ rename.lua — 进服按 GUID 查后端昵称并改名; 后端 GET /api/nickname?guid=<GUID> -> "guid:nickname", 空 = 未收录 ]]

local BACKEND_URL = "http://warbandnames.wm-valley.com"
local HTTP_TIMEOUT, S_NAME = 15000, 61
local pending, callback = {}, nil               -- guid -> player_no; 回调脚本号

local function log(msg)
	msg = "[Rename] " .. msg
	pcall(print, msg)
	if log_rgl then pcall(log_rgl, msg) end
end

-- 进服: 取 GUID -> 去重 -> 发查询
local function onPlayerJoined()
	local player_no = game.store_trigger_param(0, 1)  -- 触发参数 1 = player_no
	if type(player_no) ~= "number" or player_no < 0 then return end

	local ok, uid = pcall(game.player_get_unique_id, 0, player_no)
	if not ok or type(uid) ~= "number" or uid <= 0 then
		return log("取不到 GUID, 该玩家保留原名: player=" .. player_no)
	end
	local guid = string.format("%.0f", uid)
	pending[guid] = player_no                         -- 同一玩家重复触发时以最后一次为准

	if not pcall(game.send_message_to_url_advanced,
			BACKEND_URL .. "/api/nickname?guid=" .. guid,
			"WSE2-AutoRename/1.0", callback, callback, 1, HTTP_TIMEOUT) then
		pending[guid] = nil
		log("查询昵称失败(后端没回应?): player=" .. player_no .. " guid=" .. guid)
	end
end

-- 后端返回 "guid:nickname"; 空昵称 = 未收录, 只处理 pending 里的请求
local function onResponse(body)
	local guid, nickname = body:gsub("[\r\n]+$", ""):match("^([^:]+):(.*)$")
	local player_no = guid and pending[guid]
	if not player_no then return end
	pending[guid] = nil
	if nickname == "" or not game.player_is_active(player_no) then return end
	game.sreg[S_NAME] = nickname
	game.player_set_username(player_no, S_NAME)
	log("改名: player=" .. player_no .. " guid=" .. guid .. " -> " .. nickname)
end

callback = select(2, pcall(game.getScriptNo, "game_receive_url_response"))
if type(callback) ~= "number" or callback < 0 then
	return log("无法找到 game_receive_url_response, 昵称功能不可用, 请尝试使用更高版本WSE。")
end
game.hookScript(callback, function()
	local body = game.sreg[0]
	if type(body) == "string" and body ~= "" then onResponse(body) end
end)

-- 对每个 multiplayer 任务模板挂载进服触发器; 该模块没有的模板会抛错, 跳过即可
local trigger = (game.const and game.const.ti_server_player_joined) or -15
local okNum, num = pcall(game.getNumTemplates)
if not okNum or type(num) ~= "number" then num = 0 end
local added = 0
for i = 0, num - 1 do
	local okId, id = pcall(game.getTemplateId, i)
	if okId and type(id) == "string" and id:find("multiplayer", 1, true)
			and pcall(game.addTrigger, id, trigger, 0, 0, function() return true end, onPlayerJoined) then
		added = added + 1
	end
end

log(added == 0 and "没有可用的 multiplayer 任务模板, 昵称系统不可用"
	or "昵称系统已挂载 " .. added .. " 个任务模板  后端地址=" .. BACKEND_URL)
