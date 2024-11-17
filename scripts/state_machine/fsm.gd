extends Node
class_name FSM

@export var current_state: State = null

@onready var initial_state := current_state

# Call this when you want to change the state. 
# @new_state_name: the name of the state node to be switched to
func change_state(new_state_name: String, data: Dictionary = {}) -> void:
	var new_state: State = get_node_or_null(new_state_name)
	
	if new_state == null:
		print('ERROR: State % is not in the screne tree!' % new_state_name)
	
	if not new_state.state_should_enter(): return
	
	if current_state != null:
		current_state.on_state_exit()
		
	current_state.is_active = false

	new_state.is_active = true
	new_state.activation_time = Time.get_ticks_msec()
	
	new_state.on_state_enter(data)
	
	current_state = new_state


func _process(delta: float):
	if current_state == null: return
	
	current_state.state_process(delta)


func _physics_process(delta: float):
	if current_state == null: return
	
	current_state.state_physics_process(delta)


func _input(event: InputEvent):
	if current_state == null: return
	
	current_state.state_input(event)


func reset_to_initial_state():
	change_state(initial_state.name)
