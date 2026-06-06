extends Control

@export var step_scene: PackedScene = preload("res://jokegame/step.tscn")
@onready var mine_container: GridContainer = $GridContainer

var mine_count: int = 1
var joker_count: int = 2
var total_count: int = 12
var sq_list: Array = []

func _ready() -> void:
	_star_game()
	
func _star_game():
	for child in mine_container.get_children():
		sq_list.clear()
		child.queue_free()
		
	for i in range(mine_count):
		sq_list.append(1)
		
	for i in range(joker_count):
		sq_list.append(2)
		
	for i in range(total_count - mine_count - joker_count):
		sq_list.append(0)
	
	sq_list.shuffle()
	
	for i in range(total_count):
		var new_sq = step_scene.instantiate() as step
		mine_container.add_child(new_sq)
		new_sq.rand_type = sq_list[i]
		
