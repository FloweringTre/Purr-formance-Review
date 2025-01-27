extends Node2D
var zone_active : bool = false
@onready var sink: StaticBody2D = $"."
@onready var fix_timer: Timer = $fixTimer
var last_chase_active : bool = false


func _ready() -> void:
	GlobalTrackingValues.kitty_bappin.connect(on_kitty_bappin)
	GlobalTrackingValues.item_fixed.connect(on_item_fixed)
	GlobalTrackingValues.last_chase.connect(on_last_chase)
	if GlobalTrackingValues.workday > 1:
		$AnimationPlayer.play("glow")
		$interactionArea2D/CollisionShape2D.disabled = false
	else:
		$interactionArea2D/CollisionShape2D.disabled = true

func _on_interaction_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if !GlobalTrackingValues.sink_broken:
		GlobalTrackingValues.send_message("Press E to turn on the sink")
		zone_active = true
		GlobalTrackingValues.active_item_location = $".".global_position

func _on_interaction_area_2d_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	GlobalTrackingValues.send_message("")
	zone_active = false

func on_kitty_bappin() -> void:
	if !GlobalTrackingValues.sink_broken && zone_active:
		GlobalTrackingValues.sink_broken = true
		GlobalTrackingValues.send_message("")
		GlobalTrackingValues.item_broken.emit(sink)
		$AnimationPlayer.play("sink_breaking")

func on_item_fixed(item : StaticBody2D) -> void:
	if !last_chase_active:
		$AnimationPlayer.play("sink_fixing")
		fix_timer.start()

func _on_fix_timer_timeout() -> void:
	if !last_chase_active:
		GlobalTrackingValues.sink_broken = false
		$AnimationPlayer.play("glow")
		GlobalTrackingValues.send_message("")

func move_to_broken_loop() -> void:
	$AnimationPlayer.play("sink_broken")
	
func on_last_chase() -> void:
	last_chase_active = true
