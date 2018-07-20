var entity
var movement_speed

func _init(entity_to_follow, speed):
	entity = entity_to_follow
	movement_speed = speed

func follow(state, current_position):
	var velocity = state.get_linear_velocity()
	
	var gained_velocity = Vector2(-movement_speed, 0).rotated(current_position.angle_to_point(entity.position))
	velocity += gained_velocity
	
	velocity = Vector2(lerp(velocity.x, 0, 0.05), lerp(velocity.y, 0, 0.05))
	velocity += state.get_total_gravity() * state.step
	state.set_linear_velocity(velocity)