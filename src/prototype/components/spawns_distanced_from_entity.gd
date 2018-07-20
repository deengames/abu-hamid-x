var _entity
var _distance

func _init(entity, distance=300):
	_entity = entity
	_distance = distance

func get_position():
	var width = ProjectSettings.get_setting('display/window/size/width')
	var height = ProjectSettings.get_setting('display/window/size/height')
	var new_pos = _entity.position
	while new_pos.distance_to(_entity.position) < _distance:
		new_pos = Vector2(rand_range(0, width), rand_range(0, height))
	return new_pos
