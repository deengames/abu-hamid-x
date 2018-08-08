extends KinematicBody2D

var velocity = Vector2()

func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector2(0, -1))
