extends "../Enemy.gd"

export (int) var min_bullet_pickups = 1
export (int) var max_bullet_pickups = 3


var bullet_pickups = (randi() % max_bullet_pickups) + min_bullet_pickups


func _on_HitSpot_body_entered(body):
	_on_body_entered(body)


func _on_Giant_death(entity):
	for i in range(bullet_pickups):
		_on_Enemy_death(entity)
