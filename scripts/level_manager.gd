extends Node


@export var is_playback_enabled := true

func _input(event: InputEvent):
	if (event.is_action_pressed("jump") or event.is_action_pressed("left") or event.is_action_pressed("right")) && !is_playback_enabled:
		SignalBus.playback_started.emit(true)
		is_playback_enabled = true

	if event.is_action_pressed("reset") && is_playback_enabled:
		SignalBus.playback_reset.emit()
		is_playback_enabled = false
