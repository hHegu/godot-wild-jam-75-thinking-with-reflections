extends CanvasLayer

@onready var level_select_button: Button = $MainMenu/MainMenuButtonContainer/LevelSelectButton
@onready var exit_button: Button = $MainMenu/MainMenuButtonContainer/ExitButton
@onready var main_menu: Control = $MainMenu
@onready var back_button: Button = $LevelSelectContainer/BackToMainMenuButton
@onready var level_select_container: VBoxContainer = $LevelSelectContainer
@onready var level_select: VBoxContainer = %LevelSelect


@onready var pause_menu: Control = $PauseMenuContainer
@onready var pause_resume_button: Button = $PauseMenuContainer/PauseMenu/ResumeButton
@onready var pause_level_select_button: Button = $PauseMenuContainer/PauseMenu/LevelSelectButton
@onready var pause_exit_button: Button = $PauseMenuContainer/PauseMenu/ExitButton
@onready var pause_restart_button: Button = $PauseMenuContainer/PauseMenu/RestartButton

@onready var game_end_screen: ColorRect = $GameEndScreen

var previous_menu = "main"

func _ready() -> void:
	level_select_button.pressed.connect(show_level_select)
	
	back_button.pressed.connect(func():
		if previous_menu == "main":
			show_main_menu()
		if previous_menu == "pause":
			show_pause_menu
	)

	exit_button.pressed.connect(exit_game)
	
	pause_level_select_button.pressed.connect(show_level_select)
	pause_exit_button.pressed.connect(exit_game)
	pause_restart_button.pressed.connect(owner.restart_level)
	show_main_menu()


func hide_all():
	main_menu.visible = false
	level_select_container.visible = false
	pause_menu.visible = false


func show_level_select():
	print("show level select?")
	hide_all()
	level_select_container.visible = true
	level_select.get_child(0).grab_focus()


func show_main_menu():
	hide_all()
	main_menu.visible = true
	previous_menu = "main"
	level_select_button.grab_focus()
	


func show_pause_menu():
	hide_all()
	pause_menu.visible = true
	previous_menu = "pause"
	pause_resume_button.grab_focus()


func show_game_end_screen():
	hide_all()
	game_end_screen.visible = true


func exit_game():
	get_tree().quit()
