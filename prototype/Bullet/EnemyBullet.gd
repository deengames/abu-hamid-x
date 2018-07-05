extends "Bullet.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func init(x, y, angle):
	self.remove_from_group("bullets")
	.init("player", x, y, angle)