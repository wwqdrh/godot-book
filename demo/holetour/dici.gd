extends Node2D

@onready var dici: Node2D = $"."

func _process(delta: float) -> void:
	position.y -= delta * 250

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()

func flip_h():
	dici.scale.x *= -1

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.hit()
