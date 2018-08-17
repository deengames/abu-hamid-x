extends KinematicBody2D

var velocity = Vector2()

func init(player):
	$FollowsEntity.init(player)
	$ShootsEntity.init(player)

func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector2(0, -1))
