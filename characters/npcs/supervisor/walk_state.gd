extends NodeState

@export var character: CharacterBody2D
@export var animation_player: AnimationPlayer
@export var navigation_agent: NavigationAgent2D
@export var speed : float = 25.0

var location
var counter : int = 1

@onready var sprite_2d: Sprite2D = $"../../Sprite2D"

@onready var seeking_zone: CollisionPolygon2D = $"../../seekingArea/seeking_zone"
@onready var seeking_zone_left: CollisionPolygon2D = $"../../seekingArea/seeking_zone_left"
@onready var seeking_zone_right: CollisionPolygon2D = $"../../seekingArea/seeking_zone_right"


func _ready() -> void:
	navigation_agent.velocity_computed.connect(on_safe_velocity_computed)
	call_deferred("character_setup")

func character_setup() -> void:
	await get_tree().physics_frame
	
	set_movement_target()

func set_movement_target() -> void:
	set_speed()
	if GlobalTrackingValues.sup_aval_pos.size() == 0 or !character.active:
		character.velocity = Vector2.ZERO
		transition.emit("idle")
	else:
		var random_marker = GlobalTrackingValues.sup_aval_pos[randi() % GlobalTrackingValues.sup_aval_pos.size()] 
		var target_position = GlobalTrackingValues.sup_positions[random_marker]
		character.walking_position_index = random_marker
		GlobalTrackingValues.sup_aval_pos.erase(random_marker)
		
		#= NavigationServer2D.map_get_random_point(navigation_agent.get_navigation_map(), navigation_agent.navigation_layers, false)
		navigation_agent.target_position = target_position
		
		#var target_distance = navigation_agent.distance_to_target()
		#if target_distance > 100:
			#print("navigation target was ", target_distance, " units away... rerolling target.")
			#set_movement_target()

func set_kitty_target() -> void:
	var target_position : Vector2 = GlobalTrackingValues.last_reported_kitty_location
	navigation_agent.target_position = target_position

func _on_process(_delta : float) -> void:
	pass

func _on_physics_process(_delta : float) -> void:
	if !GlobalTrackingValues.game_paused:
		if navigation_agent.is_navigation_finished():
			set_movement_target()
			return
		
		tracking_location()
		location = character.global_position
		
		var target_position : Vector2 = navigation_agent.get_next_path_position()
		var target_direction : Vector2 = character.global_position.direction_to(target_position)
		sprite_2d.flip_h = target_direction.x < 0
		if target_direction.x < 0:
			seeking_zone_left.disabled = false
			seeking_zone_left.visible = true
			seeking_zone_right.disabled = true
			seeking_zone_right.visible = false
		else:
			seeking_zone_left.disabled = true
			seeking_zone_left.visible = false
			seeking_zone_right.disabled = false
			seeking_zone_right.visible = true
		
		var velocity: Vector2 = target_direction * speed
		
		if navigation_agent.avoidance_enabled:
			navigation_agent.velocity = velocity
		else:
			character.velocity = velocity
			character.move_and_slide()
	elif GlobalTrackingValues.game_over:
		character.velocity = Vector2.ZERO
		transition.emit("idle")
	else:
		character.velocity = Vector2.ZERO

func on_safe_velocity_computed(safe_velocity: Vector2) -> void:
	character.velocity = safe_velocity
	character.move_and_slide()

func tracking_location() -> void:
	
	if character.global_position.distance_to(location) < 0.1:
		counter += 1
		#if counter > 1:
			#print ("Supervisor in same location for: ", counter , " frames")
			
		if counter == 10:
			set_movement_target()
			navigation_agent.navigation_finished.emit()
			print("Sup is stuck, moving to idle")
			#print(GlobalTrackingValues.sup_aval_pos)
			#print("appeneding at stuck")
			#print(character.sup_name, " - ", character.walking_position_index)
			GlobalTrackingValues.sup_aval_pos.append(character.walking_position_index)
			#print(GlobalTrackingValues.sup_aval_pos)
			character.velocity = Vector2.ZERO
			character.stuck = true
			transition.emit("idle")
			

func _on_next_transitions() -> void:	
	if GlobalTrackingValues.game_over:
		navigation_agent.navigation_finished.emit()
		character.velocity = Vector2.ZERO
		transition.emit("idle")
	
	if navigation_agent.is_navigation_finished():
		#print(GlobalTrackingValues.sup_aval_pos)
		#print("appeneding at nav done")
		#print(character.sup_name, " - ", character.walking_position_index)
		GlobalTrackingValues.sup_aval_pos.append(character.walking_position_index)
		#print(GlobalTrackingValues.sup_aval_pos)
		character.velocity = Vector2.ZERO
		transition.emit("idle")
	
	if character.tracking_kitty or character.last_chase_tracking:
		#print(GlobalTrackingValues.sup_aval_pos)
		#print("appeneding at kitty track")
		#print(character.sup_name, " - ", character.walking_position_index)
		GlobalTrackingValues.sup_aval_pos.append(character.walking_position_index)
		#print(GlobalTrackingValues.sup_aval_pos)
		set_kitty_target()
		navigation_agent.navigation_finished.emit()
		transition.emit("run")

func _on_enter() -> void:
	#print(GlobalTrackingValues.sup_aval_pos)
	set_movement_target()
	location = character.global_position
	counter = 0
	animation_player.play("walk")
	sprite_2d.flip_h = false
	seeking_zone.disabled = true
	seeking_zone.visible = false
	seeking_zone_left.disabled = true
	seeking_zone_left.visible = false
	seeking_zone_right.disabled = false
	seeking_zone_right.visible = true


func _on_exit() -> void:
	animation_player.stop()
	seeking_zone.disabled = false
	seeking_zone.visible = true
	seeking_zone_left.disabled = true
	seeking_zone_left.visible = false
	seeking_zone_right.disabled = true
	seeking_zone_right.visible = false

func set_speed() -> void:
	var reported_level = GlobalTrackingValues.productivity_level()
	var percent : float = reported_level * 0.01
	match GlobalTrackingValues.difficulty_level:
		0:
			speed = 15 + (percent * 15)
		1:
			speed = 20 + (percent * 15)
		2:
			speed = 20 + (percent * 20)
		3:
			speed = 20 + (percent * 25)
	#print("sup speed: ", speed)
	#print("sup percent: ", percent)
	#print("reported levels: ", reported_level )
