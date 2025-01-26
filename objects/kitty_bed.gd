extends Node2D
var kitty_can_sleep : bool = false

func _ready() -> void:
	GlobalTrackingValues.bed_location = $pillows2/Sprite2D3.global_position
	GlobalTrackingValues.last_chase.connect(on_last_chase)
	GlobalTrackingValues.game_has_been_won.connect(on_game_won)
	$arrow.visible = false
	$AnimationPlayer.play("glow")

func _process(delta: float) -> void:
	pass

func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	#print("kitty in the bed")
	GlobalTrackingValues.kitty_in_bed = true
	GlobalTrackingValues.kitty_can_sleep = true
	GlobalTrackingValues.send_message("Press E to sleep")
	kitty_can_sleep = true
	GlobalTrackingValues.bed_location = $pillows2/Sprite2D3.global_position


func _on_area_2d_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	#print("kitty out of the bed")
	GlobalTrackingValues.kitty_in_bed = false
	GlobalTrackingValues.kitty_can_sleep = false
	kitty_can_sleep = false
	GlobalTrackingValues.send_message("")

func on_last_chase() -> void:
	$arrow.visible = true
	$AnimationPlayer.play("arrow_bounce")

func on_game_won() -> void:
	$arrow.visible = false
	$AnimationPlayer.stop()
