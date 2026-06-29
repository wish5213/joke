extends Control

var config = {
	"mine" : 5,
	"joker_co" : 5,
	"prob" : 60,
	"min" : 1,
	"max" : 3
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

var total = config["mine"] + config["joker_co"] + config["max"] 


func _ready() -> void:
	for btn in get_tree().get_nodes_in_group("arrow"):
		btn.pressed.connect(_on_arrow_pressed.bind(btn))
	
	$jokerrand.set_pressed_no_signal(settings.set_joker_rand_flag)
	_on_jokerrand_toggled(settings.set_joker_rand_flag)


func _on_arrow_pressed(btn: Button) -> void:
	var type = btn.get_meta("type")
	var dir = btn.get_meta("dir")
	
	config[type] += dir * steps[type]
	
	_update_ui_state()

func _update_ui_state() :
	pass


func _on_jokerrand_toggled(toggled_on: bool) -> void:
	$joker_count_left.disabled = toggled_on
	$joker_count_right.disabled = toggled_on
	
	$joker_min_left.disabled = not toggled_on
	$joker_min_right.disabled = not toggled_on
	$joker_probabilty_left.disabled = not toggled_on
	$joker_probabilty_right.disabled = not toggled_on
	$joker_max_left.disabled = not toggled_on
	$joker_max_right.disabled = not toggled_on
	
	if toggled_on == true:
		config["joker_co"] = 0
		config["prob"] = 60
		config["min"] = 1
		config["max"] = 3
	else :
		config["joker_co"] = 5
		config["prob"] = 0
		config["min"] = 0
		config["max"] = 0
		
	_update_ui_state()


func _on_cancel() -> void:
	queue_free()
