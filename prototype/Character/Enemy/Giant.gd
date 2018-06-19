extends "Enemy.gd"

func _ready():
	self.unregister_damaging_group("sword")

func _on_HitSpot_damaged():
	print("GIANT")
	._damage(1)
