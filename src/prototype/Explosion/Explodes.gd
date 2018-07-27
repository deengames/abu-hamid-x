var explosion_radius 
var explosion_cls = preload("res://prototype/Explosion/Explosion.tscn")

func _init(radius):
	explosion_radius = radius

func activate():
	var explosion = explosion_cls.instance()
	explosion.init(explosion_radius)
	return explosion
