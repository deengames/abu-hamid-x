extends "../Character.gd"


export (int) var damage_to_deal = 1
export (float) var movement_speed = 20


onready var player = get_parent().get_node('Player')


func _ready():
	var width = ProjectSettings.get_setting('display/window/size/width')
	var height = ProjectSettings.get_setting('display/window/size/height')
	var new_pos = player.position
	while new_pos.distance_to(player.position) < 300:
		new_pos = Vector2(rand_range(0, width), rand_range(0, height))
	position = new_pos
	_register_damaging_group('sword')


func _integrate_forces(state):
	var velocity = state.get_linear_velocity()
	
	var gained_velocity = Vector2(-movement_speed, 0).rotated(position.angle_to_point(player.position))
	velocity += gained_velocity
	
	velocity = Vector2(lerp(velocity.x, 0, 0.05), lerp(velocity.y, 0, 0.05))
	velocity += state.get_total_gravity() * state.step
	state.set_linear_velocity(velocity)
