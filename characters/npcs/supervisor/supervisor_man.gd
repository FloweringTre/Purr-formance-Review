extends CharacterBody2D

@export var active : bool = true
@export var character_texture : Texture2D
var tracking_kitty : bool = false
var last_chase_tracking : bool = false
var can_see_kitty : bool = false
@onready var seeking_timer: Timer = $seekingTimer
var time_left
var sup_name
var walking_position_index : int
var stuck : bool = false

func _ready() -> void:
	$Sprite2D.texture = character_texture
	GlobalTrackingValues.last_chase.connect(on_last_chase)
	GlobalTrackingValues.game_resumed.connect(on_game_resumed)
	sup_name = $".".name
	#print(sup_name)
	if GlobalTrackingValues.difficulty_level > 2:
		$seekingArea/seeking_zone/Polygon2D.visible = false
		$seekingArea/seeking_zone_left/Polygon2D2.visible = false
		$seekingArea/seeking_zone_right/Polygon2D3.visible = false

func _process(delta: float) -> void:
	supervisor_active(active)
	if GlobalTrackingValues.game_paused:
		time_left = seeking_timer.time_left
		seeking_timer.stop()

func _on_seeking_area_body_entered(body: Node2D) -> void:
	#print(sup_name, " I can see the kitty!")
	tracking_kitty = true
	can_see_kitty = true
	seeking_timer.start()
	

func _on_seeking_area_body_exited(body: Node2D) -> void:
	#print(sup_name, " I lost sight of the kitty :(")
	can_see_kitty = false


func _on_seeking_timer_timeout() -> void:
	if can_see_kitty:
		seeking_timer.start()
	else:
		tracking_kitty = false

func _on_capture_area_area_entered(area: Area2D) -> void:
	GlobalTrackingValues.kitty_caught_from_sup = true
	#print(sup_name, " I have caught the kitty!")

func _on_capture_area_area_exited(area: Area2D) -> void:
	GlobalTrackingValues.kitty_caught_from_sup = false
	#print(sup_name, " The kitty escaped me :(")

func on_last_chase() -> void:
	last_chase_tracking = true

func on_game_resumed() -> void:
	seeking_timer.start(time_left)

func supervisor_active(status : bool) -> void:
	var disabled_status
	if status:
		disabled_status = false
	else:
		disabled_status = true
	$CollisionShape2D.disabled = disabled_status
	$seekingArea/seeking_zone.disabled = disabled_status
	$seekingArea/seeking_zone_left.disabled = disabled_status
	$seekingArea/seeking_zone_right.disabled = disabled_status
	$captureArea/CollisionShape2D.disabled = disabled_status
	$".".visible = status
