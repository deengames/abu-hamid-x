var obj

func _init(obj_):
	obj = obj_

func _integrate_forces(state):
	var velocity = state.get_linear_velocity()
	
	var gained_velocity = obj.acceleration * state.step
	if global.config.enable_boost == true and Input.is_action_pressed('boost'):
		gained_velocity *= 2
	
	if Input.is_action_pressed('move_left') and velocity.x > -obj.max_movement_speed:
		velocity.x -= gained_velocity
	if Input.is_action_pressed('move_right') and velocity.x < obj.max_movement_speed:
		velocity.x += gained_velocity
	
	if obj.jetpack.is_using_jetpack:
		if Input.is_action_pressed('move_up') and velocity.y > -obj.max_movement_speed:
			velocity.y -= gained_velocity
		if Input.is_action_pressed('move_down') and velocity.y < obj.max_movement_speed:
			velocity.y += gained_velocity

		obj.rotate(velocity.x / obj.max_movement_speed)
	
	obj.get_node("Collision").rotation = obj.rotation
	
	velocity = Vector2(lerp(velocity.x, 0, 0.05), lerp(velocity.y, 0, 0.05))
	velocity += state.get_total_gravity() * state.step
	state.set_linear_velocity(velocity)
	