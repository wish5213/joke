extends Control
class_name basic_slot

@onready var reel = $turntable/mask/reel
@onready var title_la = $text/title
@onready var content_la = $text/content


@onready var turn_all: TextureRect = $turntable/mask/reel/all
@onready var turn_angel: TextureRect = $turntable/mask/reel/angel
@onready var turn_myself: TextureRect = $turntable/mask/reel/myself
@onready var turn_youdrink: TextureRect = $turntable/mask/reel/youdrink
@onready var turn_secret: TextureRect = $turntable/mask/reel/secret

@onready var TurnName : Dictionary ={
	0 : turn_all,
	1 : turn_angel,
	2 : turn_myself,
	3 : turn_youdrink,
	4 : turn_secret,
	}

var photo_high : float = 290
var turn_list : Array = []

var use_change_lan_prize_number : int = -1
var lan_now : String = "zh_TW"
var lan_type : Dictionary = {
	0 : "th",
	1 : "vi",
	2 : "en",
}


func _ready() -> void:
	title_la.visible = false
	content_la.visible = false

func bulid_reel_photos(master_array : Array):
	turn_list = master_array.duplicate()
	
	for i in range(turn_list.size()):
		var tex = TextureRect.new()
		tex.texture = TurnName[turn_list[i]]
		tex.position.y = i * photo_high
		reel.add_child(tex)
	
	reel.position.y = -(photo_high * turn_list.size())
	
func set_reel_y(new_y: float):
	reel.position.y = new_y
	
func trigger_prize_text(text_number : int):
	TranslationServer.set_locale(lan_now)
	
	title_la.visible = true
	content_la.visible = true
	use_change_lan_prize_number = text_number
	
	var target_number = text_number
	if target_number == 4:
		target_number = randi_range(4,9)
		
	title_la.text = tr(str(target_number) + "_title")
	content_la.text = tr(str(target_number) + "_content")
	
func switch_language(select_index : int):
	if lan_now == "zh_TW" :
		lan_now = lan_type[select_index]
	else:
		lan_now = "zh_TW"
		
	TranslationServer.set_locale(lan_now) 
