extends "../BaseEnemy.gd"

func _on_Enemy_death(entity):
	spawn_bullet_pickups()
