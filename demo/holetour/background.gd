extends Node2D

const DICI = preload("res://dici.tscn")

@export var scroll_speed = -250  # 滚动速度，可以在检查器中调整

@onready var parallax_background: ParallaxBackground = $ParallaxBackground
@onready var left_dici: Marker2D = $LeftDici
@onready var right_dici: Marker2D = $RightDici

func _ready() -> void:
	var timer = Timer.new()
	timer.timeout.connect(spawn_dici)
	timer.set_wait_time(1.5)
	timer.set_one_shot(false)
	add_child(timer)
	timer.start()
	timer.emit_signal("timeout")

func _process(delta):
	# 更新滚动偏移
	parallax_background.scroll_offset.y += scroll_speed * delta
	
	
func spawn_dici():
	var dici = DICI.instantiate()
	add_child(dici)	
	if randf() <= 0.5:
		dici.flip_h()
		dici.position = left_dici.position
	else:
		dici.position = right_dici.position		
