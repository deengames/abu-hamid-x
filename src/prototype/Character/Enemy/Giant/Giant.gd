extends "../Enemy.gd"

export (int) var min_bullet_pickups = 1
export (int) var max_bullet_pickups = 3

export (int) var min_hitspots = 1
export (int) var max_hitspots = 3


var hitspot_cls = preload('res://prototype/Character/Enemy/Giant/HitSpot.tscn')

onready var bullet_pickups = (randi() % max_bullet_pickups) + min_bullet_pickups
onready var colorrect = $ColorBox


func _ready():
	randomize()
	var num_hitspots = (randi() % max_hitspots) + min_hitspots
	for i in num_hitspots:
		var hitspot = hitspot_cls.instance()
		place_hitspot_on_border(hitspot)
		hitspot.connect('body_entered', self, '_on_hitspot_body_entered')
		add_child(hitspot)


func place_hitspot_on_border(hitspot):
	var x
	var y
	var rect = hitspot.get_node('ColorRect')
	
	if randi() % 2 == 0: # left
		x = colorrect.rect_position.x
	else: # right
		x = -colorrect.rect_position.x - rect.rect_min_size.x
	
	y = rand_range(-colorrect.rect_position.y, colorrect.rect_position.y - rect.rect_min_size.y)
	
	hitspot.position = Vector2(x, y)


func _on_body_entered(body):
	# this has to be overridden to fool 
	# character's connection to this signal
	pass


func _on_hitspot_body_entered(body):
	._on_body_entered(body)


func _on_Giant_death(entity):
	for i in range(bullet_pickups):
		_on_Enemy_death(entity)
