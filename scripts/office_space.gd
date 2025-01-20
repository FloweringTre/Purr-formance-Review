extends Node2D
@onready var level_time_display: Label = $CanvasLayer/timer/levelTimeDisplay
@onready var level_timer: Timer = $levelTimer
@onready var end_level_pop_up: Control = $CanvasLayer/endLevelPopUp
@onready var title: Label = $CanvasLayer/endLevelPopUp/textConditions/title
@onready var about_text: Label = $CanvasLayer/endLevelPopUp/textConditions/aboutText

func _ready() -> void:
	GlobalTrackingValues.game_was_played = true
	end_level_pop_up.visible = false

func _process(delta: float) -> void:
	level_time_display.text = str(round(level_timer.time_left))
	if GlobalTrackingValues.kitty_caught:
		GlobalTrackingValues.game_over = true
		game_loss()
		level_timer.stop()

func _on_level_timer_timeout() -> void:
	GlobalTrackingValues.game_over = true
	end_level_pop_up.visible = true
	title.text = "Congraduations"
	about_text.text = "You have gotten through the workday without being caught by the supervisor!"

func game_loss() -> void:
	end_level_pop_up.visible = true
	title.text = "You've been caught!"
	about_text.text = "Your office reign of terror has come to an end. :("


func _on_new_game_button_pressed() -> void:
	get_tree().reload_current_scene()
	GlobalTrackingValues.kitty_caught = false
	GlobalTrackingValues.game_over = false


func _on_exit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")
	GlobalTrackingValues.kitty_caught = false
	GlobalTrackingValues.game_over = false
