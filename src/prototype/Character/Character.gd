extends RigidBody2D

export (int) var max_health = 10

signal death(entity)
signal damaged(entity, inflictor)

onready var health = max_health

func _free():
	queue_free()

func _death():
	emit_signal('death', self)
	_free()

func damage_with(other, dmg_points):
	health -= dmg_points
	emit_signal('damaged', self, other)
	if health <= 0:
		_death()
