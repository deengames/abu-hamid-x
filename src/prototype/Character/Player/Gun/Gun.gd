extends "BaseGun.gd"

func shoot_towards(angle):
	bullets_in_clip -= 1
	seconds_since_last_gunfire = 0
	var bullet = bullet_cls.instance()
	bullet.init(get_parent().position.x, get_parent().position.y, angle)
	emit_signal("shoot_bullet", bullet)
