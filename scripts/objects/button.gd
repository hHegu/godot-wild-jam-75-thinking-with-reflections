extends Area2D
class_name Button2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
signal was_pressed(pressed: bool)

var pressed := false :
	set(new_value):
		if(new_value != pressed): 
			was_pressed.emit(new_value)
			animated_sprite_2d.play("pressed" if new_value else "not_pressed")
		pressed = new_value
		
var body_count := 0

func _on_body_entered(body: Node2D) -> void:
	body_count += 1
	pressed = true


func _on_body_exited(body: Node2D) -> void:
	body_count -= 1
	pressed = body_count > 0
