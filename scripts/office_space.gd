extends Node2D
@onready var level_time_display: Label = $gameUI/topBar/timer/levelTimeDisplay
@onready var level_timer: Timer = $levelTimer
var time_left 
@onready var end_level_pop_up: Control = $gameUI/endLevelPopUp
@onready var title: Label = $gameUI/endLevelPopUp/textConditions/title
@onready var about_text: Label = $gameUI/endLevelPopUp/textConditions/aboutText
@onready var game_ui: CanvasLayer = $gameUI
@onready var escape_menu: Control = $gameUI/escapeMenu
@onready var music_player: AudioStreamPlayer = $gameUI/musicPlayer
@onready var interaction_message: Label = $gameUI/topBar/interactionMessage
@onready var task_list: Control = $gameUI/topBar/taskList
@onready var trash_count: Label = $gameUI/topBar/taskList/VBoxContainer/HBoxContainer/trashCount
@onready var score_count: Label = $gameUI/endLevelPopUp/textConditions/scoreCount


func _ready() -> void:
	GlobalTrackingValues.game_won.connect(on_game_won)
	GlobalTrackingValues.set_message.connect(set_message)
	GlobalTrackingValues.list_active.connect(on_list_active)
	GlobalTrackingValues.game_was_played = true
	end_level_pop_up.visible = false
	game_ui.visible = true
	music_player.play()
	on_list_active(true)

func _process(delta: float) -> void:
	if GlobalTrackingValues.game_paused or GlobalTrackingValues.game_over:
		level_time_display.text = str(round(time_left))
	else:
		level_time_display.text = str(round(level_timer.time_left))
	
	if GlobalTrackingValues.kitty_caught_from_sup:
		GlobalTrackingValues.game_over = true
		time_left = level_timer.time_left
		level_time_display.text = str(round(time_left))
		level_timer.stop()
		game_loss()
		music_player.stop()
	
	if Input.is_action_just_pressed("pause"):
		GlobalTrackingValues.game_paused = true
		escape_menu.visible = true
		music_player.stream_paused = true
		time_left = level_timer.time_left
		level_timer.stop()

func _on_level_timer_timeout() -> void:
	GlobalTrackingValues.last_chase.emit()
	GlobalTrackingValues.send_message("Get to the bed to end the workday!")

func on_game_won() -> void:
	GlobalTrackingValues.send_message("")
	GlobalTrackingValues.game_over = true
	end_level_pop_up.visible = true
	time_left = round(level_timer.time_left)
	level_time_display.text = str(round(time_left))
	level_timer.stop()
	if GlobalTrackingValues.successful_day():
		title.text = "Congraduations"
		about_text.text = "You have gotten through the workday without being caught by the supervisor!"
	else:
		title.text = "Oh no..."
		about_text.text = "You didn't complete your kitty tasks today."
	score_count.text = str(GlobalTrackingValues.score_calculate(time_left))

func game_loss() -> void:
	GlobalTrackingValues.send_message("")
	end_level_pop_up.visible = true
	title.text = "You've been caught!"
	about_text.text = "Your office reign of terror has come to an end. :("
	score_count.text = str(GlobalTrackingValues.score_calculate(0))

func _on_new_game_button_pressed() -> void:
	get_tree().reload_current_scene()
	GlobalTrackingValues.game_reset()

func _on_exit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")
	GlobalTrackingValues.game_reset()

func _on_continue_button_pressed() -> void:
	GlobalTrackingValues.game_paused = false
	GlobalTrackingValues.game_resumed.emit()
	escape_menu.visible = false
	level_timer.start(time_left)
	music_player.stream_paused = false

func set_message() -> void:
	interaction_message.text = GlobalTrackingValues.message

func on_list_active(is_active : bool) -> void:
	task_list.visible = is_active
	trash_count.text = str(GlobalTrackingValues.trash_spilled, "/3")
	$gameUI/topBar/taskList/strikes/safeLine.visible = GlobalTrackingValues.money_spilled
	$gameUI/topBar/taskList/strikes/printerLine.visible = GlobalTrackingValues.printer_broken
	if GlobalTrackingValues.trash_spilled == 3:
		$gameUI/topBar/taskList/strikes/trashLine.visible = true
	else:
		$gameUI/topBar/taskList/strikes/trashLine.visible = false
