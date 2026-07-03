extends AudioStreamPlayer
#此頁面為音效管理

func _ready() -> void:
	pass # Replace with function body.

#抓節點的名稱，來撥放音樂，所以各場景的名稱一定要與節點名稱相同
func play_sfx(sound_name: String) -> void:
	if has_node(sound_name):
		var player = get_node(sound_name) as AudioStreamPlayer
		player.play()
	else:
		push_error("找不到此音效")

#抓節點的名稱，來停止音樂，所以各場景的名稱一定要與節點名稱相同
func stop_sfx(sound_name: String) -> void:
	if has_node(sound_name):
		var player = get_node(sound_name) as AudioStreamPlayer
		player.stop()
	else:
		push_error("找不到此音效")
		
#管理在轉盤時，背景音樂暫時停止
func back_eff_sp():
	$background.stream_paused = not $background.stream_paused 
