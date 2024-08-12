extends Node2D

@export var gravity = 1980  # 重力加速度
@export var jump_force = 1200  # 跳跃力度

var is_active = true
var is_jumping = false
var platform_mode: int = 0 # 0在左边，1在右边

@onready var jump_audio: AudioStreamPlayer = $JumpAudio
@onready var player: CharacterBody2D = $CharacterBody2D
@onready var normal: Sprite2D = $CharacterBody2D/Normal

func _ready():
	set_platform_mode()

func set_platform_mode(arg:=platform_mode):
	platform_mode = arg
	if arg == 0:
		player.set_up_direction(Vector2.RIGHT)
		gravity = -abs(gravity)
		jump_force = abs(jump_force)
	else:
		player.set_up_direction(Vector2.LEFT)
		gravity = abs(gravity)		
		jump_force = -abs(jump_force)	

func _physics_process(delta):
	if !is_active:
		return
	if not player:
		return
		
	# 应用水平重力
	if not player.is_on_floor():
		player.velocity.x += gravity * delta
	
	# 限制最大下落速度
	player.velocity.x = min(player.velocity.x, 1000)
	
	player.move_and_slide()
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var screen_size = get_viewport().get_visible_rect().size
		var click_position = event.position
		
		jump_audio.play()
		if click_position.x < screen_size.x / 2:
			move_to_left()
		else:
			move_to_right()
		
		if player.is_on_floor():
			player.velocity.x = jump_force
			is_jumping = true


func move_to_left():
	var screen_size = get_viewport().get_visible_rect().size
	var player_position = player.position
	
	if player_position.x < screen_size.x / 2:
		return
	
	
	is_active = false
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	# 添加属性动画
	tween.tween_property(player, "position:x", player.position.x - 600, 0.3)
	# 可选: 在动画完成时调用一个函数
	tween.tween_callback(func():
		set_platform_mode(0)
		normal.flip_h = false		
		is_active = true
	)
	


func move_to_right():
	var screen_size = get_viewport().get_visible_rect().size
	var player_position = player.position
	
	if player_position.x > screen_size.x / 2:
		return
	
	is_active = false
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	# 添加属性动画
	tween.tween_property(player, "position:x", player.position.x + 600, 0.3)
	# 可选: 在动画完成时调用一个函数
	tween.tween_callback(func():
		set_platform_mode(1)
		normal.flip_h = true
		is_active = true
	)
	
