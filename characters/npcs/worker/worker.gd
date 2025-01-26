extends CharacterBody2D

@export var desk_marker : Marker2D
@export var fix_marker : Marker2D
@export var item_to_fix : StaticBody2D
@export var idle_time : int
@export var walk_speed : int
@export var character_texture : Texture2D
@export var desk_direction : String
@export var fix_direction : String

@onready var sprite_2d: Sprite2D = $Sprite2D

var fixing_needed : bool = false
var fix_location : Vector2
var desk_location : Vector2

func _ready() -> void:
	sprite_2d.texture = character_texture
	GlobalTrackingValues.item_broken.connect(on_item_broken)
	GlobalTrackingValues.last_chase.connect(on_last_chase)
	if !desk_marker:
		desk_location = sprite_2d.global_position
	else:
		desk_location = desk_marker.global_position
	fix_location = fix_marker.global_position

func _process(delta: float) -> void:
	pass

func on_item_broken(item : StaticBody2D) -> void:
	if item == item_to_fix:
		fixing_needed = true

func on_last_chase() -> void:
	fixing_needed = false
