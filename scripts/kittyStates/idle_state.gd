extends NodeState

@export var player: Player
@export var animation_player: AnimationPlayer
var idle_animation : String

func _ready() -> void:
	pass

func _on_physics_process(_delta : float) -> void:
	#Plays Animations
	if player.player_direction == Vector2.LEFT or player.player_direction == Vector2.UP:
		animation_player.play(idle_animation)
		$"../../Sprite2D".flip_h = true
	elif player.player_direction == Vector2.RIGHT or player.player_direction == Vector2.DOWN:
		animation_player.play(idle_animation)
		$"../../Sprite2D".flip_h = false
	else:
		animation_player.play(idle_animation)

func _on_action() -> void:
	pass

func _on_next_transitions() -> void:
	if !GlobalTrackingValues.game_over:
		GameInputEvents.movement_input()
		
		if GameInputEvents.is_movement_input():
			transition.emit("walk")
		
		elif Input.is_action_just_pressed("jump"):
			transition.emit("jump")


func _on_enter() -> void:
	var random = randi_range(1, 2)
	if random == 1:
		idle_animation = "idle_1"
		print(idle_animation)
	else:
		idle_animation = "idle_2"
		print(idle_animation)

func _on_exit() -> void:
	animation_player.stop()
