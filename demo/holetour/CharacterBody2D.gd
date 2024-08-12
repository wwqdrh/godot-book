class_name Player

extends CharacterBody2D

@onready var player: Node2D = $".."
@onready var die_audio: AudioStreamPlayer = $"../DieAudio"

func hit():
	die_audio.play()
	State.player_die.emit()
	queue_free()
