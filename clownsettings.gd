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
	"mine" = $mine_count_num,
	"joker_co" = $joker_count_num,
	"prob" = $joker_probabilty_num,
	"min" = $joker_min_num,
	"max" =  $joker_max_num
}


func _ready() -> void:
	config["mine"] = settings.set_mine_count
	config["joker_co"] = settings.set_joker_count
	config["prob"] = settings.set_joker_probability
	config["min"] = settings.set_joker_min
	config["max"] = settings.set_joker_max
	$jokerrand.set_pressed_no_signal(settings.set_joker_rand_flag)
	_on_jokerrand_toggled(settings.set_joker_rand_flag)
	
	set_langua_list.visible = false
	$default_lan/now.button_down.connect(_on_set_langua)
	$default_lan/set_langua/th.button_down.connect(langua_set.bind(0))
	$default_lan/set_langua/vn.button_down.connect(langua_set.bind(1))
	$default_lan/set_langua/en.button_down.connect(langua_set.bind(2))
	
	for type in config.keys():
		labels[type].text = str(config[type])
	
	for btn in get_tree().get_nodes_in_group("arrow"):
		btn.pressed.connect(_on_arrow_pressed.bind(btn))
		


func _on_set_langua():
	set_langua_list.visible =! set_langua_list.visible

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
			lan_word.text = str("ENGLISG")
			set_langua_list.visible = false


func _on_arrow_pressed(btn: Button) -> void:
	var type = btn.get_meta("type")
	var dir = btn.get_meta("dir")
	
	config[type] += dir * steps[type]
	
	_update_ui_state()

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


func _on_jokerrand_toggled(toggled_on: bool) -> void:
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
		config["joker_co"] = 0
		config["min"] = 1
		config["max"] = 3
	else :
		config["joker_co"] = 3
		config["min"] = 0
		config["max"] = 0
		
	_update_ui_state()


func _on_cancel() -> void:
	queue_free()
