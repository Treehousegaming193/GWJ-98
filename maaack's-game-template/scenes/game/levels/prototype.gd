extends Node2D

@onready var darkness: CanvasModulate = $Darkness



func _ready() -> void:
	# so we can leave the editor bright...
	darkness.visible = true
