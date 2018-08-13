extends Area2D

signal hitspot_collision(other)

func _on_body_entered(body):
	emit_signal('hitspot_collision', body)
