extends Node

export (bool) var allow_jetpack = true
export (int) var max_jetpack_fuel = 500
export (int) var jetpack_consumption_rate = 25
export (int) var jetpack_recharge_rate = 200
export (float) var float_down_speed = 50

var is_using_jetpack = false
onready var fuel = max_jetpack_fuel
var floor_raycast

func _process(delta):
	if Input.is_action_just_pressed('toggle_jetpack') and allow_jetpack:
		_toggle_jetpack()
	
	# fuel processing
	if not is_using_jetpack:
		if fuel < max_jetpack_fuel:
			fuel += jetpack_recharge_rate * delta
	
	fuel = clamp(fuel, 0, max_jetpack_fuel + 1)

	var lost_fuel = jetpack_consumption_rate * delta
	
	if is_using_jetpack and (
		Input.is_action_pressed('move_left') 
		or Input.is_action_pressed('move_right')
		or Input.is_action_pressed('move_up')
		or Input.is_action_pressed('move_down')
		):
		lost_fuel *= 2
		if Input.is_action_pressed('boost'):
			lost_fuel *= 2
	
	fuel -= lost_fuel
	if fuel <= 0:
		_disable_jetpack()

func _integrate_forces(state):
	if global.config.enable_float_down and is_using_jetpack and state.get_linear_velocity().abs().length() < 20:
		state.set_linear_velocity(Vector2(0, float_down_speed))

	if not floor_raycast.is_colliding() and Input.is_action_just_pressed('jump') and allow_jetpack and not is_using_jetpack:
		_enable_jetpack()
	
	if floor_raycast.is_colliding() and Input.is_action_just_pressed('jump') and not is_using_jetpack:
		get_parent().apply_impulse(Vector2(0, 0), Vector2(0, -3000))

func _disable_jetpack():
	is_using_jetpack = false
	get_parent().gravity_scale = 1

func _enable_jetpack():
	is_using_jetpack = true
	get_parent().gravity_scale = 0

func _toggle_jetpack():
	_disable_jetpack() if is_using_jetpack else _enable_jetpack()

func set_floor_raycast(raycast):
	floor_raycast = raycast