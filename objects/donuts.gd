extends Node2D
var donut_spilled : bool = false
var zone_active : bool = false
@onready var donut: StaticBody2D = $"."


func _ready() -> void:
	GlobalTrackingValues.kitty_bappin.connect(on_kitty_bappin)
	GlobalTrackingValues.item_fixed.connect(on_item_fixed)
	if GlobalTrackingValues.workday > 2:
		$AnimationPlayer.play("glow")
		$interactionArea2D/CollisionShape2D.disabled = false
	else:
		$interactionArea2D/CollisionShape2D.disabled = true

func _on_interaction_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if !donut_spilled:
		GlobalTrackingValues.send_message("Press E to spill the donuts")
		zone_active = true
		GlobalTrackingValues.active_item_location = $".".global_position

func _on_interaction_area_2d_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	GlobalTrackingValues.send_message("")
	zone_active = false

func on_kitty_bappin() -> void:
	if !donut_spilled && zone_active:
		$AnimationPlayer.play("plate_spilled")
		GlobalTrackingValues.donuts_spilled += 1
		donut_spilled = true
		GlobalTrackingValues.send_message("")
		GlobalTrackingValues.item_broken.emit(donut)

func been_fixed() -> void:
	donut_spilled = false
	GlobalTrackingValues.donuts_spilled -= 1
	$AnimationPlayer.play("glow")
	GlobalTrackingValues.send_message("")

func on_item_fixed(item : StaticBody2D) -> void:
	if item == donut:
		$AnimationPlayer.play("plate_fixed")
