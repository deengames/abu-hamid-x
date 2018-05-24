extends RigidBody2D

export (int) var max_health = 10

# all variables depending on exported stuff need to be marked with
# onready; if it's overridden, it'll keep the superclass's value
onready var health = max_health


func _death():
	queue_free()


func _damage(dmg_points):
	health -= dmg_points
	if health <= 0:
		_death()
