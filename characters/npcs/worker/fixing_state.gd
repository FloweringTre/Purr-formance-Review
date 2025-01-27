extends NodeState

@export var character: CharacterBody2D
@export var animation_player: AnimationPlayer

var fix_animation : String

func _ready() -> void:
	GlobalTrackingValues.game_resumed.connect(on_game_resumed)

func _on_process(_delta : float) -> void:
	pass

func _on_physics_process(_delta : float) -> void:
	pass

func _on_next_transitions() -> void:
	if GlobalTrackingValues.game_over:
		character.fixing_needed = false
		transition.emit("walk")
	
	if GlobalTrackingValues.game_paused:
		animation_player.pause()
	
	if !animation_player.is_playing():
		if GlobalTrackingValues.difficulty_level != 0:
			character.fixing_needed = false
			character.has_fixed_before = true
			transition.emit("walk")
		else:
			animation_player.play(fix_animation)

func _on_enter() -> void:
	fix_animation = str("fixing_", character.fix_direction)
	#Plays Animations
	animation_player.play(fix_animation)
	if GlobalTrackingValues.difficulty_level != 0:
		GlobalTrackingValues.item_fixed.emit(character.item_to_fix)

func _on_exit() -> void:
	animation_player.stop()

func on_game_resumed() -> void:
	animation_player.play()
