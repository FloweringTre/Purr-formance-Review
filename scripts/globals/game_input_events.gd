class_name GameInputEvents

static var direction: Vector2

#tracks movement [NOT DIAGONAL]
static func movement_input() -> Vector2:
	if Input.is_action_pressed("left"):
		direction = Vector2.LEFT
		#print("LEFT")
	elif Input.is_action_pressed("right"):
		direction = Vector2.RIGHT
		#print("RIGHT")
	elif Input.is_action_pressed("up"):
		direction = Vector2.UP
		#print("UP")
	elif Input.is_action_pressed("down"):
		direction = Vector2.DOWN
		#print("DOWN")
	else:
		direction = Vector2.ZERO
	
	return direction

static func is_sprinting() -> bool:
	if Input.is_action_pressed("sprint"):
		#print("IM SPRNTIN LOLLLL")
		return true
	else:
		return false

static func is_movement_input() -> bool:
	if direction == Vector2.ZERO:
		return false
	else:
		return true

#static func use_tool() -> bool:
	#var use_tool_value: bool = Input.is_action_just_pressed("left_click")
	#
	#return use_tool_value
