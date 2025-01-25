extends Node2D
var kitty_can_sleep : bool = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if kitty_can_sleep && GlobalTrackingValues.message == "" && !GlobalTrackingValues.game_over:
		GlobalTrackingValues.send_message("Press E to sleep")
	if Input.is_action_pressed("interact") && kitty_can_sleep:
		GlobalTrackingValues.secret_sleep = true
		print("secret sleeping time")


func _on_sleeping_area_2d_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	kitty_can_sleep = false
	GlobalTrackingValues.kitty_can_sleep = false
	GlobalTrackingValues.send_message("")


func _on_sleeping_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	GlobalTrackingValues.send_message("Press E to sleep")
	kitty_can_sleep = true
	GlobalTrackingValues.kitty_can_sleep = true
	GlobalTrackingValues.bed_location = $".".global_position
