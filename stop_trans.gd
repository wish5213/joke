extends Control
class_name stop_trans

@onready var button_stop :TextureButton = $stop
@onready var button_trans :TextureButton = $translate

func _ready() -> void:
	button_trans.visible = false

func change_button():
	button_stop.visible = false
	button_trans.visible = true
