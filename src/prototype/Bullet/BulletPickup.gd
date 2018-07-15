extends Node2D

export (int) var magnet_range = 150
export (float) var magnet_speed = 800
export (int) var min_bullets_dropped = 1
export (int) var max_bullets_dropped = 5

var player_cls = preload('res://prototype/Character/Player/Player.gd')
var player

# there's no rand_range for integers :/
var bullets_dropped = (randi() % max_bullets_dropped) + min_bullets_dropped

func init(x, y):
	position.x = x
	position.y = y

func _ready():
	$MagnetRange/CollisionShape2D.shape.radius = magnet_range
	for body in $MagnetRange.get_overlapping_bodies():
		_on_MagnetRange_body_entered(body)


func _integrate_forces(state):
	var velocity = state.get_linear_velocity()
	if player != null:
		var gained_velocity = Vector2(-magnet_speed, 0).rotated(position.angle_to_point(player.position))
		velocity += gained_velocity * state.step
	
	velocity = Vector2(lerp(velocity.x, 0, 0.05), lerp(velocity.y, 0, 0.05))
	state.set_linear_velocity(velocity)
	

func _on_MagnetRange_body_entered(body):
	if body is player_cls:
		player = body

func _on_MagnetRange_body_exited(body):
	if body is player_cls:
		player = null


func _on_BulletPickup_body_entered(body):
	if body is player_cls:
		body.pickup_bullets(bullets_dropped)
		queue_free()
