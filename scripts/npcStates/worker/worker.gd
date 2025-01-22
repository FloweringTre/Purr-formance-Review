extends CharacterBody2D

@export var starting_marker : Marker2D
@export var fix_marker : Marker2D
@export var item_to_fix : StaticBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D

signal time_to_fix
var fixing_needed : bool = false
var fix_location : Vector2
var starting_location : Vector2

func _ready() -> void:
	GlobalTrackingValues.item_broken.connect(on_item_broken)
	if !starting_marker:
		starting_location = sprite_2d.global_position
	else:
		starting_location = starting_marker.global_position
	fix_location = fix_marker.global_position

func _process(delta: float) -> void:
	pass

func on_item_broken(item : StaticBody2D) -> void:
	if item == item_to_fix:
		fixing_needed = true
		time_to_fix.emit()
