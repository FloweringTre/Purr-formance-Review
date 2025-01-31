extends Node2D
@onready var kitty_animation_player: AnimationPlayer = $kitty/kittyAnimationPlayer
@onready var phone_animation_player: AnimationPlayer = $phones/phoneAnimationPlayer
@onready var emote_animation_player: AnimationPlayer = $emoteAnimationPlayer
@onready var kittyemote: Sprite2D = $kitty/kittySprite/kittyemote
@onready var supemote: Sprite2D = $sup/supSprite/supemote


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
	emote_animation_player.play("RESET")
	$meowAudioPlayer.volume_db = GlobalTrackingValues.sound_effect_volume
	Dialogic.signal_event.connect(on_dialogic_signal)
	GlobalTrackingValues.cat_dialogue.connect(run_cat_dialogue)
	GlobalTrackingValues.worker_dialogue.connect(run_worker_dialogue)
	
	#GlobalTrackingValues.workday = 4
	#GlobalTrackingValues.repeated_day = true
	
	MusicPlayer.set_track(GlobalTrackingValues.workday)
	
	if GlobalTrackingValues.repeated_day:
		run_cat_dialogue("day_repeat")
	
	else:
		match GlobalTrackingValues.workday:
			0:
				run_cat_dialogue("day0_cat")
			1:
				run_worker_dialogue("day1")
			2:
				run_cat_dialogue("day2")
			3:
				run_worker_dialogue("day3")
			4:
				run_worker_dialogue("day4_worker")
				

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
		emote_animation_player.play("soft_bounce")
		kittyemote.frame = 7
		phone_animation_player.play("kitty_ring")
	
	if argument == "kitty_awake":
		kitty_animation_player.play("idle")
		$kitty/kittySprite.flip_h = true
		phone_animation_player.play("RESET")
	
	if argument == "sup_answered":
		phone_animation_player.play("RESET")
	
	if argument == "big_boss_human":
		$sup/ceoSprite/AnimationPlayer.play("soft_bounce")
	
	if argument == "end":
		TransitionFade.transition()
		await TransitionFade.transition_finished
		get_tree().change_scene_to_file("res://scenes/officeSpace.tscn")
	
	if argument == "mad":
		supemote.frame = 27
	
	if argument == "nervous":
		supemote.frame = 25
		kittyemote.frame = 25
	
	if argument == "happy":
		supemote.frame = 2
		kittyemote.frame = 2
	
	if argument == "sad":
		supemote.frame = 3
		kittyemote.frame = 3
	
	if argument == "question":
		supemote.frame = 4
		kittyemote.frame = 4
	
	if argument == "!":
		supemote.frame = 5
		kittyemote.frame = 5
	
	if argument == "no emote":
		emote_animation_player.play("off")
	
	if argument == "emote":
		emote_animation_player.play("on")
	
	if argument == "soft_bounce":
		emote_animation_player.play("soft_bounce")

func _on_skip_button_button_pressed() -> void:
	Dialogic.end_timeline()
	TransitionFade.transition()
	await TransitionFade.transition_finished
	get_tree().change_scene_to_file("res://scenes/officeSpace.tscn")


func _on_emote_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "on":
		emote_animation_player.play("soft_bounce")
	else:
		pass
