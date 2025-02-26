extends Panel

@export var button_text : String
@export var long : bool
@onready var button_label: Label = %buttonLabel

signal button_pressed()

func _ready() -> void:
	if long:
		$textContainer.custom_minimum_size.x = 154
		$ButtonLong.visible = true
	else:
		$textContainer.custom_minimum_size.x = 58
		$ButtonShort.visible = true
	button_label.text = button_text
	button_label.add_theme_color_override("font_color", Color(0.306, 0.271, 0.133) )

func _on_button_pressed() -> void:
	button_pressed.emit()

func _on_button_button_up() -> void:
	$textContainer.position.y = 2

func _on_button_button_down() -> void:
	$textContainer.position.y = 4.5

func set_disabled() -> void:
	$ButtonShort.disabled = true
	$ButtonLong.disabled = true
	_on_button_button_down()
	button_label.add_theme_color_override("font_color", Color(0.745, 0.612, 0.413) )


func reenable_button() -> void:
	$ButtonShort.disabled = false
	$ButtonLong.disabled = false
	_on_button_button_up()
	%buttonLabel.add_theme_color_override("font_color", Color(0.306, 0.271, 0.133) )
