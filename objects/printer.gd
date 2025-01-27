extends Node2D
var zone_active : bool = false
@onready var printer: StaticBody2D = $"."
@onready var fix_timer: Timer = $fixTimer
var last_chase_active : bool = false

func _ready() -> void:
	GlobalTrackingValues.kitty_bappin.connect(on_kitty_bappin)
	GlobalTrackingValues.item_fixed.connect(on_item_fixed)
	GlobalTrackingValues.last_chase.connect(on_last_chase)
	if GlobalTrackingValues.workday > 0:
		$AnimationPlayer.play("glow")
		particle_loading()
		$interactionArea2D/CollisionShape2D.disabled = false
	else:
		$interactionArea2D/CollisionShape2D.disabled = true

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
		$GPUParticles2D.one_shot = false
		$GPUParticles2D.modulate.a = 1.0
		$GPUParticles2D.emitting = true
		GlobalTrackingValues.printer_broken = true
		GlobalTrackingValues.send_message("")
		GlobalTrackingValues.item_broken.emit(printer)
		$AnimationPlayer.stop()

func particle_loading() -> void:
	$GPUParticles2D.one_shot = true
	$GPUParticles2D.emitting = true
	$GPUParticles2D.modulate.a = 0.0

func on_item_fixed(item : StaticBody2D) -> void:
	if !last_chase_active:
		if item == printer:
			fix_timer.start()

func _on_fix_timer_timeout() -> void:
	if !last_chase_active:
		GlobalTrackingValues.printer_broken = false
		$AnimationPlayer.play("glow")
		$GPUParticles2D.emitting = false
		GlobalTrackingValues.send_message("")

func on_last_chase() -> void:
	last_chase_active = true
