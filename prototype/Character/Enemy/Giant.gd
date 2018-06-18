extends "Enemy.gd"

func _ready():
	self.unregister_damaging_group("sword")

func _on_HitSpot_damaged():
	print("HITSPOT DAMAGE")

func _on_HitSpot_body_shape_entered(body_id, body, body_shape, local_shape):
	print("DEBUG")
