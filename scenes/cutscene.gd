extends Node2D
@onready var kitty_animation_player: AnimationPlayer = $kitty/kittyAnimationPlayer
@onready var phone_animation_player: AnimationPlayer = $phones/phoneAnimationPlayer

@onready var kitty_cam_marker: Marker2D = $camera/kittyMarker
@onready var sup_cam_marker: Marker2D = $camera/supMarker
@onready var camera_2d: Camera2D = $camera/Camera2D

@onready var kitty_phone_marker: Marker2D = $phones/kitty_phone/Marker2D
@onready var kitty_marker: Marker2D = $kitty/kittySprite/Marker2D2
@onready var sup_phone_marker: Marker2D = $phones/sup_phone/Marker2D
@onready var sup_marker: Marker2D = $sup/supSprite/Marker2D
@onready var ceo_marker: Marker2D = $sup/ceoSprite/Marker2D


func _ready() -> void:
	$objects/KittyBed.no_glow()
	$meowAudioPlayer.volume_db = GlobalTrackingValues.sound_effect_volume
	Dialogic.signal_event.connect(on_dialogic_signal)
	GlobalTrackingValues.cat_dialogue.connect(run_cat_dialogue)
	GlobalTrackingValues.worker_dialogue.connect(run_worker_dialogue)
	
	if GlobalTrackingValues.repeated_day:
		run_cat_dialogue("day_repeat")
		MusicPlayer.main_menu_music()
	else:
		match GlobalTrackingValues.workday:
			0:
				run_cat_dialogue("day0_cat")
			1:
				run_worker_dialogue("day1")
				MusicPlayer.main_menu_music()
			2:
				run_cat_dialogue("day2")
				MusicPlayer.main_menu_music()
			3:
				run_worker_dialogue("day3")
				MusicPlayer.main_menu_music()
			4:
				run_worker_dialogue("day4_worker")
				MusicPlayer.main_menu_music()
				

func run_cat_dialogue(dialogueString) -> void:
	#Dialogic.start(dialogueString)
	camera_2d.position = kitty_cam_marker.position
	var layout = Dialogic.Styles.load_style("cat_textbubble")
	layout.register_character(load("res://dialogue/characters/cat_boss.dch"), kitty_phone_marker)
	layout.register_character(load("res://dialogue/characters/kitty.dch"), kitty_marker)
	Dialogic.start(dialogueString)
	print("running kitty dialogue: ", dialogueString)

func run_worker_dialogue(dialogueString) -> void:
	#Dialogic.start(dialogueString)
	camera_2d.position = sup_cam_marker.position
	var worker_layout = Dialogic.Styles.load_style("cat_textbubble")
	worker_layout.register_character(load("res://dialogue/characters/supervisor.dch"), sup_marker)
	worker_layout.register_character(load("res://dialogue/characters/big_boss.dch"), sup_phone_marker)
	worker_layout.register_character(load("res://dialogue/characters/big_boss_human.dch"), ceo_marker)
	Dialogic.start(dialogueString)

func on_dialogic_signal(argument : String):
	if argument == "meow":
		$meowAudioPlayer.play()
	
	if argument == "sup_ring":
		phone_animation_player.play("sup_ring")
	
	if argument == "kitty_ring":
		kitty_animation_player.play("sleep")
		phone_animation_player.play("kitty_ring")
	
	if argument == "kitty_awake":
		kitty_animation_player.play("idle")
		$kitty/kittySprite.flip_h = true
		phone_animation_player.play("RESET")
	
	if argument == "sup_answered":
		phone_animation_player.play("RESET")
	
	if argument == "big_boss_human":
		$sup/ceoSprite.visible = true
	
	if argument == "end":
		TransitionFade.transition()
		await TransitionFade.transition_finished
		get_tree().change_scene_to_file("res://scenes/officeSpace.tscn")
