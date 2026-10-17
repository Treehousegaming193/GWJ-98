extends CharacterBody2D

@export var speed:float = 60

var facing_left: bool = true
var collision_diagonal: bool = true
var direction:int = 1
var movement:bool = true
var distance:int = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player = get_tree().get_first_node_in_group("player")
	velocity = Vector2.ZERO
	if !$RayCast2D_left.is_colliding():
			direction = 1
	if !$RayCast2D_right.is_colliding():
			direction = -1
	if movement:
		position.x += direction * speed * delta
		if direction > 0:
			$Sprite2D.flip_h = true
		else:
			$Sprite2D.flip_h = false
	elif !movement:
		position.x += -direction * speed * delta
		if -direction > 0:
			$Sprite2D.flip_h = true
		else:
			$Sprite2D.flip_h = false

#func check_for_platform() -> void:
	#if $RayCast2D.is_colliding():
		#collision_diagonal = true
	#else:
		#collision_diagonal = false
		
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().reload_current_scene()


func _on_hitbox_area_entered(area: Area2D) -> void:
	movement = false
	$LightTimer.start()


func _on_light_timer_timeout() -> void:
	movement = true
