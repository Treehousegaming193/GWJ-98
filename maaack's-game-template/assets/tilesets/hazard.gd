extends Area2D

@onready var point_light_2d: PointLight2D = $PointLight2D

var frame_offset: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	frame_offset = randi_range(0, 9)
	body_entered.connect(_on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (Engine.get_frames_drawn() + frame_offset) % 15 == 0:
		#prints(Engine.get_frames_drawn(), "change light energy")
		point_light_2d.energy = randf_range(.5, 4.0)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().reload_current_scene.call_deferred()
