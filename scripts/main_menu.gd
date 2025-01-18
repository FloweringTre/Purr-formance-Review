extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TextureRect.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	$AnimationPlayer.play("fade")

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_new_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/officeSpace.tscn")
