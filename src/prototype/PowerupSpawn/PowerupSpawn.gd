extends Area2D

export (int) var seconds_per_powerup = 12

var powerup_cls
onready var shape = $CollisionShape2D.shape

var seconds_since_powerup_spawn = 999

func _process(delta):
	seconds_since_powerup_spawn += delta
	var x = shape.extents.x
	var y = shape.extents.y
	
	var spawn_location = Vector2(
		rand_range(-x, x),
		rand_range(-y, y)
	)
	
	var powerup = powerup_cls.instance()
	powerup.init(spawn_location)
	add_child(powerup)
