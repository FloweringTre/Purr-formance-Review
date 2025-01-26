extends Node2D
@onready var level_time_display: Label = $gameUI/topBar/timer/levelTimeDisplay
@onready var level_timer: Timer = $levelTimer
var time_left 
var music_playing : bool = true
var day_successful : bool
@onready var end_level_pop_up: Control = $gameUI/endLevelPopUp
@onready var title: Label = $gameUI/endLevelPopUp/textConditions/title
@onready var about_text: Label = $gameUI/endLevelPopUp/textConditions/aboutText
@onready var game_ui: CanvasLayer = $gameUI
@onready var escape_menu: Control = $gameUI/escapeMenu
@onready var interaction_message: Label = $gameUI/topBar/interactionMessage
@onready var task_list: Control = $gameUI/topBar/taskList
@onready var trash_count: Label = $gameUI/topBar/taskList/taskBoxContainer/HBoxContainer/trashCount
@onready var donut_count: Label = $gameUI/topBar/taskList/taskBoxContainer/HBoxContainer/donutCount
@onready var score_count: Label = $gameUI/endLevelPopUp/textConditions/scoreCount
@onready var progress_bar: TextureProgressBar = $gameUI/topBar/taskList/ProgressBar
@onready var workday: Label = $gameUI/topBar/taskList/dayBoxContainer/workday
@onready var continue_button: Panel = $gameUI/endLevelPopUp/HBoxContainer/continueButton
@onready var redo_button: Panel = $gameUI/endLevelPopUp/HBoxContainer/redoButton


func _ready() -> void:
	GlobalTrackingValues.game_won.connect(on_game_won)
	GlobalTrackingValues.set_message.connect(set_message)
	GlobalTrackingValues.list_active.connect(on_list_active)
	GlobalTrackingValues.ready_last_chase.connect(on_ready_last_chase)
	GlobalTrackingValues.game_was_played = true
	end_level_pop_up.visible = false
	game_ui.visible = true
	
	on_list_active(true)
	set_work_day()

func _process(delta: float) -> void:
	if GlobalTrackingValues.game_paused or GlobalTrackingValues.game_over:
		level_time_display.text = str(round(time_left))
	else:
		level_time_display.text = str(round(level_timer.time_left))
	
	if GlobalTrackingValues.kitty_caught_from_sup:
		GlobalTrackingValues.game_over = true
		time_left = level_timer.time_left
		level_time_display.text = str(round(time_left))
		level_timer.paused = true
		game_loss()
		MusicPlayer.pause_music()
	
	if Input.is_action_just_pressed("pause"):
		if GlobalTrackingValues.game_over:
			pass
		else:
			GlobalTrackingValues.game_paused = true
			escape_menu.visible = true
			MusicPlayer.pause_music()
			time_left = level_timer.time_left
			level_timer.stop()

func _on_level_timer_timeout() -> void:
	GlobalTrackingValues.send_message("")
	GlobalTrackingValues.game_over = true
	end_level_pop_up.visible = true
	time_left = round(level_timer.time_left)
	level_time_display.text = str(round(time_left))
	level_timer.paused = true
	title.text = "Oh no..."
	about_text.text = "You didn't complete your kitty tasks today."
	day_successful = false
	redo_button.visible = true
	continue_button.visible = false
	score_count.text = GlobalTrackingValues.score_calculate(0)

func on_game_won() -> void:
	GlobalTrackingValues.send_message("")
	GlobalTrackingValues.game_over = true
	end_level_pop_up.visible = true
	time_left = round(level_timer.time_left)
	level_time_display.text = str(round(time_left))
	level_timer.paused = true
	
	if GlobalTrackingValues.successful_day() && GlobalTrackingValues.workday != 4:
		title.text = "Congrats"
		about_text.text = "You have gotten through the workday without being caught by the supervisor!"
		day_successful = true
		redo_button.visible = false
		continue_button.visible = true
	elif GlobalTrackingValues.successful_day() && GlobalTrackingValues.workday == 4:
		title.text = "Well done!"
		about_text.text = "You have completed a full week with amazing KKPIs! You have been promoted to Official Office Destroyer! There is no stopping you!"
		day_successful = true
		redo_button.visible = false
		continue_button.visible = false
	
	score_count.text = GlobalTrackingValues.score_calculate(time_left)

