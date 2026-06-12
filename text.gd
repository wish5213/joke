extends Control
class_name text

@onready var title_la = $title
@onready var content_la = $content
@onready var turntable_slot = $"../turntable"

@onready var lan_trans = $language_btn
var use_change_lan_prize_number = -1

@onready var lan_type:Dictionary ={
	0 : "th",
	1 : "vi",
	2 : "en",
	}

var lan_new : String = "zh_TW"

func _ready() -> void:
	turntable_slot.prize_number.connect(transtext)
	title_la.visible = false
	content_la.visible = false

func transtext(text_number : int):
	title_la.visible = true
	content_la.visible = true
	use_change_lan_prize_number = text_number
	
	if text_number == 4:
		text_number = randi_range(4,9)
		title_la.text = tr(str(text_number)+"_title")
		content_la.text = tr(str(text_number)+"_content")
	else:
		title_la.text = tr(str(text_number)+"_title")
		content_la.text = tr(str(text_number)+"_content")

			
func tw_to_ano():
	if lan_new == "zh_TW":
		lan_new = lan_type[lan_trans.default_lan]
	else:
		lan_new = "zh_TW"
		
	TranslationServer.set_locale(lan_new)
	transtext(use_change_lan_prize_number)
