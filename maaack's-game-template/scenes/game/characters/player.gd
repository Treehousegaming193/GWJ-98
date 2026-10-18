extends CharacterBody2D

enum Anim { IDLE, JUMP, CHARGE_JUMP, HOLD_CHARGE, FALL, SHOCK, DIZZY }

const ANIM: Array[String] = [
	"wind right face right", # Anim.IDLE:
	"jump", # Anim.JUMP:
	"jumpcharge", # Anim.CHARGE_JUMP:
	"holdcharge", # Anim.HOLD_CHARGE:
	"falling", # Anim.FALL:
	"jolt back", #Anim.SHOCK:
	"dizzy", # Anim.DIZZY:
]

@export var jump_speed: float = 100
@export var speed: float = 150
@export var max_jump_charge_secs: float = 1.5
@export var jump_charge_multiplier: float = 4.0

var jump_charge_secs: float = 0
var jump_strength: float = 0

var in_debug: bool = false

@onready var flashlight: PointLight2D = %Flashlight
@onready var jump_strength_indicator: Line2D = %JumpStrengthIndicator
@onready var visual: Sprite2D = %Visual
@onready var scarf_strong_wind_visual: Sprite2D = %ScarfStrongWindVisual
@onready var scarf_medium_wind_visual: Sprite2D = %ScarfMediumWindVisual
@onready var scarf_weak_wind_visual: Sprite2D = %ScarfWeakWindVisual
@onready var wind_indicator: Line2D = %WindIndicator
@onready var jump_charge_audio: AudioStreamPlayer2D = %JumpChargeAudio
@onready var anim_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	add_to_group("player")


func _physics_process(delta: float) -> void:
	var input_dir = Input.get_axis("move_left", "move_right")
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
			velocity.x = input_dir * speed
			velocity.y -= jump_speed * jump_strength
			%JumpAudio.play()
			# rest jump charge
			jump_charge_secs = 0
			#if not anim_player.is_playing or \
			#	not anim_player.current_animation in [ANIM[Anim.CHARGE_JUMP], ANIM[Anim.HOLD_CHARGE]]:
			print("===== play jump anim")
			anim_player.play(ANIM[Anim.JUMP])
		elif want_charge_jump:
			if not jump_charge_audio.playing:
				jump_charge_audio.play()
			jump_charge_secs = min(jump_charge_secs + delta, max_jump_charge_secs)
			jump_strength_indicator.set_point_position(1, Vector2(0, -32 * jump_charge_secs / max_jump_charge_secs))

			if not anim_player.current_animation in [ANIM[Anim.CHARGE_JUMP], ANIM[Anim.HOLD_CHARGE]]:
				print("===== play charge jump anim")
				anim_player.play(ANIM[Anim.CHARGE_JUMP])
			if anim_player.current_animation == ANIM[Anim.CHARGE_JUMP] and not anim_player.is_playing:
				print("===== play hold charge anim")
				anim_player.play(ANIM[Anim.HOLD_CHARGE])
		else:
			if anim_player.current_animation != ANIM[Anim.IDLE]:
				anim_player.play(ANIM[Anim.IDLE])
	else:
		jump_charge_audio.stop()
		jump_strength_indicator.set_point_position(1, Vector2(0, 0))
		velocity += get_gravity() * delta
		velocity.x = lerp(velocity.x, input_dir * speed, delta * 10)
		# Apply wind to motion if not on floor
		if Wind.wind_direction_left:
			velocity.x -= Wind.wind_speed
		else:
			velocity.x += Wind.wind_speed
		if velocity.y > 0 and anim_player.current_animation != ANIM[Anim.FALL]:
			anim_player.play(ANIM[Anim.FALL])

	if input_dir:
		visual.flip_h = input_dir < 0
	move_and_slide()

	# Procedural scarf
	#%scarf.velocity = Vector2.ZERO
	#%scarf.position = position
		#%scarf.velocity.x = velocity.x + Wind.wind_speed
	#if !Wind.wind_direction_left:

		#%scarf.velocity.x = velocity.x - Wind.wind_speed
	#%scarf.move_and_slide()
	# Can't really parent physics bodies to each other
	# (well, you can, it just won't work like you hope, I think)
	# this is the biggest reason I think character body 2d isn't a good fit.
	# I would try a line2d and a shader like https://godotshaders.com/shader/2d-simple-animated-flag-shader/

	# for now, just an indicator of direction & speed
	var wsx: float = 2 * -Wind.wind_speed if Wind.wind_direction_left else Wind.wind_speed
	wind_indicator.set_point_position(1, Vector2(wsx, 0))
	scarf_strong_wind_visual.visible = Wind.wind_speed > 8
	scarf_weak_wind_visual.visible = Wind.wind_speed < 5
	scarf_medium_wind_visual.visible = Wind.wind_speed <= 8 and Wind.wind_speed >= 5
	scarf_strong_wind_visual.flip_h = Wind.wind_direction_left
	scarf_medium_wind_visual.flip_h = Wind.wind_direction_left
	scarf_weak_wind_visual.flip_h = Wind.wind_direction_left


func _process(_delta: float) -> void:
	#if Input.is_action_just_pressed("wind_change_test"):
		#wind_direction_left = !wind_direction_left
	if flashlight.visible:
		flashlight.rotation = global_position.angle_to_point(get_global_mouse_position())


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_light"):
		flashlight.visible = !flashlight.visible
