extends Node2D

export (float) var jetpack_speed = 1500


onready var parent = get_parent()

var active = false


func _physics_process(delta):
	var velocity = parent.velocity
	
	if active:
		var target_speed = 0
		if Input.is_action_pressed("move_up"):
			target_speed += -1
		if Input.is_action_pressed("move_down"):
			target_speed +=  1
	
		target_speed *= jetpack_speed
		
		velocity.y = lerp(velocity.y, target_speed, 0.05)
	
	if Input.is_action_just_pressed("jump") and not parent.is_on_floor():
		active = true
	
	if parent.is_on_floor():
		active = false
	
	parent.velocity = velocity
