extends CanvasLayer

@onready var level_1: Button = %Level1
@onready var level_2: Button = %Level2
@onready var level_3: Button = %Level3
@onready var level_4: Button = %Level4
@onready var level_5: Button = %Level5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#level_2.disabled = !Globals.level_1
	#level_3.disabled = !Globals.level_2
	#level_4.disabled = !Globals.level_3
	#level_5.disabled = !Globals.level_4



func _on_level_1_pressed() -> void:
	SceneLoader.load_scene("res://scenes/game/levels/level_1.tscn")


func _on_level_2_pressed() -> void:
	SceneLoader.load_scene("res://scenes/game/levels/level_2.tscn")


func _on_level_3_pressed() -> void:
	SceneLoader.load_scene("res://scenes/game/levels/level_3.tscn")


func _on_level_4_pressed() -> void:
	SceneLoader.load_scene("res://scenes/game/levels/level_4.tscn")


func _on_level_5_pressed() -> void:
	SceneLoader.load_scene("res://scenes/game/levels/level_5.tscn")
