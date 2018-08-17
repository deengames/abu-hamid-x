extends Node2D

export (int) var enemies_per_wave = 3
var enemy_scenes = []

var num_spawned_entities = 0

onready var parent = get_parent()
onready var player = parent.get_node('Player')


func _process(delta):
	if num_spawned_entities <= 0:
		_new_wave()

func _new_wave():
	for i in range(enemies_per_wave):
		var random_enemy = enemy_scenes[randi() % len(enemy_scenes)]
		_add_entity(random_enemy)

func _add_entity(enemy_cls):
	var e = enemy_cls.instance()
	e.init(player)
	parent.add_child(e)
	num_spawned_entities += 1
