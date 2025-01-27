extends NodeState

@export var player: Player
@export var animation_player: AnimationPlayer

func _on_process(_delta : float) -> void:
	pass

func _on_physics_process(_delta : float) -> void:
	pass

func _on_next_transitions() -> void:
	pass

func _on_enter() -> void:
	#Plays Animations
	animation_player.play("hiss")

func _on_exit() -> void:
	animation_player.stop()
