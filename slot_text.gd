extends Control
class_name text

@onready var title_la = $title
@onready var content_la = $content
#@onready var turntable_slot = $"../turntable"

@onready var lan_trans = $language_btn
var use_change_lan_prize_number = -1
#var secret_array = [4,5,6,7,8,9]

#因為系統用的語言名稱跟大家習慣的不同像越南是VI，但習慣看VN，所以做一個字典來當翻譯文字用
@onready var lan_type:Dictionary ={
	0 : "th",
	1 : "vi",
	2 : "en",
	}

var lan_new : String = "zh_TW"

func _ready() -> void:
	#turntable_slot.prize_number.connect(transtext)
	title_la.visible = false
	content_la.visible = false

#畫面中產生文字的地方
func transtext(text_number : int):
	title_la.visible = true
	content_la.visible = true
	use_change_lan_prize_number = text_number
	
	title_la.text = tr(str(text_number)+"_title")
	content_la.text = tr(str(text_number)+"_content")
	
	#if text_number == 4:
		#text_number = secret_array.pick_random()
		##text_number = 7
		#title_la.text = tr(str(text_number)+"_title")
		#content_la.text = tr(str(text_number)+"_content")
		#use_change_lan_prize_number = text_number
	#else:
		#title_la.text = tr(str(text_number)+"_title")
		#content_la.text = tr(str(text_number)+"_content")
		
#翻譯按鈕作用的地方
func tw_to_ano():
	if lan_new == "zh_TW":
		lan_new = lan_type[lan_trans.default_lan]
	else:
		lan_new = "zh_TW"
		
	TranslationServer.set_locale(lan_new)
	transtext(use_change_lan_prize_number)


func _go_back_menu() -> void:
	get_tree().change_scene_to_file("res://text game.tscn")
	pass # Replace with function body.
