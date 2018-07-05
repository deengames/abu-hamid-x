extends "Bullet.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func init(x, y, angle):
	.init("enemies", x, y, angle)


func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
