extends NodeState

@export var character: CharacterBody2D
@export var animation_player: AnimationPlayer
@export var idle_state_time_interval: float = 5.0

@onready var seeking_zone: CollisionPolygon2D = $"../../seekingArea/seeking_zone"
@onready var seeking_zone_left: CollisionPolygon2D = $"../../seekingArea/seeking_zone_left"
@onready var seeking_zone_right: CollisionPolygon2D = $"../../seekingArea/seeking_zone_right"
@onready var idle_state_timer: Timer = Timer.new()
var idle_state_timeout : bool = false

func _ready() -> void:
	idle_state_timer.wait_time = idle_state_time_interval
	idle_state_timer.timeout.connect(on_idle_state_timeout)
	add_child(idle_state_timer)

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	if GlobalTrackingValues.game_over:
		$"../../distractionTimer".stop()
		idle_state_timer.stop()
		character.last_chase_tracking = false


func _on_next_transitions() -> void:
	if character.active:
		if !GlobalTrackingValues.game_over or !GlobalTrackingValues.game_paused:
			if idle_state_timeout:
				#print("supervisor is on the move!")
				transition.emit("walk")
			
			if character.tracking_kitty or character.last_chase_tracking:
				transition.emit("run")
	else:
		pass


func _on_enter() -> void:
	animation_player.play("idle")
	$"../../distractionTimer".start()
	if character.stuck:
		idle_state_time_interval = randf_range(0, 1)
		idle_state_timer.start(idle_state_time_interval)
		character.stuck = false
	else:
		idle_state_time_interval = randi_range(3, 5)
		idle_state_timer.start(idle_state_time_interval)
	idle_state_timeout = false
	seeking_zone.disabled = false
	seeking_zone.visible = true
	seeking_zone_left.disabled = true
	seeking_zone_left.visible = false
	seeking_zone_right.disabled = true
	seeking_zone_right.visible = false


func _on_exit() -> void:
	animation_player.stop()
	idle_state_timer.stop()
	$"../../distractionTimer".stop()


func _on_distraction_timer_timeout() -> void:
	var random = randi_range(0,3)
	if random == 3:
		#print("sup is on his phone....oooooo...")
		if character.active:
			transition.emit("distracted")
	else:
		#print("PHONE - Random chance failed.")
		$"../../distractionTimer".start()

func on_idle_state_timeout() -> void:
	var random = randi_range(2,3)
	if random == 3:
		idle_state_timeout = true
	else:
		#print("WALK- Random chance failed.")
		idle_state_timer.start()
