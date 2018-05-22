extends RigidBody2D

export (int) var max_movement_speed = 800
export (int) var acceleration = 2000
export (float) var float_down_speed = 50
export (bool) var allow_jetpack = true

export (int) var max_jetpack_fuel = 500
export (int) var jetpack_consumption_rate = 25
export (int) var jetpack_recharge_rate = 200


signal fuel_change(new_fuel, max_fuel)


var is_using_jetpack = false
var fuel = max_jetpack_fuel
onready var sword = preload('res://prototype/Sword.tscn').instance()


func _process(delta):
	if Input.is_action_just_pressed('attack'):
		add_child(sword)
		sword.connect('finish_swing', self, '_on_sword_finish_swing')
		var starting_angle = get_angle_to(get_global_mouse_position())
		var target_angle = starting_angle + PI
		sword.rotation = starting_angle
		sword.swing_to(target_angle)


func _on_sword_finish_swing():
	remove_child(sword)


func _integrate_forces(state):
	var velocity = state.get_linear_velocity()
	
	if not is_using_jetpack:
		if fuel < max_jetpack_fuel:
			fuel += jetpack_recharge_rate * state.step
	fuel = clamp(fuel, 0, max_jetpack_fuel + 1)
	
	var gained_velocity = acceleration * state.step
	if Input.is_action_pressed('boost'):
		gained_velocity *= 2
	
	if Input.is_action_pressed('move_left') and velocity.x > -max_movement_speed:
		velocity.x -= gained_velocity
	if Input.is_action_pressed('move_right') and velocity.x < max_movement_speed:
		velocity.x += gained_velocity
	if Input.is_action_just_pressed('toggle_jetpack') and allow_jetpack:
		is_using_jetpack = not is_using_jetpack
		gravity_scale = 0 if is_using_jetpack else 2
	
	if is_using_jetpack:
		if Input.is_action_pressed('move_up') and velocity.y > -max_movement_speed:
			velocity.y -= gained_velocity
		if Input.is_action_pressed('move_down') and velocity.y < max_movement_speed:
			velocity.y += gained_velocity
	
		rotate(velocity.x / max_movement_speed)
	
	$Collision.rotation = rotation
	
	var lost_fuel = jetpack_consumption_rate * state.step
	if is_using_jetpack and velocity.abs().length() < 20:
		lost_fuel /= 6
		velocity = Vector2(0, float_down_speed)
	
	velocity = Vector2(lerp(velocity.x, 0, 0.05), lerp(velocity.y, 0, 0.05))
	velocity += state.get_total_gravity() * state.step
	state.set_linear_velocity(velocity)
	
	if Input.is_action_just_released('jump'):
		apply_impulse(Vector2(0, 0), Vector2(0, -200))
	
	if is_using_jetpack and (
		Input.is_action_pressed('move_left') 
		or Input.is_action_pressed('move_right')
		or Input.is_action_pressed('move_up')
		or Input.is_action_pressed('move_down')
		):
		lost_fuel *= 2
		if Input.is_action_pressed('boost'):
			lost_fuel *= 4
	
	fuel -= lost_fuel
	if fuel <= 0:
		is_using_jetpack = false
		gravity_scale = 2
	
	emit_signal('fuel_change', fuel, max_jetpack_fuel)
