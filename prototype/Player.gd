extends RigidBody2D

export (int) var movement_speed = 200

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _integrate_forces(state):
	if Input.is_action_pressed('move_up'):
		add_force(Vector2(0, 0), Vector2(0, -movement_speed * state.step))
	if Input.is_action_pressed('move_left'):
		add_force(Vector2(0, 0), Vector2(-movement_speed * state.step, 0))
	if Input.is_action_pressed('move_down'):
		add_force(Vector2(0, 0), Vector2(0, movement_speed * state.step))
	if Input.is_action_pressed('move_right'):
		add_force(Vector2(0, 0), Vector2(movement_speed * state.step, 0))
	
	state.integrate_forces()