func game_loss() -> void:
	GlobalTrackingValues.send_message("")
	GlobalTrackingValues.kitty_caught_from_sup = false
	end_level_pop_up.visible = true
	title.text = "You've been caught!"
	about_text.text = "Your office reign of terror has come to an end. :("
	score_count.text = GlobalTrackingValues.score_calculate(0)
	continue_button.visible = false

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
	MusicPlayer.resume_music()

func set_message() -> void:
	interaction_message.text = GlobalTrackingValues.message

func on_list_active(is_active : bool) -> void:
	task_list.visible = is_active
	progress_bar.value = GlobalTrackingValues.productivity_level()
	trash_count.text = str(GlobalTrackingValues.trash_spilled, "/3")
	donut_count.text = str(GlobalTrackingValues.donuts_spilled, "/3")
	$gameUI/topBar/taskList/strikes/sinkLine.visible = GlobalTrackingValues.sink_broken
	$gameUI/topBar/taskList/strikes/printerLine.visible = GlobalTrackingValues.printer_broken
	if GlobalTrackingValues.trash_spilled == 3:
		$gameUI/topBar/taskList/strikes/trashLine.visible = true
	else:
		$gameUI/topBar/taskList/strikes/trashLine.visible = false
	
	if GlobalTrackingValues.donuts_spilled == 3:
		$gameUI/topBar/taskList/strikes/donutLine.visible = true
	else:
		$gameUI/topBar/taskList/strikes/donutLine.visible = false

func set_work_day() -> void:
	match GlobalTrackingValues.workday:
		0: #monday
			workday.text = "Monday"
			level_timer.start(100)
		1: #tuesday
			workday.text = "Tuesday"
			$gameUI/topBar/taskList/taskBoxContainer/HBoxContainer/divider2.visible = true
			$gameUI/topBar/taskList/taskBoxContainer/HBoxContainer/printer.visible = true
			level_timer.start(120)
		2: #wednesday
			workday.text = "Wednesday"
			$gameUI/topBar/taskList/taskBoxContainer/HBoxContainer/divider2.visible = true
			$gameUI/topBar/taskList/taskBoxContainer/HBoxContainer/printer.visible = true
			$gameUI/topBar/taskList/taskBoxContainer/HBoxContainer/divider.visible = true
			$gameUI/topBar/taskList/taskBoxContainer/HBoxContainer/sink.visible = true
			level_timer.start(140)
		3: #thursday
			workday.text = "Thursday"
			$gameUI/topBar/taskList/taskBoxContainer/HBoxContainer/divider2.visible = true
			$gameUI/topBar/taskList/taskBoxContainer/HBoxContainer/printer.visible = true
			$gameUI/topBar/taskList/taskBoxContainer/HBoxContainer/divider.visible = true
			$gameUI/topBar/taskList/taskBoxContainer/HBoxContainer/sink.visible = true
			$gameUI/topBar/taskList/taskBoxContainer/HBoxContainer/divider3.visible = true
			$gameUI/topBar/taskList/taskBoxContainer/HBoxContainer/donuts.visible = true
			$gameUI/topBar/taskList/taskBoxContainer/HBoxContainer/donutCount.visible = true
			level_timer.start(160)
		4: #friday
			workday.text = "Friday"
			$supervisor/SupervisorMan3.active = true
			$gameUI/topBar/taskList/taskBoxContainer/HBoxContainer/divider2.visible = true
			$gameUI/topBar/taskList/taskBoxContainer/HBoxContainer/printer.visible = true
			$gameUI/topBar/taskList/taskBoxContainer/HBoxContainer/divider.visible = true
			$gameUI/topBar/taskList/taskBoxContainer/HBoxContainer/sink.visible = true
			$gameUI/topBar/taskList/taskBoxContainer/HBoxContainer/divider3.visible = true
			$gameUI/topBar/taskList/taskBoxContainer/HBoxContainer/donuts.visible = true
			$gameUI/topBar/taskList/taskBoxContainer/HBoxContainer/donutCount.visible = true
			level_timer.start(180)

func on_ready_last_chase() -> void:
	$waitTimer.start()

func _on_wait_timer_timeout() -> void:
	GlobalTrackingValues.last_chase.emit()

func _on_continue_game_button_pressed() -> void:
	GlobalTrackingValues.day_reset(day_successful)
	get_tree().reload_current_scene()
