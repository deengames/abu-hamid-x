extends Area2D

export (float) var seconds_per_eruption = 3

var eruption_cls = preload('res://prototype/Props/EruptingLava.tscn')
var seconds_since_last_eruption = 999
onready var shape = $CollisionShape2D.shape

func _process(delta):
	seconds_since_last_eruption += delta
	
	if seconds_since_last_eruption > seconds_per_eruption:
		seconds_since_last_eruption = 0
		
		var eruption = eruption_cls.instance()
		eruption.connect('relocate', self, '_relocate')
		_relocate(eruption)
		add_child(eruption)

func _relocate(eruption):
	var x = shape.extents.x
	var y = shape.extents.y
	
	var spawn_location = Vector2(
		rand_range(-x, x),
		rand_range(-y, y)
	)
	
	eruption.init(spawn_location)