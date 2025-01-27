extends Node2D
var trash_spilled : bool = false
var zone_active : bool = false
@onready var trash_can: StaticBody2D = $"."
var last_chase_active : bool = false

func _ready() -> void:
	GlobalTrackingValues.kitty_bappin.connect(on_kitty_bappin)
	GlobalTrackingValues.item_fixed.connect(on_item_fixed)
	GlobalTrackingValues.last_chase.connect(on_last_chase)
	$AnimationPlayer.play("glow")
	particle_loading()

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
		$GPUParticles2D.modulate.a = 1.0
		$AnimationPlayer.play("trash_spilled")
		GlobalTrackingValues.trash_spilled += 1
		trash_spilled = true
		GlobalTrackingValues.send_message("")
		GlobalTrackingValues.item_broken.emit(trash_can)

func particle_loading() -> void:
	$GPUParticles2D.modulate.a = 0.0
	$GPUParticles2D.emitting = true

func been_fixed() -> void:
	if !last_chase_active:
		trash_spilled = false
		GlobalTrackingValues.trash_spilled -= 1
		$AnimationPlayer.play("glow")
		GlobalTrackingValues.send_message("")

func on_item_fixed(item : StaticBody2D) -> void:
	if !last_chase_active:
		if item == trash_can:
			$AnimationPlayer.play("trash_fixed")

func on_last_chase() -> void:
	last_chase_active = true
