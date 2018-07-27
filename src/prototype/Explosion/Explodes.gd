var explosion_radius
var explosion_damage
var explosion_cls = preload("res://prototype/Explosion/Explosion.tscn")

func _init(radius, damage):
	explosion_radius = radius
	explosion_damage = damage

func activate(position):
	var explosion = explosion_cls.instance()
	explosion.explode(position, explosion_radius, explosion_damage)
	return explosion
