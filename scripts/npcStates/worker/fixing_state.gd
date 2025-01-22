extends NodeState

@export var character: CharacterBody2D
@export var animation_player: AnimationPlayer


func _on_process(_delta : float) -> void:
	pass

func _on_physics_process(_delta : float) -> void:
	pass

func _on_next_transitions() -> void:
	if !animation_player.is_playing() or GlobalTrackingValues.game_over or GlobalTrackingValues.game_paused:
		transition.emit("idle")
		character.fixing_needed = false

func _on_enter() -> void:
	#Plays Animations
	animation_player.play("fixing")
	GlobalTrackingValues.item_fixed.emit(character.item_to_fix)

func _on_exit() -> void:
	animation_player.stop()
