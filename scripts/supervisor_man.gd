extends CharacterBody2D

var tracking_kitty : bool = false
var can_see_kitty : bool = false
@onready var seeking_timer: Timer = $seekingTimer



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
