extends NodeState

@export var character: CharacterBody2D
@export var animation_player: AnimationPlayer

@onready var idle_state_timer: Timer = Timer.new()
var idle_state_timeout : bool = false

func _ready() -> void:
	idle_state_timer.wait_time = character.idle_time
	idle_state_timer.timeout.connect(on_idle_state_timeout)
	add_child(idle_state_timer)

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	if GlobalTrackingValues.game_over:
		$"../../distractionTimer".stop()
		idle_state_timer.stop()


func _on_next_transitions() -> void:
	if !GlobalTrackingValues.game_over or !GlobalTrackingValues.game_paused:
		if idle_state_timeout:
			#print("supervisor is on the move!")
			transition.emit("walk")
		
	else:
		pass


func _on_enter() -> void:
	idle_state_timer.wait_time = character.idle_time
	if character.global_position == character.desk_location:
		var desk_animation : String = str("desk_", character.desk_direction)
		animation_player.play(desk_animation)
	else:
		animation_player.play("idle")
		$"../../distractionTimer".start()
	idle_state_timer.start()
	idle_state_timeout = false


func _on_exit() -> void:
	animation_player.stop()
	idle_state_timer.stop()
	$"../../distractionTimer".stop()


func _on_distraction_timer_timeout() -> void:
	var random = randi_range(0,5)
	if random == 3:
		#print("sup is on his phone....oooooo...")
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
