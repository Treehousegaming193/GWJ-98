extends Area2D

# exported for use in anim player
@export var repaired: bool = false

@export var level:int

var can_repair: bool = false

@onready var anim_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	%SignalBrokenSFX.play()
	%ActionPromptContainer.visible = false


func _process(_delta: float) -> void:
	if repaired:
		if !anim_player.is_playing():
			match level:
				1:
					Globals.level_1 = true
				2:
					Globals.level_2 = true
				3:
					Globals.level_3 = true
				4:
					Globals.level_4 = true
			await get_tree().create_timer(1).timeout
			get_tree().change_scene_to_file("res://scenes/menus/level_select_menu/new_level_select.tscn")
		return
	# only need to hold for 3 secs
	if anim_player.current_animation == "repair" and \
		anim_player.current_animation_position >= 3:
		return

	if can_repair:
		if Input.is_action_pressed("interact"):
			#print("interact do repair")
			%ActionPromptContainer.visible = false
			if anim_player.current_animation != "repair" or not anim_player.is_playing:
				anim_player.play("repair")
			return
		else:
			%ActionPromptContainer.visible = true
	if anim_player.current_animation == "repair" and anim_player.is_playing:
		anim_player.play("RESET")


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("can repair")
		can_repair = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("can't repair")
		can_repair = false
