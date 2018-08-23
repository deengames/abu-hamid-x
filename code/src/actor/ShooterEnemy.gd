extends RigidBody2D

var velocity = Vector2()
var player

func init(player):
	self.player = player
	$FollowsEntity.init(player)
	$ShootsEntity.init(player)

func _integrate_forces(state):
	var velocity = state.get_linear_velocity()
	var movement_speed = 1
	var gained_velocity = Vector2(-movement_speed, 0).rotated(position.angle_to_point(self.player.position))
	velocity += gained_velocity
	
	velocity = Vector2(lerp(velocity.x, 0, 0.05), lerp(velocity.y, 0, 0.05))
	velocity += state.get_total_gravity() * state.step
	state.set_linear_velocity(velocity)
