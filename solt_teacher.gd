extends Node2D

const ITEM_HEIGHT : float = 289.5

const IMG_MYSELF = preload("res://Image/slot/myself.png")
const IMG_ALL = preload("res://Image/slot/all.png")
const IMG_ANGEL = preload("res://Image/slot/angel.png")
const IMG_YOUDRINK = preload("res://Image/slot/youdrink.png")
const IMG_SECRET = preload("res://Image/slot/secret.png")

@onready var container = $mask/ItemsContainer

# 將預載圖片放入陣列供動態呼叫
var reel_data : Array = [IMG_MYSELF, IMG_ALL, IMG_ANGEL, IMG_YOUDRINK, IMG_SECRET]
var is_spinning : bool = false
var spin_tween : Tween

func _ready():
	# 1. 清空容器，動態生成 3 組（共 15 張）圖片，提供足夠的上下滾動緩衝區
	for child in container.get_children():
		child.queue_free()
		
	for i in range(15):
		var tex = TextureRect.new()
		tex.texture = reel_data[i % 5]
		tex.position.y = i * ITEM_HEIGHT
		container.add_child(tex)
		
	# 2. 初始時將容器大幅度往上提，保留足夠的圖片在畫面上方準備向下掉落
	container.position.y = -(ITEM_HEIGHT * 10)
	start_spin()

# 啟動滾動
func start_spin():
	if is_spinning: return
	is_spinning = true
	_ghost_spin()

# 高速假轉動循環
func _ghost_spin():
	spin_tween = create_tween()
	# 容器往下推動，視覺上圖案往下掉落
	spin_tween.tween_property(container, "position:y", container.position.y + (ITEM_HEIGHT * 2), 0.1)
	spin_tween.tween_callback(func():
		# 當掉落超過 5 格（一整組）的高度時，瞬間將 Y 軸上調 5 格
		# 由於圖片排列規律相同，視覺上無縫銜接
		if container.position.y >= -(ITEM_HEIGHT * 5):
			container.position.y -= (ITEM_HEIGHT * 5)
			
		if is_spinning:
			_ghost_spin()
	)

# 接收外框指令並精準停止
func stop_at_item(target_index: int):
	is_spinning = false
	if spin_tween and spin_tween.is_valid():
		spin_tween.kill()
	
	# 1. 鎖定陣列中間段（第 2 組，索引 5~9），確保停下時上下都有圖，不會黑屏
	var safe_target_index = target_index + 5
	var target_y = -(safe_target_index * ITEM_HEIGHT)
	
	# 2. 瞬間將容器切換到目標的「上方一格」
	container.position.y = target_y - ITEM_HEIGHT
	
	# 3. 在 0.3 秒內往下平滑滑入目標定位
	var stop_tween = create_tween()
	stop_tween.set_trans(Tween.TRANS_QUAD)
	stop_tween.set_ease(Tween.EASE_OUT)
	stop_tween.tween_property(container, "position:y", target_y, 0.3)
	
func _input(event):
	# 偵測是否按下空白鍵，且確保目前處於滾動狀態
		if event.is_action_pressed("ui_accept") and is_spinning:
		# 隨機產生 0 到 4 的整數，模擬抽籤結果
			var random_index = randi() % 5
		
		# 呼叫現有的停止函數
			stop_at_item(random_index)
