extends CharacterBody2D

var pushing_players: Array[Player] = []

@onready var initial_position = self.global_position


func _ready() -> void:
	SignalBus.playback_reset.connect(reset_to_initial_state)
	SignalBus.playback_started.connect(func(_x): reset_to_initial_state())
	pass


func reset_to_initial_state():
	await get_tree().create_timer(0.1).timeout
	velocity = Vector2.ZERO
	global_position = initial_position

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if pushing_players:
		var dir: float = global_position.x - pushing_players.back().global_position.x
		velocity.x = signf(dir) * 100
	else:
		velocity.x = 0

	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		pushing_players.append(body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		pushing_players.erase(body)
