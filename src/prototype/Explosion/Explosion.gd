extends Area2D

func explode(radius):
	$CollisionShape2D.shape.radius = radius
	$ColorRect.rect_size = Vector2(radius, radius) * 2
	$ColorRect.rect_position = Vector2(-radius, -radius)
