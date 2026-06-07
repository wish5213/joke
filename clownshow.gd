@tool
extends Control

@export var preview_mode: bool = false:
	set(value):
		preview_mode = value
		if Engine.is_editor_hint():
			if preview_mode == true:
				_star_game() # 打勾時，生成預覽
			else:
				clean_game() # 取消打勾時，把畫面清空

@export var step_scene: PackedScene = preload("res://step.tscn")
@onready var mine_container: GridContainer = $GridContainer

var mine_count: int = 1
var joker_count: int = 2
var joker_default: int = 2
var total_count: int = 15
var sq_list: Array = []
var joker_rand_flag: bool = true
var joker_min: int = 1 
var joker_max: int = 3
var joker_probability = 4

func _ready() -> void:
	_star_game()

func _star_game():
	clean_game()
	
	# 🛠️ 安全防護網：避免編輯器剛開時還沒抓到場景就報錯崩潰
	if step_scene == null:
		return
	
	# 🛠️ 核心二：區分「編輯器」與「真實遊戲」的邏輯
	if Engine.is_editor_hint():
		# 編輯器預覽：單純把格子生出來排版，不跑機率也不洗牌
		for i in range(total_count -1):
			var new_sq = step_scene.instantiate()
			mine_container.add_child(new_sq)
	
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
		
	for i in range(max(0,total_count - mine_count - joker_count)):
		sq_list.append(step.SpName.EMPTY)
	
	sq_list.shuffle()
	
	#將清單整理出來以後一個一個產生格子並塞進去
	for i in range(total_count):
		var new_sq = step_scene.instantiate()
		mine_container.add_child(new_sq)
		new_sq.sp_type = sq_list[i]

#清理資料
func clean_game():
	sq_list.clear()
	joker_count = joker_default
	for child in mine_container.get_children():
		if Engine.is_editor_hint():
			child.free()
		else:
			child.queue_free()

#重新一局
func _reset_game() -> void:
	_star_game()
