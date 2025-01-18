class_name Player
extends CharacterBody2D

#connects the tool the player is actively using to the player
@export var run_speed: = 100 #Max speed
@export var walk_speed: = 50 #walk about speed
@export var accel: = 20 #How long to get to max speed

var player_locked: bool = false #for locking character for cutscenes
var player_direction: Vector2 #holds last known direction from imput
var movement_state: bool #is player in a moving state?

func _ready() -> void:
	pass

func _physics_process(_delta) -> void:
	#HANDLES PLAYER MOVEMENT
	if movement_state: #is true
		var speed
		if GameInputEvents.is_sprinting():
			speed = run_speed
		else:
			speed = walk_speed
		
		var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
		velocity.x = move_toward(velocity.x, speed * direction.x, accel)
		velocity.y = move_toward(velocity.y, speed * direction.y, accel)
		move_and_slide()
