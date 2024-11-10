## 地图搭建

这一部分需要快速的搭建出地图以及地形

添加tilemap节点，`16*16`大小，随意绘制一块草地

## 跟节点，状态相关

```godot
# main.gd
extends Node2D

enum States {MOVE, DIALOG, CUT_SCENE}

var state := States.MOVE
```

## 添加npc

添加npc，碰撞

- area2D
  - sprite2d
  - collision

```godot
# npc.gd
extends Area2D

@export var indicator_color := Color.SANDY_BROWN

var _player :CharacterBody2D = null


# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body:PhysicsBody2D) -> void:
	if body is CharacterBody2D:
		var indicator := Sprite2D.new()
		indicator.name = "InteractionIndicator"
		indicator.texture = preload("res://Assets/interaction.png")
		indicator.modulate = indicator_color
		indicator.scale = Vector2(10,10)/indicator.texture.get_size()
		add_child(indicator)
		indicator.position = Vector2(0,-10)

		_player = body


func _on_body_exited(body:PhysicsBody2D) -> void:
	if body is CharacterBody2D:
		if has_node('InteractionIndicator'):
			get_node('InteractionIndicator').queue_free()
```

## 添加玩家

添加玩家，碰撞，人物的移动

- characterbody2d
  - sprite2d
  - camera2d
  - collision2d

```godot
# player.gd
extends CharacterBody2D

@export var SPEED := 100

func _process(delta:float) -> void:
	if owner.state != owner.States.MOVE:
		return

	var direction := Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))

	velocity = direction.normalized()*SPEED*delta*50

	if direction.x != 0:
		$Sprite.flip_h = direction.x < 0

	move_and_slide()

func zoom_in() -> void:
	var tween := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($Camera2D, "zoom", Vector2(6,6), 1)


func zoom_out() -> void:
	var tween := create_tween().set_trans(Tween.TRANS_QUAD)
	tween.tween_property($Camera2D, "zoom", Vector2(5,5), 1).set_ease(Tween.EASE_IN_OUT)
```

## 添加对话功能

player

- characterbody2d
  - bubblemarker

npc

- area2d
  - ...
  - bubblemarker

下载插件，编辑对话内容，运行，展示效果

添加交互按键

```godot
# npc.gd
@export var timeline : DialogicTimeline
@export var next_label := ""
@export var character :DialogicCharacter = null

# 添加交互按键
func _input(_event:InputEvent):
	if Input.is_action_just_pressed("interact"):
		if !has_node("InteractionIndicator"):
			return
		get_node('InteractionIndicator').queue_free()

		if has_node('Sprite') and _player:
			get_node('Sprite').flip_h = _player.position.x < position.x
			_player.get_node('Sprite').flip_h =  _player.position.x > position.x
			_player.get_node('Camera2D').align()
			_player.get_node('Camera2D').position = global_position-_player.global_position
			_player.zoom_in()

		if timeline:
			owner.state = owner.States.DIALOG
			get_viewport().set_input_as_handled()
			Dialogic.Styles.load_style('SmallRPG_Style')
			var node := Dialogic.start(timeline, next_label)
			if _player:
				node.register_character(load("res://Timelines/Player.dch"), _player.get_node('BubbleMarker'))

			if character:
				node.register_character(character, $BubbleMarker)


			Dialogic.timeline_ended.connect(_on_dialog_end)
			if not Dialogic.signal_event.is_connected(_on_dialogic_signal_event):
				Dialogic.signal_event.connect(_on_dialogic_signal_event)
```