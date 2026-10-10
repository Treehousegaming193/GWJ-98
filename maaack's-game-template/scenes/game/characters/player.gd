extends CharacterBody2D


@export var jump_speed: float = 40
@export var speed: float = 150
@export var max_jump_frames: int = 15

@export_category("Wind")
@export var wind_direction_left: bool = false
@export var wind_speed: float = 20
@export var max_wind_speed: float = 30
@export var min_wind_speed: float = 10

var jump_frame_count: int = 0

@onready var jump_strength_indicator: Line2D = %JumpStrengthIndicator


func _physics_process(delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var want_jump = Input.is_action_just_pressed("jump")

	if is_on_floor():
		jump_strength_indicator.set_point_position(1, Vector2(0, 0))
		velocity = Vector2.ZERO
		if want_jump:
			jump_frame_count = 0
			velocity.x = input_dir.x * speed
			velocity.y -= jump_speed
	else:
		# Variable jump height up to max while holding
		if Input.is_action_pressed("jump") and jump_frame_count < max_jump_frames:
			jump_frame_count += 1
			velocity.y -= jump_speed
			var jump_strength: float = jump_frame_count / float(max_jump_frames) * 30
			jump_strength_indicator.set_point_position(1, Vector2(0, -jump_strength))
		else:
			jump_frame_count = max_jump_frames
		velocity += get_gravity() * delta
		velocity.x = lerp(velocity.x, input_dir.x * speed, delta * 10)
		if wind_direction_left:
			velocity.x -= wind_speed
		if !wind_direction_left:
			velocity.x += wind_speed

	move_and_slide()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("wind_change_test"):
		wind_direction_left = !wind_direction_left

func _on_wind_timer_timeout() -> void:
	var wind_chance = randi_range(1, 10)
	print(wind_chance)
	if wind_chance == 1:
		wind_direction_left = !wind_direction_left
	if wind_chance == 2 or 3:
		wind_speed = randf_range(min_wind_speed, max_wind_speed)
