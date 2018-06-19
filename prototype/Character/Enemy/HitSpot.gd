extends "../Character.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var giant = null

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	self.register_damaging_group("sword")
	self.giant = self.get_parent()


func _on_HitSpot_damaged():
	print('internal damage')


func _on_HitSpot_body_entered(body):
	print("Hit by " + str(body))
	print("my groups are " + str(self.damaging_groups))
	._on_body_entered(body)
	self.giant._on_HitSpot_damaged()
