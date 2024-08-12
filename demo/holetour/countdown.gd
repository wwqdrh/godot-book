extends Node2D

@onready var label: Label = $Label

var score = 0

func _ready() -> void:
	var timer = Timer.new()
	timer.set_wait_time(1)
	timer.set_one_shot(false)
	timer.timeout.connect(func():
		score += 1
		label.text = "Score: %d" % score
	)
	add_child(timer)
	timer.start()
