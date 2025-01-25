extends Node

var music_playing : bool = true

var last_reported_kitty_location : Vector2
var kitty_caught_from_sup : bool = false
var kitty_caught_from_kitty : bool = false

signal last_chase
signal game_won
signal game_has_been_won

var game_was_played : bool = false
var game_over : bool = false
var game_paused: bool = false
signal game_resumed

var kitty_in_bed : bool = false
var kitty_can_sleep : bool = false
var bed_location : Vector2

signal kitty_bappin
signal item_broken
signal item_fixed
var active_item_location : Vector2
var trash_spilled : int = 0
var money_spilled : bool
var printer_broken : bool
var sink_broken : bool
var secret_sleep : bool

var message : String
var last_message_sent : bool = false
signal set_message
signal list_active

var score : int = 0

func game_reset() -> void:
	last_reported_kitty_location = Vector2(0, 0)
	kitty_caught_from_kitty = false
	kitty_caught_from_sup = false
	game_over= false
	game_paused= false
	kitty_in_bed = false
	kitty_can_sleep = false
	bed_location = Vector2(0, 0)
	last_message_sent = false
	
	active_item_location = Vector2(0, 0)
	trash_spilled = 0
	money_spilled = false
	printer_broken = false
	secret_sleep = false
	sink_broken = false
	
	score = 0

func send_message(sent_message : String) -> void:
	message = sent_message
	
	if !successful_day() && !last_message_sent:
		if message == "":
			list_active.emit(true)
		else:
			list_active.emit(false)
	elif successful_day() && !last_message_sent:
		last_chase.emit()
		message =  "Get to the bed to end the workday!"
	else:
		pass
	
	set_message.emit()

func successful_day():
	var value = 0
	if trash_spilled != 3:
		value += 1
	if !printer_broken:
		value += 1
	if !sink_broken:
		value += 1
	
	if value == 0:
		return true
	if value > 0:
		return false

func productivity_level():
	var value = 100
	value -= (trash_spilled * 20)
	if printer_broken:
		value -= 20
	if sink_broken:
		value -= 20
	
	return value

func score_calculate(time_left : int):
	var value = 0
	value += (trash_spilled * 20)
	
	if money_spilled:
		value += 20
	if secret_sleep:
		value += 20
	if printer_broken:
		value += 20
	if sink_broken:
		value += 20
	if !kitty_caught_from_kitty && !kitty_caught_from_sup:
		value += 20
	
	value += time_left
	
	return value
