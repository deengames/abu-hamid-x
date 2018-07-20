extends Node2D

export (int) var waves_per_game = 10
export (int) var points_in_first_wave = 1
export (int) var increment_per_wave = 2

var enemies_to_spawn = {
	preload("res://prototype/Character/Enemy/Enemy.tscn"): 1,
	preload("res://prototype/Character/Enemy/ShooterEnemy.tscn"): 3
}

var giant_cls = preload("res://prototype/Character/Enemy/Giant/Giant.tscn")
var giant_cost = 5
var spawned_giant = false

var wave_num = 0
var num_spawned_entities = 0
var carry_over_points = 0
onready var timer = $WaveSpawnTimer


func _new_wave():
	spawned_giant = false
	wave_num += 1
	var points_this_wave = points_in_first_wave + (increment_per_wave * wave_num) + carry_over_points
	carry_over_points = 0
	while points_this_wave > 0:
		if wave_num % 3 == 0 and points_this_wave > giant_cost and not spawned_giant:
			points_this_wave -= giant_cost
			_add_entity(giant_cls)
			spawned_giant = true
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


func _add_entity(enemy_cls):
	var e = enemy_cls.instance()
	add_child(e)
	e.connect('death', self, '_on_spawned_entity_death')
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
