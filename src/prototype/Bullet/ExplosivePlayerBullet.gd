extends "PlayerBullet.gd"

export (int) var explosion_radius = 30

var explodes = preload('res://prototype/Explosion/Explodes.gd').new(explosion_radius)

func collide(body):
	if body.is_in_group(self.collider_group):
		body._on_body_entered(self)
	get_parent().add_child(explodes.activate())
	queue_free()