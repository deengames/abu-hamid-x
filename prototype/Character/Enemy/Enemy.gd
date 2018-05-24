extends "../Character.gd"


export (int) var damage_to_deal = 2


func _ready():
	_register_damaging_group('sword')
