extends Actor
class_name Player

@export var input: InputController
@export var stats: PlayerStats

@export var fsm: FSM

@onready var hitbox_area: Area2D = $Hitbox
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var is_initially_recording := false

@export_color_no_alpha var recording_color := Color.WHITE
@export var playback_color := Color.WHITE

# @onready var step_particles: GPUParticles2D = $SpriteContainer/StepParticles

const states = {
	"Move": "MoveState",
	"Dash": "DashState",
	"Death": "DeathState",
}

func _ready():
	friction = stats.friction
	air_friction = stats.air_friction

	SignalBus.playback_reset.connect(stop_and_reset_recording)
	SignalBus.playback_started.connect(start_playback)

	hitbox_area.body_entered.connect(func(_collider): die())

	if is_initially_recording: start_recording()

# Override default Actor apply_gravity
func apply_gravity(delta: float):
	velocity.y += stats.gravity * delta
	velocity.y = min(velocity.y, stats.max_fall_speed)


func turn_towards_input_direction():
	var direction := input.get_input_x()
	if direction:
		animated_sprite.scale.x = sign(direction)


func turn_towards_mouse_position():
	var look_dir_x = sign(get_global_mouse_position().x - global_position.x)
	if look_dir_x != 0:
		animated_sprite.scale.x = look_dir_x


func turn_towards_velocity():
	var velocity_sign = sign(velocity.x)
	if velocity_sign != 0:
		animated_sprite.scale.x = velocity_sign


func get_look_direction():
	return animated_sprite.scale.x


## 
func handle_controlled_movement(friction_multiplier = 1.0):
	# Get the input direction and handle the movement/deceleration.
	var direction := input.get_input_x()
	
	var is_current_speed_greater_than_movement_speed = abs(velocity.x) > stats.speed
	
	var direction_opposite_to_velocity_x = direction > 0 and velocity.x < 0
	
	var can_control = not is_current_speed_greater_than_movement_speed or direction_opposite_to_velocity_x
	
	if direction and can_control:
		velocity.x = move_toward(velocity.x, direction * stats.speed, stats.acceleration * (friction_multiplier * 0.5))
	else:
		apply_friction(friction_multiplier)


func die():
	if input.is_recording:
		SignalBus.player_died.emit()
	fsm.change_state(states.Death)


func enable_player():
	process_mode = Node.PROCESS_MODE_INHERIT


func start_recording():
	input.start_recording()
	modulate = recording_color
	enable_player()


func start_playback(_should_spawn_player: bool):
	input.is_recording = false
	modulate = playback_color
	enable_player()


func stop_and_reset_recording():
	fsm.reset_to_initial_state()
	input.reset()
	process_mode = Node.PROCESS_MODE_DISABLED
