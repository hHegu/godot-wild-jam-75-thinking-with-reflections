extends CharacterBody2D
class_name Actor

const MAX_Y_VELOCITY := 600.0
@export var friction := 2.0
@export var air_friction := 1.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var GRAVITY: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var GRAVITY_VECTOR := Vector2.DOWN * GRAVITY

func apply_gravity(delta: float):
	velocity.y += GRAVITY * delta
	velocity.y = min(velocity.y, MAX_Y_VELOCITY)
	
func apply_friction(multiplier = 1.0):
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, friction * multiplier)
	else:
		velocity.x = move_toward(velocity.x, 0, air_friction * multiplier)

func take_damage(_damage: int, _source: Node2D = null):
	pass

func die():
	pass
