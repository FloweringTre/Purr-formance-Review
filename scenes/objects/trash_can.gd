extends Node2D
var trash_spilled : bool = false
var zone_active : bool = false

func _ready() -> void:
	GlobalTrackingValues.kitty_bappin.connect(on_kitty_bappin)
	$AnimationPlayer.play("glow")

func _on_interaction_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if !trash_spilled:
		GlobalTrackingValues.send_message("Press E to spill the trash")
		zone_active = true
		GlobalTrackingValues.active_item_location = $".".global_position

func _on_interaction_area_2d_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	GlobalTrackingValues.send_message("")
	zone_active = false

func on_kitty_bappin() -> void:
	if !trash_spilled && zone_active:
		$AnimationPlayer.play("trash_spilled")
		GlobalTrackingValues.trash_spilled += 1
		trash_spilled = true
		GlobalTrackingValues.send_message("")
