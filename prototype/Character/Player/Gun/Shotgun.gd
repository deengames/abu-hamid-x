extends "BaseGun.gd"

export (int) var bullets_per_shot = 3
export (float) var spread_in_radians = PI/6

func _ready():
	# we divide by two since we spread from
	# the negative angle till the positive one, summing twice
	# so we divide to maintain correct amount
	spread_in_radians = spread_in_radians / 2

func shoot_towards(angle):
	bullets_in_clip -= 1
	seconds_since_last_gunfire = 0
	for i in range(bullets_per_shot):
		var bullet = bullet_cls.instance()
		var angle_with_spread = angle + rand_range(-spread_in_radians, spread_in_radians)
		bullet.init(get_parent().position.x, get_parent().position.y, angle_with_spread)
		emit_signal("shoot_bullet", bullet)
