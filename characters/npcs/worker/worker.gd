extends CharacterBody2D

@export var desk_marker : Marker2D
@export var is_fixer_worker : bool
@export var fix_marker : Marker2D
@export var item_to_fix : StaticBody2D
@export var desk_direction : String
@export var fix_direction : String
@export var character_texture : Texture2D

@onready var sprite_2d: Sprite2D = $Sprite2D

var fixing_needed : bool = false
var has_fixed_before : bool = false
var fix_location : Vector2
var desk_location : Vector2
var idle_time : int
var walk_speed : int
var worker_name 
var walking_position_index : int = 1500
var stuck : bool = false

func _ready() -> void:
	sprite_2d.texture = character_texture
	GlobalTrackingValues.item_broken.connect(on_item_broken)
	GlobalTrackingValues.last_chase.connect(on_last_chase)
	if !desk_marker:
		desk_location = sprite_2d.global_position
	else:
		desk_location = desk_marker.global_position
	fix_location = fix_marker.global_position
	worker_name = $".".name
	
	setup_worker()
	#print("idle time: ", idle_time)
	#print("walk speed: ", walk_speed)

func _process(delta: float) -> void:
	pass

func on_item_broken(item : StaticBody2D) -> void:
	if item == item_to_fix:
		fixing_needed = true

func on_last_chase() -> void:
	fixing_needed = false

func setup_worker() -> void:
	match GlobalTrackingValues.difficulty_level:
		0: # easy
			if is_fixer_worker:
				idle_time = randi_range(25, 45)
			else:
				idle_time = randi_range(40, 50)
			walk_speed = randi_range(15, 20)
		1: #medium
			if is_fixer_worker:
				idle_time = randi_range(10, 30)
			else:
				idle_time = randi_range(30, 50)
			walk_speed = randi_range(15, 25)
		2: #hard
			if is_fixer_worker:
				idle_time = randi_range(15, 25)
			else:
				idle_time = randi_range(30, 40)
			walk_speed = randi_range(15, 30)
		3: #impossible
			if is_fixer_worker:
				idle_time = randi_range(10, 15)
			else:
				idle_time = randi_range(20, 30)
			walk_speed = randi_range(20, 30)
