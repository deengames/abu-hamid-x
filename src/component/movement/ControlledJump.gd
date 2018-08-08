extends Node

export (float) var jump_velocity = 600


onready var parent = get_parent()


func _physics_process(delta):
	var velocity = parent.velocity
	
	if parent.is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y -= jump_velocity
	
	parent.velocity = velocity

