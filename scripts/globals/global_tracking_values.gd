extends Node

var last_reported_kitty_location : Vector2
var kitty_caught : bool = false

signal last_chase
signal game_won
signal game_has_been_won

var game_was_played : bool = false
var game_over : bool = false
var game_paused: bool = false
signal game_resumed

var kitty_in_bed : bool = false
var bed_location : Vector2

signal kitty_bappin
var active_item_location : Vector2
var trash_spilled : int = 0
var money_spilled : bool
var printer_broken : bool

var message : String
signal set_message
signal list_active

func game_reset() -> void:
	last_reported_kitty_location = Vector2(0, 0)
	kitty_caught= false
	game_over= false
	game_paused= false
	kitty_in_bed = false
	bed_location = Vector2(0, 0)
	
	active_item_location = Vector2(0, 0)
	trash_spilled = 0
	money_spilled = false
	printer_broken = false

func send_message(sent_message : String) -> void:
	message = sent_message
	set_message.emit()
	if message == "":
		list_active.emit(true)
	else:
		list_active.emit(false)

func successful_day():
	var value = 0
	if trash_spilled != 3:
		value += 1
	if !money_spilled:
		value += 1
	if !printer_broken:
		value += 1
	
	if value == 0:
		return true
	if value > 0:
		return false
