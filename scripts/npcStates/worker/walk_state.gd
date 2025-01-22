extends NodeState

@export var character: CharacterBody2D
@export var animation_player: AnimationPlayer
@export var navigation_agent: NavigationAgent2D
@export var speed : float = 15.0

var location
var counter : int = 1

@onready var sprite_2d: Sprite2D = $"../../Sprite2D"

func _ready() -> void:
	navigation_agent.velocity_computed.connect(on_safe_velocity_computed)
	call_deferred("character_setup")

func character_setup() -> void:
	await get_tree().physics_frame
	
	set_movement_target()

func set_movement_target() -> void:
	if !character.fixing_needed:
		if character.global_position == character.starting_location:
			var target_position : Vector2 = NavigationServer2D.map_get_random_point(navigation_agent.get_navigation_map(), navigation_agent.navigation_layers, false)
			navigation_agent.target_position = target_position
		else:
			navigation_agent.target_position = character.starting_location
	
	else:
		navigation_agent.target_position = character.fix_location

func set_kitty_target() -> void:
	var target_position : Vector2 = GlobalTrackingValues.last_reported_kitty_location
	navigation_agent.target_position = target_position

func _on_process(_delta : float) -> void:
	pass

func _on_physics_process(_delta : float) -> void:
	if navigation_agent.is_navigation_finished():
		set_movement_target()
		return
	
	tracking_location()
	
	var target_position : Vector2 = navigation_agent.get_next_path_position()
	var target_direction : Vector2 = character.global_position.direction_to(target_position)
	sprite_2d.flip_h = target_direction.x < 0
	
	var velocity: Vector2 = target_direction * speed
	
	if navigation_agent.avoidance_enabled:
		navigation_agent.velocity = velocity
	else:
		character.velocity = velocity
		character.move_and_slide()


func on_safe_velocity_computed(safe_velocity: Vector2) -> void:
	character.velocity = safe_velocity
	character.move_and_slide()

func tracking_location() -> void:
	if location == character.global_position:
		counter += 1
		if counter > 1:
			print ("Worker is in same location for: ", counter , " frames")
		if counter == 10:
			set_movement_target()
			navigation_agent.navigation_finished.emit()
			print("Worker is stuck, moving to idle")
			character.velocity = Vector2.ZERO
			transition.emit("idle")
	
	location = character.global_position

func _on_next_transitions() -> void:	
	if GlobalTrackingValues.game_over or GlobalTrackingValues.game_paused:
		navigation_agent.navigation_finished.emit()
		character.velocity = Vector2.ZERO
		transition.emit("idle")
	
	if navigation_agent.is_navigation_finished():
		character.velocity = Vector2.ZERO
		if character.fixing_needed:
			transition.emit("fixing")
		else:
			transition.emit("idle")

func _on_enter() -> void:
	set_movement_target()
	location = character.global_position
	counter = 0
	animation_player.play("walk")
	sprite_2d.flip_h = false


func _on_exit() -> void:
	animation_player.stop()


func _on_worker_time_to_fix() -> void:
	set_movement_target()
