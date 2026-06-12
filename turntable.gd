extends Control

#定義圖片跟按鈕切換
@onready var turn_all: TextureRect = $mask/reel/all
@onready var turn_angel: TextureRect = $mask/reel/angel
@onready var turn_myself: TextureRect = $mask/reel/myself
@onready var turn_youdrink: TextureRect = $mask/reel/youdrink
@onready var turn_secret: TextureRect = $mask/reel/secret

#定義按鈕位置
@onready var stop_button = $"../stop_trans/stop"
@onready var trans_button = $"../stop_trans/translate"

@onready var lan_trans = $"../text"



#定義裝圖片的容器
@onready var reel = $mask/reel

#定義各項函數
var photo_high:float = 290
var turn_list:Array = [0,1,2,3,4,0,1,2,3,4,0,1,2,3,4,0,1,2,3,4,0,1,2,3,4,
0,1,2,3,4,0,1,2,3,4,0,1,2,3,4,0,1,2,3,4,0,1,2,3,4,0,1,2,3,4,0,1,2,3,4,0,1,
2,3,4,0,1,2,3,4,0,1,2,3,4,0,1,2,3,4,0,1,2,3,4,0,1,2,3,4,0,1,2,3,4,0,1,2,3,4,
0,1,2,3,4,0,1,2,3,4,0,1,2,3,4,0,1,2,3,4,0,1,2,3,4,0,1,2,3,4,0,1,2,3,4,0,1,2,3,4]
var is_reeling : bool = false
var reel_tween : Tween
var spin_tween : Tween
var button_type : String = "stop"
var aaa = "zh_TW"

signal prize_number
#signal lan_new

@onready var TurnName:Dictionary ={
	0 : turn_all,
	1 : turn_angel,
	2 : turn_myself,
	3 : turn_youdrink,
	4 : turn_secret,
	}
	
func _ready() -> void:
	pass
	_reel_photo(turn_list)
	start_spin()
	#self.prize_number.connect(_on_text_signal)
	
#func _on_text_signal(get_singal):
	#print ("獎項是" ,get_singal)

func _reel_photo(master_array : Array):
	turn_list = master_array.duplicate()
	
	for i in range(turn_list.size()):
		var tex = TextureRect.new()
		tex.texture = TurnName[turn_list[i]].texture
		tex.position.y = i * photo_high
		reel.add_child(tex)
	
	reel.position.y = -(photo_high * turn_list.size())
	
	start_spin()

#輪盤旋轉
func start_spin():
	#判斷狀態是不是在選轉，如果是就跳出
	if is_reeling == true:
		return
	is_reeling = true
	reel_tween = create_tween()
	var total_reel_high = reel.position.y + (photo_high * turn_list.size())
	reel_tween.tween_property(reel,"position:y",total_reel_high, 15)
	
	#倒數10秒後自動停止
	await get_tree().create_timer(10.0).timeout
	if is_reeling == true:
		stop_spin()


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
	
	button_type = "trans"
	await stop_tween.finished
	prize_number.emit(turn_list[prize_index])
	stop_button.visible = false
	

func _on_change_button() -> void:
	match button_type:
		"stop" : 
			stop_spin()
		
		"trans":
			lan_trans.tw_to_ano()
