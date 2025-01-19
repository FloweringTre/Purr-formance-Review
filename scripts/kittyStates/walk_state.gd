extends NodeState

@export var player: Player
@export var animation_player: AnimationPlayer


func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	var direction: Vector2 = GameInputEvents.movement_input()
	
	#Player Animation
	if direction == Vector2.LEFT or direction == Vector2.UP:
		animation_player.play("walk")
		$"../../Sprite2D".flip_h = true
	elif direction == Vector2.RIGHT or direction == Vector2.DOWN:
		animation_player.play("walk")
		$"../../Sprite2D".flip_h = false
	
	
	#Storing player directional data to a variable on Player
	if direction != Vector2.ZERO: 
		player.player_direction = direction
	
	# Preferred metihod but bugged due to "not within scope"
	#player.velocity = move_toward(velocity.x, speed * direction.x, accel)
	#player.velocity = move_toward(velocity.y, speed * direction.y, accel)
	
	#player.velocity = direction * speed
	#player.move_and_slide()


func _on_next_transitions() -> void:	
	if !GameInputEvents.is_movement_input():
		transition.emit("idle")
	
	elif GameInputEvents.is_sprinting() && player.can_sprint:
		transition.emit("run")
	
	elif Input.is_action_just_pressed("jump"):
		transition.emit("jump")


func _on_enter() -> void:
	player.movement_state = true #entering a movement state


func _on_exit() -> void:
	animation_player.stop()
	player.movement_state = false #exiting a movement state
	player.velocity = Vector2.ZERO
