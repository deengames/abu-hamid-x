extends RigidBody2D

export (int) var max_movement_speed = 800
export (int) var acceleration = 2000
export (float) var float_down_speed = 50
export (bool) var allow_jetpack = true


var is_using_jetpack = false
var attacking = false
var mouse_point_thing
onready var orig_sword_rotation = $Sword.rotation


func _process(delta):
	if Input.is_action_just_pressed('attack'):
		attacking = true
	if Input.is_action_just_released('attack'):
		attacking = false
		$Sword.rotation = orig_sword_rotation


func _integrate_forces(state):
	var velocity = state.get_linear_velocity()
	
	if Input.is_action_pressed('move_left') and velocity.x > -max_movement_speed:
		velocity.x -= acceleration * state.step
	if Input.is_action_pressed('move_right') and velocity.x < max_movement_speed:
		velocity.x += acceleration * state.step
	if Input.is_action_just_pressed('toggle_jetpack') and allow_jetpack:
		is_using_jetpack = not is_using_jetpack
		gravity_scale = 0 if is_using_jetpack else 2
	
	if is_using_jetpack:
		if Input.is_action_pressed('move_up') and velocity.y > -max_movement_speed:
			velocity.y -= acceleration * state.step
		if Input.is_action_pressed('move_down') and velocity.y < max_movement_speed:
			velocity.y += acceleration * state.step
	
		rotate(velocity.x / max_movement_speed)
	
	$Collision.rotation = rotation
	
	if is_using_jetpack and velocity.abs().length() < 20:
		velocity = Vector2(0, float_down_speed)
	
	velocity = Vector2(lerp(velocity.x, 0, 0.05), lerp(velocity.y, 0, 0.05))
	velocity += state.get_total_gravity() * state.step
	state.set_linear_velocity(velocity)
	
	if Input.is_action_just_released('jump'):
		apply_impulse(Vector2(0, 0), Vector2(0, -200))


func _input(ev):
	if ev is InputEventMouseMotion and attacking:
		$Sword.rotation = global_position.angle_to_point(get_global_mouse_position()) - PI/2
