extends KinematicBody2D

signal finish_swing

var target_angle
var step

func swing_to(angle):
	target_angle = angle
	step = PI / 5

func _physics_process(delta):
	if rotation < target_angle:
		rotation += step
	else:
		emit_signal('finish_swing')