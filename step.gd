extends Button
class_name step

#此控制按鈕畫面的類型
enum SqName{
	EMPTY,
	MINE,
	JOKER
}

@onready var sq_squera: TextureRect = $square
@onready var sq_empty: TextureRect = $empty
@onready var sq_mine: TextureRect = $mine
@onready var sq_joker: TextureRect = $joker

var slot_scene = preload("res://clownslot.tscn")

#var type: StepType = StepType.EMPTY
var ud_squera: bool = false
var sq_type = 0 

#原本是用pressed，但因為他需要點擊再放開，造成卡頓感，改成down以後沒這問題
func _ready() -> void:
	button_down.connect(_on_pressed)
	again()

func again():
	hide_all()
	sq_squera.visible = true
	ud_squera = false
	disabled = false


#卡面清空
func hide_all() -> void:
	sq_squera.visible = false
	sq_empty.visible = false
	sq_mine.visible = false
	sq_joker.visible = false

func _on_pressed() -> void:
	if ud_squera == true :
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
			sq_squera.visible = false
		
			match sq_type:
				0:
					#SpName.EMPTY
					sq_empty.visible = true
					audiomanager.play_sfx("empty")
		
				1:
					#SpName.MINE
					sq_mine.visible = true
					audiomanager.play_sfx("bomb")
		
				2:
					#SpName.JOKER
					sq_joker.visible = true
					#await get_tree().create_timer(0.3).timeout
					audiomanager.back_eff_sp()
					var new_slot = slot_scene.instantiate()
					get_tree().current_scene.add_child(new_slot)
	)
	#動畫特效，回彈的部分
	tween.tween_property(self ,"scale",Vector2.ONE,0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self,"modulate",Color.WHITE,0.12)


func _on_button_button_down() -> void:
	again()
