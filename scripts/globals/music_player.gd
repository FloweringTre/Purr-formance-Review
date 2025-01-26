extends Node

@onready var music_player: AudioStreamPlayer = $music_player


func _ready() -> void:
	if GlobalTrackingValues.music_playing:
		music_player.play()
	else:
		music_player.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause_music"):
		if GlobalTrackingValues.music_playing:
			music_player.stream_paused = true
			GlobalTrackingValues.music_playing = false
		else:
			music_player.stream_paused = false
			GlobalTrackingValues.music_playing = true

func pause_music() -> void:
	music_player.stream_paused = true
	GlobalTrackingValues.music_playing = false

func resume_music() -> void:
	music_player.stream_paused = false
	GlobalTrackingValues.music_playing = true
