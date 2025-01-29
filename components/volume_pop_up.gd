extends Control

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause_music"):
		if GlobalTrackingValues.music_playing:
			$textConditions/HBoxContainer/CheckBox.button_pressed = false
		else:
			$textConditions/HBoxContainer/CheckBox.button_pressed = true

func _on_volume_back_button_button_pressed() -> void:
	$".".visible = false

func _on_music_volume_value_changed(value: float) -> void:
	MusicPlayer.set_volume(value)

func _on_effects_volume_value_changed(value: float) -> void:
	GlobalTrackingValues.sound_effect_volume = value
	$meowAudioPlayer.volume_db = value

func _on_effects_volume_drag_ended(value_changed: bool) -> void:
	$meowAudioPlayer.play()

func _on_check_box_pressed() -> void:
	if GlobalTrackingValues.music_playing:
		GlobalTrackingValues.music_playing = false
	else:
		GlobalTrackingValues.music_playing = true
	
	GlobalTrackingValues.music_alert.emit()

func _on_mute_button_pressed() -> void:
	if GlobalTrackingValues.music_playing:
		GlobalTrackingValues.music_playing = false
		$textConditions/HBoxContainer/CheckBox.button_pressed = true
	else:
		GlobalTrackingValues.music_playing = true
		$textConditions/HBoxContainer/CheckBox.button_pressed = false
	
	GlobalTrackingValues.music_alert.emit()
