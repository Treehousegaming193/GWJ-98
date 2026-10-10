extends CharacterBody2D


@export var jump_speed: float = 120
@export var speed: float = 100
@export var max_jump_frames: int = 5

@export_category("Wind")
@export var wind_direction_left: bool = false
@export var wind_speed: float = 50

var jump_frame_count: int = 0


func _physics_process(delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var want_jump = Input.is_action_just_pressed("jump")

	if is_on_floor():
		velocity = Vector2.ZERO
		if wind_direction_left:
			velocity.x -= wind_speed
		if !wind_direction_left:
			velocity.x += wind_speed
		if want_jump:
			jump_frame_count = 0
			velocity.x = input_dir.x * speed
			velocity.y -= jump_speed
	else:
		# Variable jump height up to max while holding
		if Input.is_action_pressed("jump") and jump_frame_count < max_jump_frames:
			jump_frame_count += 1
			velocity.y -= jump_speed
		else:
			jump_frame_count = max_jump_frames
		velocity += get_gravity() * delta
		velocity.x = lerp(velocity.x, input_dir.x * speed, delta * 10)



	move_and_slide()
