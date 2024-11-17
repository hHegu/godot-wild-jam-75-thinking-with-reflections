extends Node2D

@export var levels: Array[LevelResource]

@onready var world: Node2D = %World
@onready var level_select: VBoxContainer = %LevelSelect
@onready var ui: CanvasLayer = %UI
@onready var level_transition_anim: AnimationPlayer = %LevelTransition/AnimationPlayer

var current_level: LevelResource


func _ready() -> void:
	level_select.render_level_buttons(levels)
	level_select.level_was_pressed.connect(func(new_level: LevelResource): 
		change_level(new_level)
		ui.hide_all()
	)
	SignalBus.level_changed.connect(change_level)
	SignalBus.go_to_next_level.connect(go_to_next_level)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause()


func toggle_pause():
	var is_paused = world.process_mode == ProcessMode.PROCESS_MODE_DISABLED
	print(world.process_mode)
	
	if is_paused:
		ui.hide_all()
		world.process_mode = ProcessMode.PROCESS_MODE_INHERIT
	else:
		world.process_mode = ProcessMode.PROCESS_MODE_DISABLED
		ui.show_pause_menu()


func unpause():
	ui.hide_all()
	world.process_mode = ProcessMode.PROCESS_MODE_INHERIT


func change_level(level: LevelResource) -> void:
	level_transition_anim.play("transition_in")
	await level_transition_anim.animation_finished

	for child in world.get_children():
		world.remove_child(child)
		child.queue_free()

	world.add_child(level.level_scene.instantiate())
	
	level_transition_anim.play("transition_out")
	
	current_level = level
	
	unpause()


func restart_level():
	change_level(current_level)


func go_to_next_level():
	var current_level_index := levels.find(current_level)
	print(current_level.level_name)
	print(current_level_index)
	if(current_level_index == -1): return
	
	if(current_level_index >= levels.size() - 1):
		ui.show_game_end_screen()
		return
	
	change_level(levels[current_level_index + 1])
