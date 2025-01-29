extends Node2D
@onready var kitty_animation_player: AnimationPlayer = $kitty/kittyAnimationPlayer
@onready var phone_animation_player: AnimationPlayer = $Node2D/phoneAnimationPlayer

@onready var kitty_cam_marker: Marker2D = $camera/kittyMarker
@onready var sup_cam_marker: Marker2D = $camera/supMarker
@onready var camera_2d: Camera2D = $camera/Camera2D

@onready var kitty_phone_marker: Marker2D = $Node2D/kitty_phone/Marker2D
@onready var kitty_marker: Marker2D = $kitty/kittySprite/Marker2D2


func _ready() -> void:
	$meowAudioPlayer.volume_db = GlobalTrackingValues.sound_effect_volume
	Dialogic.signal_event.connect(on_dialogic_signal)
	if GlobalTrackingValues.workday == 0:
		kitty_animation_player.play("sleep")
		phone_animation_player.play("kitty_ring")
		camera_2d.position = kitty_cam_marker.position
		run_dialogue("day1_cat")

func run_dialogue(dialogueString) -> void:
	#Dialogic.start(dialogueString)
	var layout = Dialogic.Styles.load_style("textbubble_style")
	layout.register_character(load("res://dialogue/characters/cat_boss.dch"), kitty_phone_marker)
	layout.register_character(load("res://dialogue/characters/kitty.dch"), kitty_marker)
	layout.register_character(load("res://dialogue/characters/supervisor.dch"), $sup/supSprite)
	layout.register_character(load("res://dialogue/characters/big_boss.dch"), $sup_phone)
	Dialogic.start(dialogueString)

func on_dialogic_signal(argument : String):
	if argument == "meow":
		$meowAudioPlayer.play()
	if argument == "kitty_awake":
		kitty_animation_player.play("idle")
		$kitty/kittySprite.flip_h = true
		phone_animation_player.play("RESET")
	if argument == "end":
		TransitionFade.transition()
		await TransitionFade.transition_finished
		get_tree().change_scene_to_file("res://scenes/officeSpace.tscn")
