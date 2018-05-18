extends RigidBody2D

export (int) var max_movement_speed = 600
export (int) var acceleration = 1000
export (bool) var allow_jetpack = true


var is_using_jetpack = false
var attacking_mouse_pos = null
var following_mouse = false


func _process(delta):
	if Input.is_action_just_pressed('attack'):
		attacking_mouse_pos = get_global_mouse_position()
	if Input.is_action_just_released('attack'):
		attacking_mouse_pos = null
		following_mouse = false


func _integrate_forces(state):
	var velocity = state.get_linear_velocity()
	
	if Input.is_action_pressed('move_left') and velocity.x > -max_movement_speed:
		velocity.x -= acceleration * state.step
	if Input.is_action_pressed('move_right') and velocity.x < max_movement_speed:
		velocity.x += acceleration * state.step
	if Input.is_action_just_pressed('toggle_jetpack') and allow_jetpack:
		is_using_jetpack = not is_using_jetpack
	
	if is_using_jetpack:
		if Input.is_action_pressed('move_up') and velocity.y > -max_movement_speed:
			velocity.y -= acceleration * state.step
		if Input.is_action_pressed('move_down') and velocity.y < max_movement_speed:
			velocity.y += acceleration * state.step
	
		rotate(velocity.x / max_movement_speed)
	
	$Collision.rotation = rotation
	
	velocity += state.get_total_gravity() * state.step
	state.set_linear_velocity(velocity)
	
	if Input.is_action_just_released('jump'):
		apply_impulse(Vector2(0, 0), Vector2(0, -200))


func _input(ev):
	if ev is InputEventMouseMotion and attacking_mouse_pos != null:
		if attacking_mouse_pos.distance_to(ev.position) > 50 or following_mouse:
			following_mouse = true
			$Sword.rotation = attacking_mouse_pos.angle_to_point(ev.position) - PI/2
