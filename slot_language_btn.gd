extends VBoxContainer
class_name language

#@onready var lan_tw : TextureRect = $tw
@onready var lan_en : TextureRect = $now_lan_btn/en
@onready var lan_th : TextureRect = $now_lan_btn/th
@onready var lan_vi : TextureRect = $now_lan_btn/vn

@onready var main_button : Button = $now_lan_btn
@onready var lan_select : VBoxContainer = $lan_select

#定義每次進來翻譯的項目是什麼
var default_lan = 0

func _ready() -> void:
	lan_select.visible = false
	default_lan = settings.set_default_lan
	#self.lan_new.connect(_my_get)
	hide_lan()
	language_btn(default_lan)
	
	main_button.button_down.connect(_on_main_button_down)
	$lan_select/th_btn.button_down.connect(language_btn.bind(0))
	$lan_select/vn_btn.button_down.connect(language_btn.bind(1))
	$lan_select/en_btn.button_down.connect(language_btn.bind(2))
	
	pass

#func _my_get(index):
	#print("內容物是",index)
	
#把所有按鈕按鍵隱藏起來
func hide_lan():
	#lan_tw.visible = false
	lan_en.visible = false
	lan_th.visible = false
	lan_vi.visible = false

func _on_main_button_down() -> void:
	lan_select.visible = !lan_select.visible
	
#用來看Option裡面的現在是哪個，接到值以後顯示
func language_btn(index : int):
	#default_lan = index
	match index:
		0:
			hide_lan()
			lan_th.visible = true
			lan_select.visible = false
		1:
			hide_lan()
			lan_vi.visible = true
			lan_select.visible = false
		2:
			hide_lan()
			lan_en.visible = true
			lan_select.visible = false
	
	settings.set_default_lan = index
	settings.save_settings()
