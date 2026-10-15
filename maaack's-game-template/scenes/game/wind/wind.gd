extends Node2D

@export_category("Wind")
@export var wind_direction_left: bool = false
@export var wind_speed: float = 20
@export var max_wind_speed: float = 30
@export var min_wind_speed: float = 10

@onready var wind_timer: Timer = $WindTimer

var velocity_x: float
var last_velocity_x: float = 0

func _ready() -> void:
	wind_timer.timeout.connect(_on_wind_timer_timeout)


func _process(_delta: float) -> void:
	velocity_x = -wind_speed if wind_direction_left else wind_speed
	if velocity_x != last_velocity_x:
		last_velocity_x = velocity_x
		print("wind velocity ", velocity_x)


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
