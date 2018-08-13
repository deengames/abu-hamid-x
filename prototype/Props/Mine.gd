extends Area2D

var explodes
export (int) var damage = 3


func _ready():
	explodes = preload('res://prototype/Explosion/Explodes.gd').new($ColorRect.rect_size.x * 2, damage)


func _on_Mine_body_entered(body):
	get_parent().add_child(explodes.activate(position))
	queue_free()
