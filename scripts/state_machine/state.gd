extends Node
class_name State

@onready var fsm: FSM = get_parent()

var is_active := false
var activation_time := Time.get_ticks_msec()

# Checked before state is changed. 
# State will not be changed if this is false
func state_should_enter():
	return true;

# Called when state is entered
func on_state_enter(_data: Dictionary = {}):
	activation_time = Time.get_ticks_msec()
	pass

# Called when state is exited
func on_state_exit():
	pass

# Same as _process, but called only when state is active
func state_process(_delta):
	pass

# Same as _physics_process, but called only when state is active
func state_physics_process(_delta):
	pass

# Same as _input, but called only when state is active
func state_input(_event: InputEvent):
	pass

# Gets the time that was elapsed since this state became active in ms
func get_time_since_activation():
	return Time.get_ticks_msec() - activation_time
