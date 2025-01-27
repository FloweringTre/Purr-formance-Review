extends Node2D
var zone_active : bool = false
@onready var fix_timer: Timer = $fixTimer
@export var left_facing : bool = false
var tipped : bool = false

func _ready() -> void:
	GlobalTrackingValues.kitty_bappin.connect(on_kitty_bappin)
	if left_facing:
		$water.flip_h = true
		$water.offset = Vector2(2, -7)

func _on_interaction_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if !GlobalTrackingValues.printer_broken:
		GlobalTrackingValues.send_message("Press E to knock the glass over")
		zone_active = true
		GlobalTrackingValues.active_item_location = $".".global_position

func _on_interaction_area_2d_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	GlobalTrackingValues.send_message("")
	zone_active = false

func on_kitty_bappin() -> void:
	if !tipped && zone_active:
		tipped = true
		GlobalTrackingValues.tipped_glasses += 1
		GlobalTrackingValues.send_message("")
		if left_facing:
			$AnimationPlayer.play("tipped_over_left")
		else:
			$AnimationPlayer.play("tipped_over_right")
