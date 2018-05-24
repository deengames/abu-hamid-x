extends "../Character.gd"


export (int) var damage_to_deal = 2
export (float) var movement_speed = 20


var player


func _ready():
	_register_damaging_group('sword')


func set_player(player_):
	player = player_


func _integrate_forces(state):
	var velocity = state.get_linear_velocity()
	
	var gained_velocity = Vector2(-movement_speed, 0).rotated(position.angle_to_point(player.position))
	velocity += gained_velocity
	
	velocity = Vector2(lerp(velocity.x, 0, 0.05), lerp(velocity.y, 0, 0.05))
	velocity += state.get_total_gravity() * state.step
	state.set_linear_velocity(velocity)
