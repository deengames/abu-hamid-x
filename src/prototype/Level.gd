extends Node2D

export (int) var waves_per_game = 10
export (int) var points_in_first_wave = 1
export (int) var increment_per_wave = 2

var wave_num = 0
var carry_over_points = 0
var num_spawned_entities = 0
onready var timer = $WaveSpawnTimer

onready var powerup_spawn = $PowerupSpawn
onready var player = $Player


func _new_wave():
	var enemies_to_spawn = global.current_spawns
	var special_spawns = global.special_spawns
	var x = {}
	wave_num += 1
	
	if wave_num > global.FINAL_WAVE_NUMBER:
		$ui/WinButton.visible = true
	else:
		var points_this_wave = points_in_first_wave + (increment_per_wave * wave_num) + carry_over_points
		carry_over_points = 0
		while points_this_wave > 0:
			var random_enemy = enemies_to_spawn.keys()[randi() % len(enemies_to_spawn)]
			var price = enemies_to_spawn[random_enemy]
			if price <= points_this_wave:
				points_this_wave -= price
				_add_entity(random_enemy)
			else:  # exit if there isn't at least one affordable entity
				var lowest_price = INF
				for p in enemies_to_spawn.values():
					if p < lowest_price:
						lowest_price = p
				if points_this_wave < lowest_price:
					carry_over_points = points_this_wave
					break
		if special_spawns.has(wave_num):
			var special_enemy = special_spawns[wave_num]
			_add_entity(special_enemy)


func _add_entity(enemy_cls):
	var e = enemy_cls.instance()
	e.init(player)
	add_child(e)
	e.connect('death', self, '_on_spawned_entity_death')
	e.connect('death', powerup_spawn, '_on_enemy_death')
	e.connect('shoot_bullet', self, '_on_Player_shoot_bullet')
	e.connect('spawn_bullet_pickup', self, '_on_spawn_bullet_pickup')
	num_spawned_entities += 1

func _on_spawned_entity_death(entity):
	num_spawned_entities -= 1


func _process(delta):
	if num_spawned_entities <= 0 and timer.is_stopped():
		timer.start()
	$ui/WaveLabel.text = "WAVE: " + str(wave_num) + ' / ' + str(waves_per_game)


func _on_Player_shoot_bullet(bullet):
	add_child(bullet)

func _on_spawn_bullet_pickup(bullet_pickup):
	add_child(bullet_pickup)


func _on_Button_pressed():
	get_tree().change_scene('res://prototype/ScenarioSelect.tscn')
