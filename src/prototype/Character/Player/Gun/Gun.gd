extends "BaseGun.gd"

func shoot_towards(angle):
	var bullet = bullet_cls.instance()
	bullet.init(get_parent().position.x, get_parent().position.y, angle)
