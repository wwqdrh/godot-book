extends Node2D

@onready var label: Label = $UILose/Label
@onready var background: Node2D = $Background
@onready var player: Node2D = $Player
@onready var countdown: Node2D = $Countdown


func _ready() -> void:
	State.player_die.connect(func():
		get_tree().paused = true
		var tween = get_tree().create_tween().set_ease(Tween.EASE_IN)
		tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		tween.tween_property(label, "self_modulate", Color(1, 1, 1, 1), 2)
	)
