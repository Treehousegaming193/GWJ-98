extends CharacterBody2D

@export var speed:float = 60

var facing_left: bool = true
var collision_diagonal: bool = true
var direction:int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity = Vector2.ZERO
	if !$RayCast2D_left.is_colliding():
			direction = 1
			$Sprite2D.flip_h = true
	if !$RayCast2D_right.is_colliding():
			direction = -1
			$Sprite2D.flip_h = false
	position.x += direction * speed * delta

#func check_for_platform() -> void:
	#if $RayCast2D.is_colliding():
		#collision_diagonal = true
	#else:
		#collision_diagonal = false
