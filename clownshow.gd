extends Control

@export var step_scene: PackedScene = preload("res://clownslot.tscn")
@export var setting_scene = preload("res://clownsettings.tscn")
@onready var mine_container = $GridContainer.get_children()

var mine_count: int = 1
var joker_count: int = 5
#var joker_default: int = 2
var sq_list: Array = []
var joker_rand_flag: bool = false
var joker_min: int = 1 
var joker_max: int = 3
var joker_probability = 4
var change_music : bool = false

func _ready() -> void:
	mine_count = settings.set_mine_count
	joker_count = settings.set_joker_count
	joker_rand_flag = settings.set_joker_rand_flag
	joker_min = settings.set_joker_min
	joker_max = settings.set_joker_max
	joker_probability = settings.set_joker_probability
	$music.set_pressed_no_signal(settings.set_music_current)
	_on_music_toggled(settings.set_music_current)
	
	_star_game()

func _star_game():
	clean_game()
	
	#小丑隨機邏輯
	if joker_rand_flag == true:
		var joker_rand_pro = randi_range(1,100)
		if joker_rand_pro < joker_probability == true:
			joker_count = randi_range(joker_min,joker_max)
		else :
			joker_count = 0
	
	#本局遊戲的清單建立
	for i in range(mine_count):
		sq_list.append(step.SqName.MINE)
		
	for i in range(joker_count):
		sq_list.append(step.SqName.JOKER)
		
	for i in range(max(0,mine_container.size() - mine_count - joker_count)):
		sq_list.append(step.SqName.EMPTY)
	
	sq_list.shuffle()
		
	for i in range(mine_container.size()):
		mine_container[i].sq_type = sq_list[i]
		
		

#清理資料
func clean_game():
	sq_list.clear()
	#joker_count = joker_default
	for child in mine_container:
		child.again()

#重新一局
func _reset_game() -> void:
	_star_game()


#func _go_to_mina() -> void:
	#get_tree().change_scene_to_file("res://text game.tscn")

#前往設定頁面
func _go_setting() -> void:
	var new_setting = setting_scene.instantiate()
	get_tree().current_scene.add_child(new_setting)
	

#管理音效是否撥放，以及上次音效的狀態更新
func _on_music_toggled(toggled_on: bool) -> void:
	change_music = toggled_on
	if toggled_on == false: 
		audiomanager.play_sfx("background")
		
	else:
		audiomanager.stop_sfx("background")
	
	settings.set_music_current = change_music
	settings.save_settings()
