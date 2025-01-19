class_name Player
extends CharacterBody2D

#connects the tool the player is actively using to the player
@export var run_speed: = 100 #Max speed
@export var walk_speed: = 50 #walk about speed
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

func _ready() -> void:
	pass

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
		
	
	if !sprint_locked:
		if running:
			sprint_value -= 1
			$ProgressBar.value = sprint_value
		
		if sprint_value == 0:
			can_sprint = false
			on_sprint_depleted()
		
		if !running:
			sprint_value += 1
			$ProgressBar.value = sprint_value
			if sprint_value > 180:
				sprint_value = 180
				$ProgressBar.visible = false
	else:
		slow_sprint_increase()

func on_sprint_depleted() -> void:
	can_sprint = false
	sprint_locked = true

func slow_sprint_increase() -> void:
	if counter == 1:
		counter += 1
	else:
		counter = 1
		sprint_value += 1
		$ProgressBar.value = sprint_value
		if sprint_value == 180:
			sprint_locked = false
			can_sprint = true
