extends Node2D
@onready var level_time_display: Label = $gameUI/topBar/timer/levelTimeDisplay
@onready var level_timer: Timer = $levelTimer
var time_left 
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
@onready var progress_bar: TextureProgressBar = $gameUI/topBar/taskList/progress/ProgressBar
@onready var workday: Label = $gameUI/topBar/taskList/dayBoxContainer/workday
@onready var continue_button: Panel = $gameUI/endLevelPopUp/HBoxContainer/continueButton
@onready var redo_button: Panel = $gameUI/endLevelPopUp/HBoxContainer/redoButton
@onready var diff_text: Label = $gameUI/endLevelPopUp/diffText
@onready var diff_text_2: Label = $gameUI/escapeMenu/diffText2
@onready var diff_text_3: Label = $gameUI/helpPopUp/diffText3
@onready var diff_text_4: Label = $gameUI/controlsPopUp/diffText4
@onready var diff_text_5: Label = $gameUI/startingday1PopUp/diffText5
@onready var diff_text_6: Label = $gameUI/startingDayPopUp/diffText6

@onready var progress_percent: Label = $gameUI/topBar/taskList/progress/progressPercent
@onready var score_title: Label = $gameUI/endLevelPopUp/textConditions/scoreTitle


func _ready() -> void:
	GlobalTrackingValues.game_over = false
	if !GlobalTrackingValues.play_cutscenes:
		MusicPlayer.set_track(GlobalTrackingValues.workday)
	GlobalTrackingValues.game_won.connect(on_game_won)
	GlobalTrackingValues.set_message.connect(set_message)
	GlobalTrackingValues.list_active.connect(on_list_active)
	GlobalTrackingValues.ready_last_chase.connect(on_ready_last_chase)
	GlobalTrackingValues.game_was_played = true
	end_level_pop_up.visible = false
	game_ui.visible = true
	var difficulty_text = str("Difficulty: ", GlobalTrackingValues.diffLevels[GlobalTrackingValues.difficulty_level])
	diff_text.text = difficulty_text
	diff_text_2.text = difficulty_text
	diff_text_3.text = difficulty_text
	diff_text_4.text = difficulty_text
	diff_text_5.text = difficulty_text
	diff_text_6.text = difficulty_text
	GlobalTrackingValues.set_up_position_arrays()
	on_list_active(true)
	set_work_day()
	print("Difficulty Level: ", GlobalTrackingValues.difficulty_level)
	day_start_message(GlobalTrackingValues.workday)

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
	MusicPlayer.set_track(6)
	end_level_pop_up.visible = true
	time_left = round(level_timer.time_left)
	level_time_display.text = str(round(time_left))
	level_timer.paused = true
	title.text = "Oh no..."
	about_text.text = "You didn't complete your KKPIs today."
	day_successful = false
	if GlobalTrackingValues.difficulty_level != 3:
		redo_button.visible = true
		continue_button.visible = false
	else:
		about_text.text = "You didn't complete your KKPIs today. \n We are sorry, this is the end of your purr-formance review. You didn't get the position."
		score_title.text = "Your final purr-formance rating"
		redo_button.visible = false
		continue_button.visible = false
	score_count.text = GlobalTrackingValues.score_calculate(0)

func on_game_won() -> void:
	GlobalTrackingValues.send_message("")
	GlobalTrackingValues.game_over = true
	end_level_pop_up.visible = true
	time_left = round(level_timer.time_left)
	level_time_display.text = str(round(time_left))
	level_timer.paused = true
	score_count.text = GlobalTrackingValues.score_calculate(time_left)
	
	if GlobalTrackingValues.successful_day() && GlobalTrackingValues.workday != 4:
		MusicPlayer.set_track(5)
		title.text = "Success!"
		about_text.text = str("You completed all your KKPIs today! \n You have ", (4 - GlobalTrackingValues.workday), " days left in your\npurr-formance review.")
		day_successful = true
		redo_button.visible = false
		continue_button.visible = true
	elif GlobalTrackingValues.successful_day() && GlobalTrackingValues.workday == 4:
		GlobalTrackingValues.day_reset(true)
		GlobalTrackingValues.promotion_achieved = true
		TransitionFade.text_transition("The Purr-formance\nReview is over!")
		await TransitionFade.transition_finished
		#get_tree().reload_current_scene()
		get_tree().change_scene_to_file("res://scenes/cutscene.tscn")

