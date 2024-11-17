extends State

@onready var player: Player = owner

const WORLD_COLLIDER = 1

func on_state_enter(_data: Dictionary = {}):
	player.animated_sprite.rotation_degrees = 90
	player.collision_layer += WORLD_COLLIDER
	


func on_state_exit():
	player.animated_sprite.rotation_degrees = 0
	player.collision_layer -= WORLD_COLLIDER


func state_physics_process(delta: float):
	player.apply_gravity(delta)
	player.apply_friction()
	player.move_and_slide()
