extends "../Enemy.gd"

func _ready():
	self._unregister_damaging_group("sword") # TODO: add hitboxes or parts
	print("Giant reporting.")
