extends Node

var music_playing : bool = true

var last_reported_kitty_location : Vector2
var kitty_caught_from_sup : bool = false
var kitty_caught_from_kitty : bool = false

signal last_chase
signal ready_last_chase
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
var printer_broken : bool
var sink_broken : bool
var donuts_spilled : int = 0
var money_spilled : bool
var secret_sleep : bool

var message : String
var last_message_sent : bool = false
var message_counter : int = 0
signal set_message
signal list_active

var score : int = 0
var total_score : int = 0
var workday : int = 0

var ratings : Array = [" fishies", " naps", " snuggles", " pets", " treats", " munchies", " sniffs", " feathers", " cuddles", " fuzzies", "catnip"]

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
	message_counter = 0
	
	active_item_location = Vector2(0, 0)
	trash_spilled = 0
	donuts_spilled = 0
	money_spilled = false
	printer_broken = false
	secret_sleep = false
	sink_broken = false
	
	workday = 0
	score = 0
	total_score = 0

func day_reset(day_successful : bool) -> void:
	last_reported_kitty_location = Vector2(0, 0)
	kitty_caught_from_kitty = false
	kitty_caught_from_sup = false
	game_over= false
	game_paused= false
	kitty_in_bed = false
	kitty_can_sleep = false
	bed_location = Vector2(0, 0)
	last_message_sent = false
	message_counter = 0
	
	active_item_location = Vector2(0, 0)
	trash_spilled = 0
	donuts_spilled = 0
	money_spilled = false
	printer_broken = false
	secret_sleep = false
	sink_broken = false
	
	if day_successful:
		workday += 1
		total_score += score
	
	score = 0

func send_message(sent_message : String) -> void:
	message = sent_message
	
	if !successful_day() or message_counter > 1:
		if message == "":
			list_active.emit(true)
		else:
			list_active.emit(false)
	if successful_day() && !last_message_sent:
		ready_last_chase.emit()
		message =  "Escape to the safety of your bed!"
		last_message_sent = true
	if successful_day() && last_message_sent && message_counter < 2:
		message =  "Escape to the safety of your bed!"
		message_counter += 1
	else:
		pass
	
	set_message.emit()

func successful_day():
	var value = 0
	match workday:
		0: #monday
			if trash_spilled != 3:
				value += 1
		1: #tuesday
			if trash_spilled != 3:
				value += 1
			if !printer_broken:
				value += 1
		2: #wednesday
			if trash_spilled != 3:
				value += 1
			if !printer_broken:
				value += 1
			if !sink_broken:
				value += 1
		3: #thursday
			if trash_spilled != 3:
				value += 1
			if !printer_broken:
				value += 1
			if !sink_broken:
				value += 1
			if donuts_spilled != 3:
				value += 1
		4: #friday
			if trash_spilled != 3:
				value += 1
			if !printer_broken:
				value += 1
			if !sink_broken:
				value += 1
			if donuts_spilled != 3:
				value += 1
	
	if value == 0:
		return true
	if value > 0:
		return false

func productivity_level():
	var value = 0
	match workday:
		0: #monday
			value += 1
			value += (trash_spilled * 33)
		1: #tuesday
			value += (trash_spilled * 25)
			if printer_broken:
				value += 25
		2: #wednesday
			value += (trash_spilled * 20)
			if printer_broken:
				value += 20
			if sink_broken:
				value += 20
		3: #thursday
			value += (trash_spilled * 12.5)
			if printer_broken:
				value += 12.5
			if sink_broken:
				value += 12.5
			value += (donuts_spilled * 12.5)
		4: #friday
			value += (trash_spilled * 12.5)
			if printer_broken:
				value += 12.5
			if sink_broken:
				value += 12.5
			value += (donuts_spilled * 12.5)
	
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
	
	var random_rating : int = randi_range(0, 9)
	var return_string : String = str(value + total_score, ratings[random_rating])
	score = value
	
	return return_string
