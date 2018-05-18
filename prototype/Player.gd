extends RigidBody2D

export (int) var max_movement_speed = 800
export (int) var acceleration = 2000
export (float) var float_down_speed = 50
export (bool) var allow_jetpack = true


signal spawn_mouse_thing(thing)


var is_using_jetpack = false
var attacking_mouse_pos = null
var following_mouse = false
var mouse_point_thing


func _ready():
	gravity_scale = 2


func _process(delta):
	if Input.is_action_just_pressed('attack'):
		attacking_mouse_pos = get_global_mouse_position()
		mouse_point_thing = preload('res://prototype/MouseGripPoint.tscn').instance()
		mouse_point_thing.position = attacking_mouse_pos
		emit_signal('spawn_mouse_thing', mouse_point_thing)
	if Input.is_action_just_released('attack'):
		attacking_mouse_pos = null
		following_mouse = false
		mouse_point_thing.queue_free()


func _integrate_forces(state):
	var velocity = state.get_linear_velocity()
	
	if Input.is_action_pressed('move_left') and velocity.x > -max_movement_speed:
		velocity.x -= acceleration * state.step
	if Input.is_action_pressed('move_right') and velocity.x < max_movement_speed:
		velocity.x += acceleration * state.step
	if Input.is_action_just_pressed('toggle_jetpack') and allow_jetpack:
		is_using_jetpack = not is_using_jetpack
		gravity_scale = 0 if is_using_jetpack else 2
	
	if is_using_jetpack:
		if Input.is_action_pressed('move_up') and velocity.y > -max_movement_speed:
			velocity.y -= acceleration * state.step
		if Input.is_action_pressed('move_down') and velocity.y < max_movement_speed:
			velocity.y += acceleration * state.step
	
		rotate(velocity.x / max_movement_speed)
	
	$Collision.rotation = rotation
	
	if is_using_jetpack and velocity.abs().length() < 20:
		velocity = Vector2(0, float_down_speed)
	
	velocity = Vector2(lerp(velocity.x, 0, 0.05), lerp(velocity.y, 0, 0.05))
	velocity += state.get_total_gravity() * state.step
	state.set_linear_velocity(velocity)
	
	if Input.is_action_just_released('jump'):
		apply_impulse(Vector2(0, 0), Vector2(0, -200))


func _input(ev):
	if ev is InputEventMouseMotion and attacking_mouse_pos != null:
		if attacking_mouse_pos.distance_to(ev.position) > 50 or following_mouse:
			following_mouse = true
			$Sword.rotation = attacking_mouse_pos.angle_to_point(ev.position) - PI/2
