extends CharacterBody2D


@export var jump_speed: float = 100
@export var speed: float = 150
@export var max_jump_charge_secs: float = 1.5
@export var jump_charge_multiplier: float = 4.0

var jump_charge_secs: float = 0
var jump_strength: float = 0

@onready var flashlight: PointLight2D = %Flashlight
@onready var jump_strength_indicator: Line2D = %JumpStrengthIndicator
@onready var scarf_visual: Sprite2D = %ScarfVisual
@onready var visual: Sprite2D = %Visual
@onready var wind_indicator: Line2D = %WindIndicator


func _ready() -> void:
	add_to_group("player")


func _physics_process(delta: float) -> void:
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var want_jump = Input.is_action_just_released("jump")
	var want_charge_jump = Input.is_action_pressed("jump")

	if is_on_floor():
		velocity = Vector2.ZERO
		if want_jump:
			# ensure single frame tap gets a little jump
			if jump_charge_secs == 0:
				jump_charge_secs = delta
			jump_strength = jump_charge_secs * jump_charge_multiplier
			prints("jump_charge_secs", jump_charge_secs, "jump strength", jump_strength)
			velocity.x = input_dir.x * speed
			velocity.y -= jump_speed * jump_strength
			%JumpAudio.play()
			# rest jump charge
			jump_charge_secs = 0
		elif want_charge_jump:
			jump_charge_secs = min(jump_charge_secs + delta, max_jump_charge_secs)
			jump_strength_indicator.set_point_position(1, Vector2(0, -32 * jump_charge_secs / max_jump_charge_secs))
	else:
		jump_strength_indicator.set_point_position(1, Vector2(0, 0))
		velocity += get_gravity() * delta
		velocity.x = lerp(velocity.x, input_dir.x * speed, delta * 10)

	if input_dir:
		visual.flip_h = input_dir.x < 0
	move_and_slide()

	# Procedural scarf
	%scarf.velocity = Vector2.ZERO
	%scarf.position = position
	if Wind.wind_direction_left:
		velocity.x -= Wind.wind_speed
		%scarf.velocity.x = velocity.x + Wind.wind_speed
	if !Wind.wind_direction_left:
		velocity.x += Wind.wind_speed
		%scarf.velocity.x = velocity.x - Wind.wind_speed
	%scarf.move_and_slide()
	# Can't really parent physics bodies to each other
	# (well, you can, it just won't work like you hope, I think)
	# this is the biggest reason I think character body 2d isn't a good fit.
	# I would try a line2d and a shader like https://godotshaders.com/shader/2d-simple-animated-flag-shader/

	# for now, just an indicator of direction & speed
	var wsx: float = 2 * -Wind.wind_speed if Wind.wind_direction_left else Wind.wind_speed
	wind_indicator.set_point_position(1, Vector2(wsx, 0))
	scarf_visual.flip_h = !Wind.wind_direction_left


func _process(_delta: float) -> void:
	#if Input.is_action_just_pressed("wind_change_test"):
		#wind_direction_left = !wind_direction_left
	if flashlight.visible:
		flashlight.rotation = global_position.angle_to_point(get_global_mouse_position())


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_light"):
		flashlight.visible = !flashlight.visible
