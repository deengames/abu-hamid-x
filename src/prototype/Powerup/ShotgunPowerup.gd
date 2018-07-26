extends "Powerup.gd"

var shotgun_node = preload('res://Prototype/Character/Player/Gun/Shotgun.tscn')
onready var magnetrange = $MagnetRange

func _on_ShotgunPowerup_body_entered(body):
	if body == magnetrange.player:
		queue_free()
		body.change_gun(shotgun_node.instance())
