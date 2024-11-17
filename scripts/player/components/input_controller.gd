extends Node
class_name InputController

signal frame_changed(frame: int)
signal recording_started
signal recording_stopped

## Fallbacks for when there is no recorded data. ALso serves as documentation on the types of inputs
var input_defaults := {
	# horizontal input -1 to 1
	"input_x": 0.0,
	"input_y": 0.0,
	"jump_just_pressed": false,
	"jump_just_released": false
}

var recorded_inputs: Array[Dictionary] = []

var current_frame := 0

@onready var owner_starting_pos: Vector2 = owner.global_position

## Is the player currently recording inputs?
var is_recording := false


func _physics_process(_delta: float):
	if is_recording:
		recorded_inputs.append(get_inputs_dict())

	current_frame += 1
	frame_changed.emit(current_frame)

## Gets a dictionary with current inputs
func get_inputs_dict() -> Dictionary:
	return {
		"input_x": Input.get_axis("left", "right"),
		"jump_just_pressed": Input.is_action_just_pressed("jump"),
		"jump_just_released": Input.is_action_just_released("jump")
	}


func start_recording() -> void:
	is_recording = true
	recording_started.emit(current_frame)


func get_input(input_key: String):
	if recorded_inputs.size() <= current_frame and !is_recording:
		return input_defaults[input_key]
	
	var current_input = get_inputs_dict() if is_recording else recorded_inputs[current_frame]
	return current_input.get(input_key)


func get_input_x() -> float: return get_input('input_x')


func clear_recording() -> void:
	recorded_inputs.clear()


func reset() -> void:
	recording_stopped.emit()
	is_recording = false
	current_frame = 0
	owner.velocity = Vector2.ZERO
	owner.global_position = owner_starting_pos
