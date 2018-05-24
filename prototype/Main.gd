extends Node2D

export (int) var waves_per_game = 10
export (int) var enemies_in_first_wave = 3
export (int) var increment_per_wave = 1


var scenes_to_spawn = [preload("res://prototype/Character/Enemy/Enemy.tscn")]
var wave_num = 0
var num_spawned_entities = 0
onready var timer = $WaveSpawnTimer


func _new_wave():
	var total_enemies = enemies_in_first_wave + increment_per_wave * wave_num
	wave_num += 1
	for i in range(total_enemies):
		var scene = scenes_to_spawn[randi() % len(scenes_to_spawn)]
		var e = scene.instance()
		add_child(e)
		e.connect('death', self, '_on_spawned_entity_death')
		num_spawned_entities += 1


func _on_spawned_entity_death():
	num_spawned_entities -= 1


func _process(delta):
	if num_spawned_entities <= 0 and timer.is_stopped():
		timer.start()
	$ui/WaveLabel.text = "WAVE: " + str(wave_num) + ' / ' + str(waves_per_game)
