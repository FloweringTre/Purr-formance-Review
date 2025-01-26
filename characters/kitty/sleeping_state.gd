extends NodeState

@export var player: Player
@export var animation_player: AnimationPlayer
@onready var wait_timer: Timer = $"../../waitTimer"

var locked_state : bool = false

func _on_process(_delta : float) -> void:
	pass

func _on_physics_process(_delta : float) -> void:
	if player.last_chase_tracking && GlobalTrackingValues.kitty_in_bed && !GlobalTrackingValues.game_over:
		GlobalTrackingValues.send_message("")
		GlobalTrackingValues.game_has_been_won.emit()
		GlobalTrackingValues.game_won.emit()
		locked_state = true

func _on_next_transitions() -> void:
	if Input.is_action_just_pressed("interact") && !locked_state:
		transition.emit("idle")

func _on_enter() -> void:
	#Plays Animations
	animation_player.play("sleep")
	GlobalTrackingValues.send_message("Press E to wake up")
	player.velocity = Vector2.ZERO
	player.global_position = GlobalTrackingValues.bed_location
	$"../../seekingArea/CollisionShape2D".disabled = true
	$"../../caughtArea/CollisionShape2D".disabled = true

func _on_exit() -> void:
	GlobalTrackingValues.send_message("")
	animation_player.stop()
	$"../../seekingArea/CollisionShape2D".disabled = false
	$"../../caughtArea/CollisionShape2D".disabled = false
