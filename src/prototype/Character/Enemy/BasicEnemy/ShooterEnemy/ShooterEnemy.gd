extends "../BasicEnemy.gd"

var last_shot_time = 0
var bullet_cls = preload('res://prototype/Bullet/EnemyBullet.tscn')

signal shoot_bullet(bullet)

# constants
export (int) var min_seconds_between_shots = 0.8
export (float) var max_seconds_between_shots = 1.2
export (int) var bullet_velocity = 100 # pixels per second

onready var seconds_between_shots = rand_range(min_seconds_between_shots, max_seconds_between_shots)

func _process(delta):
	last_shot_time = last_shot_time + delta
	if last_shot_time >= seconds_between_shots:
		last_shot_time -= seconds_between_shots
		_fire_at_player()

func _fire_at_player():
	var angle = position.angle_to_point(player.position)
	var bullet = bullet_cls.instance()
	bullet.init(position.x, position.y, angle)
	emit_signal("shoot_bullet", bullet)