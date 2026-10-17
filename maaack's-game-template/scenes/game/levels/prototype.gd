extends Node

@onready var darkness: CanvasModulate = $Darkness



func _ready() -> void:
	# so we can leave the editor bright...
	darkness.visible = true
	Audio.play_track("level")
