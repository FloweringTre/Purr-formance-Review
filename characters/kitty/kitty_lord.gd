class_name Player
extends CharacterBody2D

#connects the tool the player is actively using to the player
@export var run_speed: = 50 #Max speed
@export var walk_speed: = 25 #walk about speed
@export var accel: = 20 #How long to get to max speed
@export var jump_speed = 0.5

var player_locked: bool = false #for locking character for cutscenes
var player_direction: Vector2 #holds last known direction from imput
var movement_state: bool #is player in a moving state?
var jumping : bool #is player jumping?
var running : bool #is player running?
var can_sprint : bool = true #can the player sprint?
var sprint_value : int = 180
var sprint_locked : bool = false
var counter: int = 1
var being_tracked : bool #is the player being tracked by the supervisor?
var last_chase_tracking : bool

func _ready() -> void:
	GlobalTrackingValues.last_chase.connect(on_last_chase)

func _physics_process(_delta) -> void:
	if movement_state: #is true
		var speed
		if running:
			speed = run_speed
		else:
			speed = walk_speed
		
		if jumping:
			speed = speed * jump_speed
		
		var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
		velocity.x = move_toward(velocity.x, speed * direction.x, accel)
		velocity.y = move_toward(velocity.y, speed * direction.y, accel)
		move_and_slide()
	
	if being_tracked or last_chase_tracking:
		GlobalTrackingValues.last_reported_kitty_location = $".".global_position
	
	if !sprint_locked:
		if Input.is_action_just_pressed("sprint"):
			sprint_value -= 5
		
		if running:
			sprint_value -= 1
			$blueProgressBar.value = sprint_value
			$redProgressBar.value = sprint_value
		
		if sprint_value == 0:
			can_sprint = false
			on_sprint_depleted()
		
		if !running:
			sprint_value += 1
			$blueProgressBar.value = sprint_value
			$redProgressBar.value = sprint_value
			if sprint_value > 240:
				sprint_value = 240
				$blueProgressBar.visible = false
				$redProgressBar.visible = false
	else:
		slow_sprint_increase()

func on_sprint_depleted() -> void:
	can_sprint = false
	sprint_locked = true

func slow_sprint_increase() -> void:
	$blueProgressBar.visible = false
	$redProgressBar.visible = true
	if counter == 1:
		counter += 1
	else:
		counter = 1
		sprint_value += 1
		$blueProgressBar.value = sprint_value
		$redProgressBar.value = sprint_value
		if sprint_value == 240:
			$blueProgressBar.visible = false
			$redProgressBar.visible = false
			sprint_locked = false
			can_sprint = true


func _on_seeking_area_body_entered(body: Node2D) -> void:
	being_tracked = true

func _on_seeking_area_body_exited(body: Node2D) -> void:
	being_tracked = false

func _on_caught_area_area_entered(area: Area2D) -> void:
	GlobalTrackingValues.kitty_caught_from_kitty = true
	print("I have been caught")

func _on_caught_area_area_exited(area: Area2D) -> void:
	GlobalTrackingValues.kitty_caught_from_kitty = false
	print("I have escaped!")

func on_last_chase() -> void:
	last_chase_tracking = true
