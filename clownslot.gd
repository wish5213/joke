extends Control

@onready var back_slot = $back
@onready var front_slot = $front

@onready var back_turntable = back_slot.get_node("turntable")
@onready var front_turntable = front_slot.get_node("turntable")

var brain_turn_list : Array = []

func _ready() -> void:
	_create_shared_date()
	
	back_turntable._reel_photo(brain_turn_list)
	front_turntable._reel_photo(brain_turn_list)
	
	back_turntable.roulette_stopped.connect(_on_any_roulette_trigger_stop)
	front_turntable.roulette_stopped.connect(_on_any_roulette_trigger_stop)
	
func _create_shared_date()  -> void:
	brain_turn_list.clear()
	
	for i in range(70):
		brain_turn_list.append(randi_range(0, 4))
		brain_turn_list.append(i % 4)
		
func _on_any_roulette_trigger_stop(shared_anim : int):
	back_turntable.stop_spin(shared_anim)
	front_turntable.stop_spin(shared_anim)
