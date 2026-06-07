extends Control

@export var step_scene: PackedScene = preload("res://jokegame/step.tscn")
@onready var mine_container: GridContainer = $GridContainer

var mine_count: int = 1
var joker_count: int = 2
var total_count: int = 12
var sq_list: Array = []
var joker_rand_flag: bool = false
var joker_max: int = 3 

func _ready() -> void:
	_star_game()
	
func _star_game():
	#做遊戲開始前的清理，將格子跟上一場的資料清掉
	for child in mine_container.get_children():
		sq_list.clear()
		child.queue_free()
	
	#小丑隨機邏輯
	if joker_rand_flag == false:
		pass
	else: 
		var joker_probability = randi_range(1,10)
		if joker_probability > 4 :
			joker_count = randi_range(1,joker_max)
		else :
			joker_count = 0
	
	#本局遊戲的清單建立
	for i in range(mine_count):
		sq_list.append(step.SpName.MINE)
		
	for i in range(joker_count):
		sq_list.append(step.SpName.JOKER)
		
	for i in range(total_count - mine_count - joker_count):
		sq_list.append(step.SpName.EMPTY)
	
	sq_list.shuffle()
	
	#將清單整理出來以後一個一個產生格子並塞進去
	for i in range(total_count):
		var new_sq = step_scene.instantiate()
		mine_container.add_child(new_sq)
		new_sq.sp_type = sq_list[i]
		

#重新一局
func _reset_game() -> void:
	_star_game()
