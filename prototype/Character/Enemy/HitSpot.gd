extends "../Character.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	print("Registerinmg")
	self.register_damaging_group("sword")
	print("Registered")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_HitSpot_damaged():
	print("DAMAGED")


func _on_HitSpot_body_entered(body):
	print("test")
