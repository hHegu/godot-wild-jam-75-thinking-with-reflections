extends Node

signal playback_reset
signal playback_started(should_spawn_player: bool)

signal player_died

signal level_changed(level: LevelResource)
signal go_to_next_level
