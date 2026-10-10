extends CharacterBody2D

@onready var player: CharacterBody2D = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#print(player,name)
	#position = player.global_position
	#if player.wind_direction_left:
		#position.x -= player.wind_speed
	#if !player.wind_direction_left:
		#position.x += player.wind_speed
