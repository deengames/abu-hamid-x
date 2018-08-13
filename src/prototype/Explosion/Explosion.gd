extends Area2D

const seconds_to_fade = 0.5
var seconds_since_spawn = 0
var damage_to_deal

func explode(position_, radius, damage):
	position = position_
	$CollisionShape2D.shape.radius = radius
	$ColorRect.rect_size = Vector2(radius, radius) * 2
	$ColorRect.rect_position = Vector2(-radius, -radius)
	damage_to_deal = damage

func _process(delta):
	seconds_since_spawn += delta
	if seconds_since_spawn >= seconds_to_fade:
		queue_free()

func _on_Explosion_body_entered(body):
	if body.has_method('_damage'):
		body._damage(damage_to_deal)