func game_loss() -> void:
	GlobalTrackingValues.send_message("")
	MusicPlayer.set_track(6)
	GlobalTrackingValues.kitty_caught_from_sup = false
	end_level_pop_up.visible = true
	title.text = "You've been caught!"
	about_text.text = "This is an automatic failure of your KKPIs for the day."
	score_count.text = GlobalTrackingValues.score_calculate(0)
	if GlobalTrackingValues.difficulty_level != 3:
		redo_button.visible = true
		continue_button.visible = false
	else:
		about_text.text = "This is an automatic failure of your KKPIs for the day. \n We are sorry, this is the end of your purr-formance review. You didn't get the position."
		score_title.text = "Your final purr-formance rating"
		redo_button.visible = false
		continue_button.visible = false

func _on_new_game_button_pressed() -> void:
	GlobalTrackingValues.game_reset()
	TransitionFade.text_transition("In an office\nsomewhere...")
	await TransitionFade.transition_finished
	if !GlobalTrackingValues.play_cutscenes:
		get_tree().reload_current_scene()
	else:
		get_tree().change_scene_to_file("res://scenes/cutscene.tscn")

func _on_exit_button_pressed() -> void:
	GlobalTrackingValues.game_reset()
	TransitionFade.transition()
	await TransitionFade.transition_finished
	get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")

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
	progress_percent.text = str(GlobalTrackingValues.productivity_level(), "%")
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
	var time : int
	match GlobalTrackingValues.workday:
		0: #monday
			workday.text = "Monday"
			time = 100
		1: #tuesday
			workday.text = "Tuesday"
			$gameUI/topBar/taskList/taskBoxContainer/HBoxContainer/divider2.visible = true
			$gameUI/topBar/taskList/taskBoxContainer/HBoxContainer/printer.visible = true
			time = 120
		2: #wednesday
			workday.text = "Wednesday"
			$gameUI/topBar/taskList/taskBoxContainer/HBoxContainer/divider2.visible = true
			$gameUI/topBar/taskList/taskBoxContainer/HBoxContainer/printer.visible = true
			$gameUI/topBar/taskList/taskBoxContainer/HBoxContainer/divider.visible = true
			$gameUI/topBar/taskList/taskBoxContainer/HBoxContainer/sink.visible = true
			time = 140
		3: #thursday
			workday.text = "Thursday"
			$gameUI/topBar/taskList/taskBoxContainer/HBoxContainer/divider2.visible = true
			$gameUI/topBar/taskList/taskBoxContainer/HBoxContainer/printer.visible = true
			$gameUI/topBar/taskList/taskBoxContainer/HBoxContainer/divider.visible = true
			$gameUI/topBar/taskList/taskBoxContainer/HBoxContainer/sink.visible = true
			$gameUI/topBar/taskList/taskBoxContainer/HBoxContainer/divider3.visible = true
			$gameUI/topBar/taskList/taskBoxContainer/HBoxContainer/donuts.visible = true
			$gameUI/topBar/taskList/taskBoxContainer/HBoxContainer/donutCount.visible = true
			time = 160
		4: #friday
			workday.text = "Friday"
			$supervisor/bigBossMan.active = true
			$gameUI/topBar/taskList/taskBoxContainer/HBoxContainer/divider2.visible = true
			$gameUI/topBar/taskList/taskBoxContainer/HBoxContainer/printer.visible = true
			$gameUI/topBar/taskList/taskBoxContainer/HBoxContainer/divider.visible = true
			$gameUI/topBar/taskList/taskBoxContainer/HBoxContainer/sink.visible = true
			$gameUI/topBar/taskList/taskBoxContainer/HBoxContainer/divider3.visible = true
			$gameUI/topBar/taskList/taskBoxContainer/HBoxContainer/donuts.visible = true
			$gameUI/topBar/taskList/taskBoxContainer/HBoxContainer/donutCount.visible = true
			time = 180
			
	match GlobalTrackingValues.difficulty_level:
		0:
			$supervisor/SupervisorMan.active = true
			$supervisor/SupervisorMan2.active = false
			$supervisor/SupervisorMan3.active = false
		1:
			$supervisor/SupervisorMan.active = true
			$supervisor/SupervisorMan2.active = true
			$supervisor/SupervisorMan3.active = false
		2:
			$supervisor/SupervisorMan.active = true
			$supervisor/SupervisorMan2.active = true
			$supervisor/SupervisorMan3.active = true
		3:
			$supervisor/SupervisorMan.active = true
			$supervisor/SupervisorMan2.active = true
			$supervisor/SupervisorMan3.active = true
			time += 10
	
	time_left = time
	level_timer.start(time)

