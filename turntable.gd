extends Sprite2D

@onready var turn_all: TextureRect = $all
@onready var turn_angel: TextureRect = $angel
@onready var turn_myself: TextureRect = $myself
@onready var turn_youdrink: TextureRect = $youdrink
@onready var turn_secret: TextureRect = $secret

var turn_high:float = 293.5
var turn_list:Array = []
@onready var turn_container = $turntalbe

@onready var TurnName:Dictionary ={
	0 : turn_all,
	1 : turn_angel,
	2 : turn_myself,
	3 : turn_youdrink,
	4 : turn_secret,
	}


func _ready() -> void:
		hide_turn_all()
		_spin_photo()
		
		pass

func hide_turn_all():
	turn_all.visible = false
	turn_angel.visible = false
	turn_myself.visible = false
	turn_youdrink.visible = false
	turn_secret.visible = false

func _spin_photo():
	for i in range(5):
		turn_list.append(i)
		turn_list.append(randi_range(0,4)) 
		turn_list.append(randi_range(0,4))
	
	turn_list.shuffle()

	var tex = TextureRect.new()
	print(tex)
	
	
	
	#for i in range(turn_list.size()):
	
	
	
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
