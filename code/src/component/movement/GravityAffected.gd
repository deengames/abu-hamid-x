extends Node2D

export (float) var mass = 1

var default_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var default_gravity_vector = ProjectSettings.get_setting("physics/2d/default_gravity_vector")

onready var gravity_vec  = default_gravity_vector * default_gravity * mass
onready var parent = get_parent()


func _physics_process(delta):
	var velocity = parent.velocity
	
	velocity += gravity_vec * delta
	
	parent.velocity = velocity
