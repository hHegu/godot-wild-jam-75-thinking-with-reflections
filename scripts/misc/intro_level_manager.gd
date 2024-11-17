extends Node

@export var restart_text: RichTextLabel

var player_has_died := false

func _ready() -> void:
	SignalBus.player_died.connect(func(): 
		player_has_died = true
		show_text()
	)
	
	get_tree().create_timer(10).timeout.connect(func(): if(!player_has_died): show_text())


func show_text():
	create_tween().tween_property(restart_text, 'visible_ratio', 1, 1.0)
