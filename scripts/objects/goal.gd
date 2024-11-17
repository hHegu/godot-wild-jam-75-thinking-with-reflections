extends Area2D

@export var next_level: LevelResource

func _on_body_entered(body: Node2D) -> void:
	if(next_level):
		SignalBus.level_changed.emit(next_level)
	else:
		SignalBus.go_to_next_level.emit()
