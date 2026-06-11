extends Node2D

#定義圖片
@onready var turn_all: TextureRect = $mask/reel/all
@onready var turn_angel: TextureRect = $mask/reel/angel
@onready var turn_myself: TextureRect = $mask/reel/myself
@onready var turn_youdrink: TextureRect = $mask/reel/youdrink
@onready var turn_secret: TextureRect = $mask/reel/secret

#定義裝圖片的容器
@onready var reel = $mask/reel

#定義各項函數
var photo_high:float = 293.5
var turn_list:Array = []
var is_reeling:bool = false
var reel_tween : Tween
var prize_number : int = 0
var spin_tween : Tween

@onready var TurnName:Dictionary ={
	0 : turn_all,
	1 : turn_angel,
	2 : turn_myself,
	3 : turn_youdrink,
	4 : turn_secret,
	}


func _ready() -> void:
		_reel_photo()
		start_spin()

func _reel_photo():
	#
	for i in range(70):
		turn_list.append(i % 5)
		turn_list.append(randi_range(0,4)) 
	
	turn_list.shuffle()
	
	for i in range(turn_list.size()):
		var tex = TextureRect.new()
		tex.texture = TurnName[turn_list[i]].texture
		tex.position.y = i * photo_high
		reel.add_child(tex)
	
	reel.position.y = -(photo_high * turn_list.size())

#輪盤旋轉
func start_spin():
	#判斷狀態是不是在選轉，如果是就跳出
	if is_reeling == true:
		return
	is_reeling = true
	reel_tween = create_tween()
	reel_tween.tween_property(reel,"position:y", reel.position.y + (photo_high * turn_list.size()), 13)

#輪盤停止規則
func stop_spin():
	is_reeling = false
	if reel_tween and reel_tween.is_valid():
		reel_tween.kill()
	
	#current_y_index 是抓目前Y軸位置，slide_distance是控制動畫移動量
	var current_y = reel.position.y
	var current_y_index = round(abs(current_y/photo_high))
	var stop_tween = create_tween()
	
	#輪盤動畫要演出哪個的隨機值
	var rand_animation = randi_range(1,4)
	var slide_distance = 1
	if rand_animation == 1:
		slide_distance = 1
	elif rand_animation == 2:
		slide_distance = 5
	else:
		slide_distance = 1
		
	var prize_index = current_y_index - slide_distance
	var tareget_y = -(prize_index * photo_high)
	
	if rand_animation == 1 :
		stop_tween.set_trans(Tween.TRANS_BACK)
		stop_tween.set_ease(Tween.EASE_IN_OUT)
		stop_tween.tween_property(reel,"position:y" , tareget_y,2)
	elif rand_animation == 2 :
		stop_tween.set_trans(Tween.TRANS_BACK)
		stop_tween.set_ease(Tween.EASE_OUT)
		stop_tween.tween_property(reel,"position:y" , tareget_y,3)
	else :
		stop_tween.set_trans(Tween.TRANS_QUAD)
		stop_tween.set_ease(Tween.EASE_OUT)
		stop_tween.tween_property(reel,"position:y" , tareget_y,0.2)
		
	prize_number = (turn_list[prize_index])
