extends Node2D
@onready var level_time_display: Label = $CanvasLayer/levelTimeDisplay
@onready var level_timer: Timer = $levelTimer

func _process(delta: float) -> void:
	level_time_display.text = str(round(level_timer.time_left))

func _on_level_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")
