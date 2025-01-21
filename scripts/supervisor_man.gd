extends CharacterBody2D

var tracking_kitty : bool = false
var last_chase_tracking : bool = false
var can_see_kitty : bool = false
@onready var seeking_timer: Timer = $seekingTimer
var time_left

func _ready() -> void:
	GlobalTrackingValues.last_chase.connect(on_last_chase)
	GlobalTrackingValues.game_resumed.connect(on_game_resumed)

func _process(delta: float) -> void:
	if GlobalTrackingValues.game_paused:
		time_left = seeking_timer.time_left
		seeking_timer.stop()

func _on_seeking_area_body_entered(body: Node2D) -> void:
	print("I can see the kitty!")
	tracking_kitty = true
	can_see_kitty = true
	seeking_timer.start()
	

func _on_seeking_area_body_exited(body: Node2D) -> void:
	print("I lost sight of the kitty :(")
	can_see_kitty = false


func _on_seeking_timer_timeout() -> void:
	if can_see_kitty:
		seeking_timer.start()
	else:
		tracking_kitty = false

func _on_capture_area_area_entered(area: Area2D) -> void:
	GlobalTrackingValues.kitty_caught = true


func on_last_chase() -> void:
	last_chase_tracking = true

func on_game_resumed() -> void:
	seeking_timer.start(time_left)
