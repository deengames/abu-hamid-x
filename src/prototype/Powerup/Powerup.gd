extends RigidBody2D

# ABSTRACT CLASS -- DO NOT INSTANTIATE

onready var magnet = $MagnetRange

func init(spawn_location):
	position = spawn_location

func _integrate_forces(state):
	var velocity = state.get_linear_velocity()
	if magnet.player != null:
		var gained_velocity = Vector2(-magnet.magnet_speed, 0).rotated(position.angle_to_point(magnet.player.position))
		velocity += gained_velocity * state.step
	
	velocity = Vector2(lerp(velocity.x, 0, 0.05), lerp(velocity.y, 0, 0.05))
	state.set_linear_velocity(velocity)