extends "../Enemy.gd"

export (int) var explosion_radius = 40
export (int) var explosion_damage = 4

var explodes = preload('res://prototype/Explosion/Explodes.gd').new(explosion_radius, explosion_damage)

func _on_Kamikaze_body_entered(body):
	get_parent().add_child(explodes.activate(position))
	_death()
