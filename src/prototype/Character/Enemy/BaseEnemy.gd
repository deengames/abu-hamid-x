extends "../Character.gd"

signal spawn_bullet_pickup(bullet_pickup)

export (int) var damage_to_deal = 1
export (float) var movement_speed = 10

var bullet_pickup_cls = preload('res://prototype/Bullet/BulletPickup.tscn')
var player

onready var spawn_component = preload('res://prototype/components/spawns_distanced_from_entity.gd').new(player)
onready var follows_component = preload('res://prototype/components/follows_entity.gd').new(player, movement_speed)

func init(player_):
	player = player_

func _ready():
	position = spawn_component.get_position()

func _integrate_forces(state):
	follows_component.follow(state, position)

func _process(delta):
	$HealthBar.value = health

func spawn_bullet_pickups():
	var bullet_pickup = bullet_pickup_cls.instance()
	bullet_pickup.init(position.x, position.y)
	emit_signal('spawn_bullet_pickup', bullet_pickup)

func _on_Enemy_body_entered(body):
	if body.is_in_group('enemy_damageable'):
		body.damage_with(self, damage_to_deal)
