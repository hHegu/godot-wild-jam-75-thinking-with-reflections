extends VBoxContainer

signal level_was_pressed(level: LevelResource)

func on_level_pressed(level: LevelResource):
	level_was_pressed.emit(level)


func render_level_buttons(levels: Array[LevelResource]):
	for level in levels:
		var button := Button.new()
		button.text = level.level_name
		button.pressed.connect(func(): on_level_pressed(level))
		add_child(button)
