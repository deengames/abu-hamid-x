extends "../Character.gd"


signal spawn_bullet_pickup(bullet_pickup)


export (int) var damage_to_deal = 1
export (float) var movement_speed = 10

export (float) var jump_force = 1500

var bullet_pickup_cls = preload('res://prototype/Bullet/BulletPickup.tscn')
var player

var old_position = Vector2(0, 0)

onready var floor_raycast = $FloorRaycast

func init(player_):
	player = player_

func _ready():
	var width = ProjectSettings.get_setting('display/window/size/width')
	var height = ProjectSettings.get_setting('display/window/size/height')
	var new_pos = player.position
	while new_pos.distance_to(player.position) < 300:
		new_pos = Vector2(rand_range(0, width), rand_range(0, height))
	position = new_pos
	register_damaging_group('sword')
	register_damaging_group('playerbullet')
	register_damaging_group('explosion')


func _process(delta):
	$HealthBar.value = health

	if position.ceil() == old_position.ceil() and floor_raycast.is_colliding():
		apply_impulse(Vector2(0, 0), Vector2(0, -jump_force))
	old_position = position


func _integrate_forces(state):
	var velocity = state.get_linear_velocity()
	
	var gained_velocity = Vector2(-movement_speed, 0).rotated(position.angle_to_point(player.position))
	velocity += gained_velocity
	
	velocity = Vector2(lerp(velocity.x, 0, 0.05), lerp(velocity.y, 0, 0.05))
	velocity += state.get_total_gravity() * state.step
	state.set_linear_velocity(velocity)


func _on_Enemy_death(entity):
	var bullet_pickup = bullet_pickup_cls.instance()
	bullet_pickup.init(position.x, position.y)
	emit_signal('spawn_bullet_pickup', bullet_pickup)
