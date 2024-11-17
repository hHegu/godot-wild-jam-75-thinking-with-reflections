extends State

@export var jump_particle_effect: PackedScene
@export var landing_particle_effect: PackedScene

var coyote_timer: Timer
var jump_buffer_timer: Timer
var dash_buffer_timer: Timer

var is_jump_buffered := false
var is_coyote_time := false
var is_dash_buffered := false

var friction_multiplier := 1.0
var friction_multiplier_tween: Tween

@onready var _player: Player = owner

func _ready():
	coyote_timer = Utils.create_timer(self, _player.stats.coyote_time)
	jump_buffer_timer = Utils.create_timer(self, _player.stats.jump_buffer_time)
	dash_buffer_timer = Utils.create_timer(self, _player.stats.jump_buffer_time)


func on_state_enter(data: Dictionary = {}):
	super()
	if not data.has('friction_multiplier') or not data.has('velocity') or not data.has('friction_duration'): return
	friction_multiplier = data.get('friction_multiplier')
	
	if friction_multiplier_tween:
		friction_multiplier_tween.stop()
	
	friction_multiplier_tween = get_tree().create_tween().set_ease(Tween.EASE_OUT)
	friction_multiplier_tween.tween_property(self, 'friction_multiplier', 1.0, data.get('friction_duration'))
	friction_multiplier_tween.play()
	_player.velocity = data.get('velocity')


func state_physics_process(delta):
	is_jump_buffered = not jump_buffer_timer.is_stopped()
	is_coyote_time = not coyote_timer.is_stopped()
	is_dash_buffered = not dash_buffer_timer.is_stopped()

	_player.turn_towards_input_direction()
#	_player.turn_towards_mouse_position()

	# Add the gravity.
	if not _player.is_on_floor():
		_player.apply_gravity(delta)
		# If we are falling, add fast fall
		if _player.velocity.y > 0: fast_fall(delta)

	handle_jump()

#	handle_dash()

	# Get the input direction and handle the movement/deceleration.
	_player.handle_controlled_movement(friction_multiplier)

	var was_on_floor = _player.is_on_floor()
	var was_on_air = !was_on_floor
	
	if was_on_floor:
		friction_multiplier = 1.0

	# _player.step_particles.emitting = abs(_player.velocity.x) > 0 and _player.is_on_floor()

	_player.move_and_slide()
	
	var just_left_ground = not _player.is_on_floor() and was_on_floor
	var just_landed = _player.is_on_floor() and was_on_air
	
	# Start coyote time if we just left the floor and are not jumping 
	if just_left_ground and _player.velocity.y >= 0:
		coyote_timer.start()
	
	# if just_landed:
	# 	spawn_landing_particles()
	
	handle_animations()
	

func can_jump() -> bool: return _player.is_on_floor() or is_coyote_time


func fast_fall(delta: float) -> void: _player.velocity.y += _player.stats.fast_fall_gravity_addition * delta


func handle_jump():
	var jump_just_pressed = _player.input.get_input("jump_just_pressed")
	if jump_just_pressed or is_jump_buffered:
		if can_jump():
			_player.velocity.y = _player.stats.jump_strength
			# spawn_jump_particles()
			jump_buffer_timer.stop()
		
		if jump_just_pressed and not can_jump():
			jump_buffer_timer.start()
	
	# Handle variable jump height
	if _player.input.get_input("jump_just_released") and _player.velocity.y < _player.stats.min_jump_strength:
		_player.velocity.y = _player.stats.min_jump_strength


func handle_dash():
	var can_dash = _player.is_on_floor()
	var dash_just_pressed := Input.is_action_just_pressed("dash")
	if dash_just_pressed or is_dash_buffered:
		if can_dash:
			fsm.change_state(_player.states.Dash)
			dash_buffer_timer.stop()
		
		if dash_just_pressed and not can_dash:
			dash_buffer_timer.start()


# func spawn_jump_particles():
# 	if not jump_particle_effect: return

# 	var root = Utils.get_level_root()
# 	var particle_i: GPUParticles2D = Utils.instantiate_node_at_global_position(jump_particle_effect, root, _player.step_particles.global_position)
# 	particle_i.scale.x = _player.get_look_direction()

# func spawn_landing_particles():
# 	if not landing_particle_effect: return
	
# 	var root = Utils.get_level_root()
# 	Utils.instantiate_node_at_global_position(landing_particle_effect, root, _player.step_particles.global_position)

func handle_animations():
	var anim := _player.animated_sprite
	
	if _player.velocity.length() == 0:
		anim.play('default')
	elif abs(_player.velocity.y) > 0:
		anim.play('jump')
	else:
		anim.play('run')
