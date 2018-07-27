extends Area2D

const seconds_to_fade = 1.5
var seconds_since_spawn = 0

func explode(position_, radius, damage):
	position = position_
	$CollisionShape2D.shape.radius = radius
	$ColorRect.rect_size = Vector2(radius, radius) * 2
	$ColorRect.rect_position = Vector2(-radius, -radius)

func _process(delta):
	seconds_since_spawn += delta
	if seconds_since_spawn >= seconds_to_fade:
		queue_free()