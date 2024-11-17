extends Node

@export var button: Button2D
@export var anim: AnimationPlayer

@export var animation_name: = "activate"

@export var reverse := false

func _ready() -> void:
	if reverse:
		anim.play(animation_name)

	button.was_pressed.connect(play_animation)


func play_animation(is_pressed: bool):
	if is_pressed:
		if reverse:
			anim.play_backwards(animation_name)
		else:
			anim.play(animation_name)
	else:
		if reverse:
			anim.play(animation_name)
		else:
			anim.play_backwards(animation_name)
