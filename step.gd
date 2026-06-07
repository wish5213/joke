extends Button
class_name step

#此控制按鈕畫面的類型
enum SpName{
	EMPTY,
	MINE,
	JOKER
}

@onready var sp_squera: TextureRect = $square
@onready var sp_empty: TextureRect = $empty
@onready var sp_mine: TextureRect = $mine
@onready var sp_joker: TextureRect = $joker

#var type: StepType = StepType.EMPTY
var ud_squera: bool = false
var sp_type = 0 

#負責傳裡面的資料出去
#signal cell_clicked(cell_type: StepType)

#原本是用pressed，但因為他需要點擊再放開，造成卡頓感，改成down以後沒這問題
func _ready() -> void:
	button_down.connect(_on_pressed)
	hide_all()
	sp_squera.visible = true

#卡面清空
func hide_all() -> void:
	sp_squera.visible = false
	sp_empty.visible = false
	sp_mine.visible = false
	sp_joker.visible = false

func _on_pressed() -> void:
	if ud_squera:
		return
	ud_squera = true
	disabled = true
	
	#動畫特效，往下縮的部分
	var tween = create_tween()
	pivot_offset = size / 2.0
	tween.tween_property(self, "scale", Vector2(0.9,0.9),0.05)
	tween.parallel().tween_property(self,"modulate", Color(0.8,0.8,0.8),0.05)
	
	tween.tween_callback(func():
	
			#定義每張卡的編號
			sp_squera.visible = false
		
			match sp_type:
				0:
					SpName.EMPTY
					sp_empty.visible = true
		
				1:
					SpName.MINE
					sp_mine.visible = true
		
				2:
					SpName.JOKER
					sp_joker.visible = true
	)
	#動畫特效，回彈的部分
	tween.tween_property(self ,"scale",Vector2.ONE,0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self,"modulate",Color.WHITE,0.12)
