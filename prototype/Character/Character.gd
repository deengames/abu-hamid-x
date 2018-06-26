extends RigidBody2D

export (int) var max_health = 10
export (bool) var damage_per_second_per_contact = false

signal death(entity)
signal damaged(entity)

# all variables depending on exported stuff need to be marked with
# onready; if it's overridden, it'll keep the superclass's value
onready var health = max_health

onready var damaging_groups = []

# body: seconds_since_last_damage
var damaging_bodies_in_contact = {}

func register_damaging_group(group_name):
	damaging_groups.append(group_name)


func unregister_damaging_group(group_name):
	if group_name in damaging_groups:
		damaging_groups.remove(group_name)


func _free():
	queue_free()

func _death():
	emit_signal('death', self)
	_free()


func _damage(dmg_points):
	health -= dmg_points
	emit_signal('damaged', self)
	if health <= 0:
		_death()


func _process(delta):
	for body in damaging_bodies_in_contact:
		damaging_bodies_in_contact[body] += delta
		if damaging_bodies_in_contact[body] > 1:
			damaging_bodies_in_contact[body] = 0
			_damage(body.damage_to_deal)


func _on_body_entered(body):
	for group_name in damaging_groups:
		if body.is_in_group(group_name):
			if damage_per_second_per_contact:
				# enemies don't need this, hence the if/else
				body.connect('death', self, '_on_damaging_body_death')
				damaging_bodies_in_contact[body] = 9999
			else:
				_damage(body.damage_to_deal)
			if body.has_method('_on_deal_damage'):
				body._on_deal_damage(self)

func _on_damaging_body_death(body):
	damaging_bodies_in_contact.erase(body)

func _on_body_exited(body):
	if body in damaging_bodies_in_contact:
		damaging_bodies_in_contact.erase(body)
