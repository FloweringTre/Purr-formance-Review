extends NodeState

@export var player: Player
@export var animation_player: AnimationPlayer


func _on_process(_delta : float) -> void:
	pass

func _on_physics_process(_delta : float) -> void:
	pass

func _on_next_transitions() -> void:
	if !animation_player.is_playing():
		if !GameInputEvents.is_movement_input() or GlobalTrackingValues.game_over or !GlobalTrackingValues.game_paused:
			transition.emit("idle")

func _on_enter() -> void:
	#Plays Animations
	$"../../bapAudioPlayer".volume_db = GlobalTrackingValues.sound_effect_volume
	animation_player.play("bap")
	var direction : Vector2 = player.global_position.direction_to(GlobalTrackingValues.active_item_location)
	$"../../Sprite2D".flip_h = direction.x < 0
	GlobalTrackingValues.kitty_bappin.emit()

func _on_exit() -> void:
	animation_player.stop()
