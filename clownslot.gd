extends Control

@onready var back_slot = $back
@onready var front_slot = $front

@onready var back_turntable = back_slot.get_node("turntable")
@onready var front_turntable = front_slot.get_node("turntable")

@onready var back_text = back_slot.get_node("text")
@onready var front_text = front_slot.get_node("text")

var brain_turn_list : Array = [
  4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,
  4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,
  4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,
  4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,
  4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,
  4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,
  4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4]

var secret_array : Array = [4,5,6,7,8,9]

func _ready() -> void:
	_play_animation()
	
	_create_shared_date()
	#back_turntable._reel_photo(brain_turn_list)
	#front_turntable._reel_photo(brain_turn_list)
	
	back_turntable.roulette_stopped.connect(_on_any_roulette_trigger_stop)
	front_turntable.roulette_stopped.connect(_on_any_roulette_trigger_stop)
	
	back_turntable.prize_number.connect(_create_shared_text)
	front_turntable.prize_number.connect(_create_shared_text)
	
	
func _create_shared_date()  -> void:
	brain_turn_list.clear()
	
	for i in range(70):
		brain_turn_list.append(randi_range(0, 4))
		brain_turn_list.append(i % 4)
		
	back_turntable._reel_photo(brain_turn_list)
	front_turntable._reel_photo(brain_turn_list)
	
func _create_shared_text(brain_text_number)  -> void:
	if brain_text_number == 4:
		brain_text_number = secret_array.pick_random()
	
	back_text.transtext(brain_text_number)
	front_text.transtext(brain_text_number)
	
func _play_animation():
	self.position.y = -500
	
	var star_tween = create_tween()
	star_tween.tween_property(self,"position:y", 0.0 , 0.8)\
	.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		
func _on_any_roulette_trigger_stop(shared_anim : int):
	back_turntable.stop_spin(shared_anim)
	front_turntable.stop_spin(shared_anim)


func _on_close_clownslot() -> void:
	queue_free()
