extends GPUParticles2D


func _process(delta: float) -> void:
	process_material.set_shader_parameter("wind_velocity_x", Wind.velocity_x * 20)

	var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
	if player:
		global_position.x = player.global_position.x
		global_position.y = lerp(global_position.y, player.global_position.y, delta)
