extends "Enemy.gd"

func _ready():
	self.max_health = 30
	self.health = self.max_health
	self._unregister_damaging_group("sword") # TODO: add hitboxes or parts
	print("Giant reporting.")
