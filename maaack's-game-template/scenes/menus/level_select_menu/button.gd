extends Button

@export var level: PackedScene
@export var level_number: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Globals.level_4:
		disabled = false
		visible = true


func _on_button_down() -> void:
	get_tree().change_scene_to_packed(level)
