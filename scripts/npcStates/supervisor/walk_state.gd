extends NodeState

@export var character: CharacterBody2D
@export var animation_player: AnimationPlayer
@export var navigation_agent: NavigationAgent2D
@export var speed : float = 25.0

func _ready() -> void:
	navigation_agent.velocity_computed.connect(on_safe_velocity_computed)
	call_deferred("character_setup")

func character_setup() -> void:
	await get_tree().physics_frame
	
	set_movement_target()

func set_movement_target() -> void:
	var target_position : Vector2 = NavigationServer2D.map_get_random_point(navigation_agent.get_navigation_map(), navigation_agent.navigation_layers, false)
	navigation_agent.target_position = target_position


func _on_process(_delta : float) -> void:
	pass

func _on_physics_process(_delta : float) -> void:
	if navigation_agent.is_navigation_finished():
		set_movement_target()
		return
	
	var target_position : Vector2 = navigation_agent.get_next_path_position()
	var target_direction : Vector2 = character.global_position.direction_to(target_position)
	$"../../Sprite2D".flip_h = target_direction.x < 0
	
	var velocity: Vector2 = target_direction * speed
	
	if navigation_agent.avoidance_enabled:
		navigation_agent.velocity = velocity
	else:
		character.velocity = velocity
		character.move_and_slide()


func on_safe_velocity_computed(safe_velocity: Vector2) -> void:
	character.velocity = safe_velocity
	character.move_and_slide()

func _on_next_transitions() -> void:	
	if navigation_agent.is_navigation_finished():
		character.velocity = Vector2.ZERO
		transition.emit("idle")

func _on_enter() -> void:
	animation_player.play("walk")
	$"../../Sprite2D".flip_h = false


func _on_exit() -> void:
	animation_player.stop()
