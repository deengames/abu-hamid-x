extends Area2D

export (float) var magnet_speed = 3000

var player_cls = preload('res://prototype/Character/Player/Player.gd')
var player


func _on_MagnetRange_body_entered(body):
	if body is player_cls:
		player = body


func _on_MagnetRange_body_exited(body):
	if body is player_cls:
		player = null
