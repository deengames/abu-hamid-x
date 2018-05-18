extends RigidBody2D

export (int) var max_movement_speed = 600
export (int) var acceleration = 1000
export (bool) var allow_jetpack = true


var is_using_jetpack = false
var is_left = false


func _process(delta):
	if Input.is_action_pressed('attack_left'):
		$Anim.play('Swing Sword Left')
	elif Input.is_action_pressed('attack_right'):
		$Anim.play('Swing Sword Right')


func _integrate_forces(state):
	var velocity = state.get_linear_velocity()
	
	if Input.is_action_pressed('move_left') and velocity.x > -max_movement_speed:
		if not is_left:
			$Sword.position.x = -$Sword.position.x
			is_left = true
		velocity.x -= acceleration * state.step
	if Input.is_action_pressed('move_right') and velocity.x < max_movement_speed:
		if is_left:
			$Sword.position.x = -$Sword.position.x
			is_left = false
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
	if ev is InputEventMouseMotion:
		$Sword.rotation = position.angle_to_point(ev.position) - PI/2
