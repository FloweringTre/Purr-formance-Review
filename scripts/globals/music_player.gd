extends Node
@onready var day_one: AudioStreamPlayer = $dayOne
@onready var day_two: AudioStreamPlayer = $dayTwo
@onready var day_three: AudioStreamPlayer = $dayThree
@onready var day_four: AudioStreamPlayer = $dayFour
@onready var day_five: AudioStreamPlayer = $dayFive
@onready var level_won: AudioStreamPlayer = $levelWon
@onready var level_loss: AudioStreamPlayer = $levelLoss

var is_playing : bool
var track_playing: int


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause_music"):
		if GlobalTrackingValues.music_playing:
			GlobalTrackingValues.music_playing = false
			pause_music()
		else:
			GlobalTrackingValues.music_playing = true
			resume_music()

func pause_music() -> void:
	match track_playing:
		0: #mon
			day_one.stream_paused = true
		1: #tues
			day_two.stream_paused = true
		2: #wed
			day_three.stream_paused = true
		3: #thurs
			day_four.stream_paused = true
		4: #fri
			day_five.stream_paused = true
		5: # level won
			level_won.stream_paused = true
		6: # level loss
			level_loss.stream_paused = true

func resume_music() -> void:
	if GlobalTrackingValues.music_playing:
		match track_playing:
			0: #mon
				day_one.stream_paused = false
			1: #tues
				day_two.stream_paused = false
			2: #wed
				day_three.stream_paused = false
			3: #thurs
				day_four.stream_paused = false
			4: #fri
				day_five.stream_paused = false
			5: # level won
				level_won.stream_paused = false
			6: # level loss
				level_loss.stream_paused = false

func set_track(track : int) -> void:
	stop_music()
	track_playing = track
	if GlobalTrackingValues.music_playing:
		match track_playing:
			0: #mon
				day_one.play()
			1: #tues
				day_two.play()
			2: #wed
				day_three.play()
			3: #thurs
				day_four.play()
			4: #fri
				day_five.play()
			5: # level won
				level_won.play()
			6: # level loss
				level_loss.play()

func stop_music() -> void:
	day_one.stop()
	day_two.stop()
	day_three.stop()
	day_four.stop()
	day_five.stop()
	level_loss.stop()
	level_won.stop()

func main_menu_music() -> void:
	var random_track = randi_range(0, 4)
	set_track(random_track)
