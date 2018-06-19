extends RigidBody2D

export (int) var max_health = 10

signal death
signal damaged

# all variables depending on exported stuff need to be marked with
# onready; if it's overridden, it'll keep the superclass's value
onready var health = max_health

onready var damaging_groups = []

func register_damaging_group(group_name):
	damaging_groups.append(group_name)


func unregister_damaging_group(group_name):
	if group_name in damaging_groups:
		damaging_groups.remove(group_name)


func _free():
	queue_free()

func _death():
	emit_signal('death')
	_free()


func _damage(dmg_points):
	health -= dmg_points
	emit_signal('damaged')
	if health <= 0:
		_death()


func _on_body_entered(body):
	for group_name in damaging_groups:
		if body.is_in_group(group_name):
			_damage(body.damage_to_deal)
