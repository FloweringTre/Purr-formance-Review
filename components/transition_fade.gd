extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $Label

signal transition_finished

func _ready() -> void:
	color_rect.visible = false
	label.visible = false
	animation_player.animation_finished.connect(on_animation_finished)


func on_animation_finished(anim_name) -> void:
	if anim_name == "fade_dark":
		transition_finished.emit()
		animation_player.play("fade_normal")
	elif anim_name == "fade_normal":
		color_rect.visible = false
		label.visible = false

func transition() -> void:
	color_rect.visible = true
	animation_player.play("fade_dark")

func text_transition(scene_label : String) -> void:
	label.text = scene_label
	label.visible = true
	color_rect.visible = true
	animation_player.play("fade_dark")
	
