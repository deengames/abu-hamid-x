extends "PlayerBullet.gd"

export (int) var explosion_radius = 30
export (int) var explosion_damage = 2

var explodes = preload('res://prototype/Explosion/Explodes.gd').new(explosion_radius, explosion_damage)

func collide(body):
	if body.is_in_group(self.collider_group):
		body._on_body_entered(self)
	get_parent().add_child(explodes.activate(position))
	queue_free()