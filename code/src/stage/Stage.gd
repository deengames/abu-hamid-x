extends Node2D

func _ready():
	$SpawnsWaves.enemy_scenes = [
		preload('res://src/actor/ShooterEnemy.tscn')
	]
