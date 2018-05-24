extends RigidBody2D

export (int) var max_health = 10

# all variables depending on exported stuff need to be marked with
# onready; if it's overridden, it'll keep the superclass's value
onready var health = max_health
var damaging_groups = []

func _register_damaging_group(group_name):
	damaging_groups.append(group_name)


func _unregister_damaging_group(group_name):
	if group_name in damaging_groups:
		damaging_groups.remove(group_name)


func _death():
	queue_free()


func _damage(dmg_points):
	health -= dmg_points
	if health <= 0:
		_death()


func _on_body_entered(body):
	for group_name in damaging_groups:
		if body.is_in_group(group_name):
			_damage(body.damage_to_deal)
