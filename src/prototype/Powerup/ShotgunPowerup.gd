extends "Powerup.gd"

var shotgun_node
onready var magnetrange = $MagnetRange

func _on_ShotgunPowerup_body_entered(body):
	if body == magnetrange.player:
		queue_free()
		body.change_gun(shotgun_node)
