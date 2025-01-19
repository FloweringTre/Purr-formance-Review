extends NodeState

@export var player: Player
@export var animation_player: AnimationPlayer


func _on_process(_delta : float) -> void:
	pass

func _on_physics_process(_delta : float) -> void:
	pass

func _on_next_transitions() -> void:
	if !animation_player.is_playing():
		if !GameInputEvents.is_movement_input():
			transition.emit("idle")
		
		elif GameInputEvents.is_sprinting():
			transition.emit("run")
		
		elif !GameInputEvents.is_sprinting():
			transition.emit("walk")

func _on_enter() -> void:
	player.movement_state = true #entering a movement state
	player.set_collision_mask_value(1, false)
	#Plays Animations
	if player.player_direction == Vector2.LEFT or player.player_direction == Vector2.UP:
		animation_player.play("jump")
		$"../../Sprite2D".flip_h = true
	elif player.player_direction == Vector2.RIGHT or player.player_direction == Vector2.DOWN:
		animation_player.play("jump")
		$"../../Sprite2D".flip_h = false
	else:
		animation_player.play("jump")
		$"../../Sprite2D".flip_h = false

func _on_exit() -> void:
	animation_player.stop()
	player.set_collision_mask_value(1, true)
	player.movement_state = false #exiting a movement state
	player.velocity = Vector2.ZERO
