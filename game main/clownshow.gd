extends Control

@export var step_scene: PackedScene = preload("res://game main/step.tscn")
@onready var mine_container = $GridContainer.get_children()

var mine_count: int = 1
var joker_count: int = 2
var joker_default: int = 2
var sq_list: Array = []
var joker_rand_flag: bool = true
var joker_min: int = 1 
var joker_max: int = 3
var joker_probability = 4

func _ready() -> void:
	_star_game()

func _star_game():
	clean_game()
	
	#小丑隨機邏輯
	if joker_rand_flag == true:
		var joker_rand_pro = randi_range(1,10)
		if joker_rand_pro > joker_probability :
			joker_count = randi_range(joker_min,joker_max)
		else :
			joker_count = 0
	
	#本局遊戲的清單建立
	for i in range(mine_count):
		sq_list.append(step.SpName.MINE)
		
	for i in range(joker_count):
		sq_list.append(step.SpName.JOKER)
		
	for i in range(max(0,mine_container.size() - mine_count - joker_count)):
		sq_list.append(step.SpName.EMPTY)
	
	sq_list.shuffle()
		
	for i in range(mine_container.size()):
		mine_container[i].sp_type = sq_list[i]
		
		

#清理資料
func clean_game():
	sq_list.clear()
	joker_count = joker_default
	for child in mine_container:
		child.again()

#重新一局
func _reset_game() -> void:
	_star_game()
