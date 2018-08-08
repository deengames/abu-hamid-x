extends Node2D

export (float) var movement_speed = 1000


onready var parent = get_parent()


func _physics_process(delta):
	var velocity = parent.velocity
	
	var target_speed = 0
	if Input.is_action_pressed("move_left"):
		target_speed += -1
	if Input.is_action_pressed("move_right"):
		target_speed +=  1

	target_speed *= movement_speed
	
	velocity.x = lerp(velocity.x, target_speed, 0.05)
	
	parent.velocity = velocity
