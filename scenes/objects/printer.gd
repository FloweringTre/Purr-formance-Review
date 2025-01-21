extends Node2D
var zone_active : bool = false

func _ready() -> void:
	GlobalTrackingValues.kitty_bappin.connect(on_kitty_bappin)
	$AnimationPlayer.play("glow")

func _on_interaction_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if !GlobalTrackingValues.printer_broken:
		GlobalTrackingValues.send_message("Press E to break the printer")
		zone_active = true
		GlobalTrackingValues.active_item_location = $".".global_position

func _on_interaction_area_2d_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	GlobalTrackingValues.send_message("")
	zone_active = false

func on_kitty_bappin() -> void:
	if !GlobalTrackingValues.printer_broken && zone_active:
		$GPUParticles2D.emitting = true
		GlobalTrackingValues.printer_broken = true
		GlobalTrackingValues.send_message("")
		$AnimationPlayer.stop()
