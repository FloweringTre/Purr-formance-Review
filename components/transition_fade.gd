extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal transition_finished

func _ready() -> void:
	color_rect.visible = false
	animation_player.animation_finished.connect(on_animation_finished)


func on_animation_finished(anim_name) -> void:
	if anim_name == "fade_dark":
		transition_finished.emit()
		animation_player.play("fade_normal")
	elif anim_name == "fade_normal":
		color_rect.visible = false

func transition() -> void:
	color_rect.visible = true
	animation_player.play("fade_dark")
