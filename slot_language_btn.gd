extends OptionButton
class_name language

#@onready var lan_tw : TextureRect = $tw
@onready var lan_en : TextureRect = $en
@onready var lan_th : TextureRect = $th
@onready var lan_vi : TextureRect = $vn

#定義每次進來翻譯的項目是什麼
var default_lan = 2

func _ready() -> void:
	item_selected.connect(language_btn)
	#self.lan_new.connect(_my_get)
	#add_lan()
	hide_lan()
	select(default_lan)
	language_btn(default_lan)
	#lan_th.visible = true
	pass

#func _my_get(index):
	#print("內容物是",index)
	
#把所有按鈕按鍵隱藏起來
func hide_lan():
	#lan_tw.visible = false
	lan_en.visible = false
	lan_th.visible = false
	lan_vi.visible = false

#用來看Option裡面的羨慕是哪個，接到值以後顯示
func language_btn(index : int):
	default_lan = index
	match index:
		0:
			hide_lan()
			lan_th.visible = true
		1:
			hide_lan()
			lan_vi.visible = true
		2:
			hide_lan()
			lan_en.visible = true
