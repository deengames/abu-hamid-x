extends Area2D

export (float) var powerups_per_enemy_death = 0.2

var powerups_cls = [
	preload('res://prototype/Powerup/ShotgunPowerup.tscn'),
	preload('res://prototype/Powerup/ExplosiveBulletPowerup.tscn')
]
onready var shape = $CollisionShape2D.shape

func _on_enemy_death(enemy):
	if randf() < powerups_per_enemy_death:
		var x = shape.extents.x
		var y = shape.extents.y
		
		var spawn_location = Vector2(
			rand_range(-x, x),
			rand_range(-y, y)
		)
		
		var powerup_cls = powerups_cls[randi() % powerups_cls.size()]
		var powerup = powerup_cls.instance()
		powerup.init(spawn_location)
		add_child(powerup)