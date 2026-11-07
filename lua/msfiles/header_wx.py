# WSE2 Lua 常量表 (game.const.wx.*)
# 重要: 每行必须严格是 "名字=数字" 或 "名字=名字", 不能有空格和注释, 否则 WSE 会忽略这一行。
# 如果 NeoGK 以后改动了道具/粒子编号, 记得同步改这里。

# ---- 触发器 ----
ti_before_mission_start=-19.0
ti_after_mission_start=-20.0
ti_server_player_joined=-15.0

# ---- 网络事件 ----
neo_event_receive_client=125
multiplayer_event_show_server_message=111

# ---- 场景道具 ----
spr_zz_active_point=951
spr_empty=2

# ---- 粒子系统(服务端爆发 -> 引擎自动同步给所有客户端) ----
psys_game_rain=0
psys_game_snow=1
psys_war_smoke_tall=16
psys_moon_beam_1=46
psys_fall_leafs_a=59
psys_sand_splash=76
psys_haze=113
psys_cloud=114
psys_cloud_heavy=115

# ---- 原生投票(GK/Native 的 poll 流程) ----
multiplayer_event_ask_for_poll=74
multiplayer_event_show_multiplayer_message=68
multiplayer_message_type_poll_result=7
slot_player_can_answer_poll=23
slot_player_poll_disabled_until_time=26
multiplayer_scenes_begin=491
multiplayer_scene_names_begin=1648
str_mod_weather_mist_0=3892

# ---- 音效 ----
snd_rain=10
snd_night=230
snd_rain_heavy=231
snd_wind=237
snd_wind2=238
