extends "BaseGun.gd"

export (int) var bullets_per_shot = 3
export (float) var spread_in_radians = PI/6

func shoot_towards(angle):
	for i in range(bullets_per_shot):
		var bullet = bullet_cls.instance()
		var angle_with_spread = angle + rand_range(-spread_in_radians, spread_in_radians)
		bullet.init(get_parent().position.x, get_parent().position.y, angle_with_spread)
