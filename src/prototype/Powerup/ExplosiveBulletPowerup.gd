extends "Powerup.gd"

var explosive_bullet
onready var magnetrange = $MagnetRange

func _on_body_entered(body):
	if body == magnetrange.player:
		queue_free()
		body.gun.change_bullet(explosive_bullet)
