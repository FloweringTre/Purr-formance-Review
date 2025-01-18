extends NodeState

@export var player: Player
@export var animation_player: AnimationPlayer
var next_action : String

func _ready() -> void:
	pass

func _on_physics_process(_delta : float) -> void:
	#Plays Animations
	if player.player_direction == Vector2.LEFT or player.player_direction == Vector2.UP:
		animation_player.play("idle")
		$"../../Sprite2D".flip_h = true
	elif player.player_direction == Vector2.RIGHT or player.player_direction == Vector2.DOWN:
		animation_player.play("idle_2")
		$"../../Sprite2D".flip_h = false
	else:
		animation_player.play("idle")

func _on_action() -> void:
	pass

func _on_next_transitions() -> void:
	GameInputEvents.movement_input()
	
	if GameInputEvents.is_movement_input():
		transition.emit("walk")
	
	elif Input.is_action_just_pressed("jump"):
		transition.emit("jump")


func _on_enter() -> void:
	pass

func _on_exit() -> void:
	animation_player.stop()
