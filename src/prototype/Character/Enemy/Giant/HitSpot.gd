extends Area2D

signal damaged(other, damage_points)

func damage_with(other, damage_points):
	emit_signal('damaged', other, damage_points)
