extends "Enemy.gd"

var last_shot_time = 0
var bullet_cls = preload('res://prototype/Bullet/Bullet.tscn')

signal shoot_bullet(bullet)

# constants
var seconds_between_shots = 1
var bullet_velocity = 100 # pixels per second

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	last_shot_time = last_shot_time + delta
	if last_shot_time >= seconds_between_shots:
		last_shot_time -= seconds_between_shots
		_fire_at_player()		
		
func _fire_at_player():
	var angle = global_position.angle_to_point(player.position)
	var vector = Vector2(-bullet_velocity, 0).rotated(position.angle_to_point(player.position))
	var bullet = bullet_cls.instance()
	bullet.init(position.x, position.y, angle)
	emit_signal("shoot_bullet", bullet)
	_death()