extends Resource
class_name PlayerStats

@export_category("Common")
## Move speed of the character
@export var speed := 80.0
## How fast the character accelerates to their move speed
@export var acceleration := 60.0
## How fast the character slows down
@export var friction := 10.0
## How fast the character slows down in air
@export var air_friction := 10.0
## How high can the player jump
@export var jump_strength := -200.0
## What is the minimum jump height if jump is just tapped
@export var min_jump_strength := -100.0

@export_category("Timers")
## Time before player can't jump after falling off a ledge
@export var coyote_time := 0.1
## Buffered input if player presses the jump in the air
@export var jump_buffer_time := 0.1

@export_category("Gravity")
## Gravity :)
@export var gravity := 80.0
## Gravity addition for when the player falls
@export var fast_fall_gravity_addition := 400.0
## The maximum fall speed
@export var max_fall_speed := 600.0

@export_category("Dash")
## How long the dash takes
@export var dash_duration := 0.2
## The speed of the dash
@export var dash_speed := 230.0
