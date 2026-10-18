extends Node2D

@export_category("Wind")
@export var wind_direction_left: bool = false
@export var wind_speed: float = 2
@export var max_wind_speed: float = 30
@export var min_wind_speed: float = 10

var dynamic_wind_sfx_active: bool = false

@onready var wind_timer: Timer = $WindTimer
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

var velocity_x: float
var last_velocity_x: float = 0

func _ready() -> void:
	wind_timer.timeout.connect(_on_wind_timer_timeout)
	audio.volume_db = -80
	_start_audio.call_deferred()


func _process(_delta: float) -> void:
	max_wind_speed = min_wind_speed + 4 * Globals.current_level
	velocity_x = -wind_speed if wind_direction_left else wind_speed
	if dynamic_wind_sfx_active:
		audio.volume_db = remap(wind_speed, min_wind_speed, max_wind_speed, -12, 0)
		audio.pitch_scale = remap(wind_speed, min_wind_speed, max_wind_speed, 1.0, 1.2)

	#if velocity_x != last_velocity_x:
		#last_velocity_x = velocity_x
		#print("wind velocity ", velocity_x)


func _start_audio() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(audio, "volume_linear", 0.5, 2.0)
	tween.tween_property(self, "dynamic_wind_sfx_active", true, 0)
	audio.play()


func _on_wind_timer_timeout() -> void:
	var wind_chance = randi_range(1, 10)
	print(wind_chance)
	if wind_chance == 1 or wind_chance == 2:
		var wind_tween = create_tween()
		wind_tween.tween_property(self, "wind_speed", 0, 1)
		await wind_tween.finished
		wind_direction_left = !wind_direction_left
		var wind_tween_2 = create_tween()
		wind_tween_2.tween_property(self, "wind_speed", randf_range(min_wind_speed, max_wind_speed), 1)
	elif wind_chance == 3 or wind_chance == 4:
		var wind_tween = create_tween()
		wind_tween.tween_property(self, "wind_speed", randf_range(min_wind_speed, max_wind_speed), 1)
