extends Control

@onready var set_langua_list : VBoxContainer = $default_lan/set_langua
var change_lan = settings.set_default_lan

var config = {
	"mine" : 2,
	"joker_co" : 6,
	"prob" : 40,
	"min" : 3,
	"max" : 5
}

const steps = {
	"mine" : 1,
	"joker_co" : 1,
	"prob" : 5,
	"min" : 1,
	"max" : 1
}

@onready var labels ={
	"mine" : $mine_count_num,
	"joker_co" : $joker_count_num,
	"prob" : $joker_probabilty_num,
	"min" : $joker_min_num,
	"max" :  $joker_max_num
}

var chang_joker_rand : bool = false

var chose_serect : Array = []

func _ready() -> void:
	config["mine"] = settings.set_mine_count
	config["joker_co"] = settings.set_joker_count
	config["prob"] = settings.set_joker_probability
	config["min"] = settings.set_joker_min
	config["max"] = settings.set_joker_max
	$jokerrand.set_pressed_no_signal(settings.set_joker_rand_flag)
	_on_jokerrand_toggled(settings.set_joker_rand_flag)
	chose_serect = settings.set_secret_array
	
	set_langua_list.visible = false
	$default_lan/now.button_down.connect(_on_set_langua)
	$default_lan/set_langua/th.button_down.connect(langua_set.bind(0))
	$default_lan/set_langua/vn.button_down.connect(langua_set.bind(1))
	$default_lan/set_langua/en.button_down.connect(langua_set.bind(2))
	langua_set(change_lan)
	
	#控制點擊按鈕後更新目前數字
	for type in config.keys():
		labels[type].text = str(config[type])
	
	#利用群組來賦予所有按鈕功能，然後將值帶到_on_arrow_pressed的func裡面
	for btn in get_tree().get_nodes_in_group("arrow"):
		btn.pressed.connect(_on_arrow_pressed.bind(btn))
	
	_sync_checkbox_ui()
	
	#同arrow，但這是是check_box
	for cb in get_tree().get_nodes_in_group("check"):
		cb.toggled.connect(_on_checkbox_toggled.bind(cb))


#設定頁面語言選單的出現與隱藏
func _on_set_langua():
	set_langua_list.visible =! set_langua_list.visible

#控制語言下拉式選單點擊後的變動狀態
func langua_set(index : int):
	var lan_word = $default_lan/now/now_language
	change_lan = index
	match index:
		0 :
			lan_word.text = str("THAILAND")
			set_langua_list.visible = false
		1 :
			lan_word.text = str("VIETNAM")
			set_langua_list.visible = false
		2 :
			lan_word.text = str("ENGLISH")
			set_langua_list.visible = false

#控制箭頭點擊後的加減及變化
func _on_arrow_pressed(btn: Button) -> void:
	var type = btn.get_meta("type")
	var dir = btn.get_meta("dir")
	
	config[type] += dir * steps[type]
	
	_update_ui_state()

#控制每一個係數的最大與最小值
func get_limites(type: String) -> Dictionary:
	match type:
		"mine":
			return {"min": 1 , "max": 12}
		"joker_co":
			return {"min": 0 , "max": 15 - config["mine"]}
		"prob":
			return {"min": 10 , "max": 100 }
		"min":
			return {"min": 1 , "max": config["max"] - 1}
		"max":
			return {"min": config["min"] , "max": 15 - config["mine"]}
	return {"min": 0 ,"max": 0}

#更新畫面中的數字
func _update_ui_state() :
	for type in config.keys():
		labels[type].text = str(config[type])
		
	for btn in get_tree().get_nodes_in_group("arrow"):
		var type = btn.get_meta("type")
		var dir = btn.get_meta("dir")
		
		var limits = get_limites(type)
		
		if dir == -1 and config[type] <= limits["min"]:
			btn.disabled = true
		elif dir == 1 and config[type] >= limits["max"]:
			btn.disabled = true
		else:
			btn.disabled = false

#小丑隨機出現的控制選項
func _on_jokerrand_toggled(toggled_on: bool) -> void:
	chang_joker_rand = toggled_on
	$joker_count_left.visible = not toggled_on
	$joker_count_num.visible = not toggled_on
	$joker_count_right.visible = not toggled_on
	
	$joker_min_left.visible = toggled_on
	$joker_min_num.visible = toggled_on
	$joker_min_right.visible = toggled_on
	$joker_probabilty_left.visible = toggled_on
	$joker_probabilty_num.visible = toggled_on
	$joker_probabilty_right.visible = toggled_on
	$joker_max_left.visible = toggled_on
	$joker_max_num.visible = toggled_on
	$joker_max_right.visible = toggled_on
	
	if toggled_on == true:
		config["max"] = settings.set_joker_max
		config["max"] = clampi(config["max"],config["min"],15-config["mine"])
		
		config["min"] = settings.set_joker_min
		config["min"] = clampi(config["min"],1,config["max"] -1)

	else :
		config["joker_co"] = settings.set_joker_count
		config["joker_co"] = clampi(config["joker_co"],0,15-config["mine"])
		
	_update_ui_state()


#控制check_box是否在array裡面，有就點起來
func _sync_checkbox_ui():
	for cb in get_tree().get_nodes_in_group("check"):
		var id = cb.get_meta("id")
		
		if id in chose_serect:
			cb.set_pressed_no_signal(true)
		else:
			cb.set_pressed_no_signal(false)

#check_box帶值後是否加入array，然後再抽獎到神秘事件時，可以準確控制裡面有哪些神秘事件
func _on_checkbox_toggled(toggled_on: bool,cb:CheckBox) -> void:
	var id = cb.get_meta("id")
	
	if toggled_on == true:
		if not id in chose_serect:
			chose_serect.append(id)
	else:
		chose_serect.erase(id)
	
	chose_serect.sort()

#OK按鈕作用
func _on_ok() -> void:
	settings.set_default_lan = change_lan
	settings.set_mine_count = config["mine"]
	settings.set_joker_count = config["joker_co"]
	settings.set_joker_rand_flag = chang_joker_rand
	settings.set_joker_probability = config["prob"]
	settings.set_joker_min = config["min"]
	settings.set_joker_max = config["max"]
	settings.set_secret_array = chose_serect
	
	settings.save_settings()
	
	get_tree().change_scene_to_file("res://clownshow.tscn")

#cancel按鈕作用
func _on_cancel() -> void:
	queue_free()
