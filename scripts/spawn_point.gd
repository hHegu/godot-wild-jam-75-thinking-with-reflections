extends Node2D


var player_preload = preload("res://scenes/player/player.tscn")


func _ready() -> void:
	SignalBus.playback_started.connect(on_playback_started)



func on_playback_started(should_spawn_player: bool):
	if !should_spawn_player: return

	var player_i: Player = player_preload.instantiate()

	player_i.global_position = global_position
	
	player_i.start_recording()

	Utils.get_level_root().add_child(player_i)