func on_ready_last_chase() -> void:
	$waitTimer.start()

func _on_wait_timer_timeout() -> void:
	GlobalTrackingValues.last_chase.emit()

func _on_continue_game_button_pressed() -> void:
	GlobalTrackingValues.day_reset(day_successful)
	if day_successful:
		TransitionFade.text_transition("The next day...")
	else:
		TransitionFade.transition()
	await TransitionFade.transition_finished
	#get_tree().reload_current_scene()
	if !GlobalTrackingValues.play_cutscenes:
		get_tree().reload_current_scene()
	else:
		get_tree().change_scene_to_file("res://scenes/cutscene.tscn")

func _on_help_back_button_button_pressed() -> void:
	$gameUI/helpPopUp/Node2D/AnimationPlayer.stop()
	$gameUI/helpPopUp.visible = false

func _on_helpbutton_button_pressed() -> void:
	$gameUI/helpPopUp.visible = true
	$gameUI/helpPopUp/Node2D/AnimationPlayer.play("glow")

func _on_control_back_button_button_pressed() -> void:
	$gameUI/controlsPopUp.visible = false

func _on_controlsbutton_button_pressed() -> void:
	$gameUI/controlsPopUp.visible = true

func _on_volume_button_button_pressed() -> void:
	$gameUI/volumePopUp.visible = true


func day_start_message(workday : int) -> void:
	match workday:
		0:
			level_timer.paused = true
			$gameUI/startingday1PopUp.visible = true
			$gameUI/startingday1PopUp/Node2D/AnimationPlayer.play("glow")
			GlobalTrackingValues.game_paused = true
		1:
			level_timer.paused = true
			$gameUI/startingDayPopUp.visible = true
			GlobalTrackingValues.game_paused = true
		2:
			level_timer.paused = true
			$gameUI/startingDayPopUp.visible = true
			GlobalTrackingValues.game_paused = true
			$gameUI/startingDayPopUp/VBoxContainer/sink.visible = true
		3:
			level_timer.paused = true
			$gameUI/startingDayPopUp.visible = true
			GlobalTrackingValues.game_paused = true
			$gameUI/startingDayPopUp/VBoxContainer/sink.visible = true
			$gameUI/startingDayPopUp/VBoxContainer/donuts.visible = true
		4:
			level_timer.paused = true
			$gameUI/startingDayPopUp.visible = true
			GlobalTrackingValues.game_paused = true
			$gameUI/startingDayPopUp/VBoxContainer/sink.visible = true
			$gameUI/startingDayPopUp/VBoxContainer/donuts.visible = true

func _on_start_back_button_button_pressed() -> void:
	level_timer.paused = false
	$gameUI/startingday1PopUp.visible = false
	$gameUI/startingday1PopUp/Node2D/AnimationPlayer.stop()
	GlobalTrackingValues.game_paused = false


func _on_startingday_back_button_button_pressed() -> void:
	level_timer.paused = false
	$gameUI/startingDayPopUp.visible = false
	GlobalTrackingValues.game_paused = false
