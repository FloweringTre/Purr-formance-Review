extends Control

@onready var splash_timer: Timer = $splashTimer
@onready var diff_level: Label = $VBoxContainer/difficultyContainer/diffLevel
@onready var diff_about: Label = $VBoxContainer/difficultyContainer/diffAbout
@onready var difficulty_slider: HSlider = $VBoxContainer/difficultyContainer/difficultySlider
@onready var exit_button: Panel = $VBoxContainer/buttonsContainer/exitButton

@export var for_web : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicPlayer.main_menu_music()
	if !GlobalTrackingValues.game_was_played:
		$TextureRect.visible = true
		splash_timer.start()
	else:
		$TextureRect.visible = false
	_on_difficulty_slider_drag_ended(true)
	
	if for_web:
		exit_button.set_disabled()

func _on_timer_timeout() -> void:
	$AnimationPlayer.play("fade")

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_new_game_button_pressed() -> void:
	TransitionFade.text_transition("In an office\nsomewhere...")
	await TransitionFade.transition_finished
	if !GlobalTrackingValues.play_cutscenes:
		get_tree().change_scene_to_file("res://scenes/officeSpace.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/cutscene.tscn")

func _on_difficulty_slider_drag_ended(value_changed: bool) -> void:
	var value = difficulty_slider.value
	GlobalTrackingValues.difficulty_level = value
	diff_level.text = GlobalTrackingValues.diffLevels[value]
	diff_about.text = GlobalTrackingValues.aboutLevels[value]

func _on_help_back_button_button_pressed() -> void:
	$helpPopUp.visible = false

func _on_help_button_button_pressed() -> void:
	$helpPopUp.visible = true

func _on_goals_back_button_button_pressed() -> void:
	$goalsPopUp.visible = false

func _on_goals_button_button_pressed() -> void:
	$goalsPopUp.visible = true

func _on_volume_button_button_pressed() -> void:
	$volumePopUp.visible = true

func _on_volume_back_button_button_pressed() -> void:
	$volumePopUp.visible = false


func _on_check_box_pressed() -> void:
	if GlobalTrackingValues.play_cutscenes:
		GlobalTrackingValues.play_cutscenes = false
	else:
		GlobalTrackingValues.play_cutscenes = true

func _on_cutscene_button_pressed() -> void:
	if GlobalTrackingValues.play_cutscenes:
		GlobalTrackingValues.play_cutscenes = false
		$VBoxContainer/cutsceneContainer/CheckBox.button_pressed = true
	else:
		GlobalTrackingValues.play_cutscenes = true
		$VBoxContainer/cutsceneContainer/CheckBox.button_pressed = false
