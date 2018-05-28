extends "../Character.gd"

export (int) var max_movement_speed = 800
export (int) var acceleration = 2000
export (float) var float_down_speed = 50
export (bool) var allow_jetpack = true

export (int) var max_jetpack_fuel = 500
export (int) var jetpack_consumption_rate = 25
export (int) var jetpack_recharge_rate = 200

export (float) var health_regen_per_second = 0.5


signal fuel_change(new_fuel, max_fuel)
signal health_change(new_hp, max_hp)


var is_using_jetpack = false
var fuel = max_jetpack_fuel
var is_dead = false
onready var sword = preload('res://prototype/Sword.tscn').instance()


func _free():
	$ui/DeathLabel.visible = true
	visible = false
	is_dead = true


func _ready():
	sword.connect('finish_swing', self, '_on_sword_finish_swing')
	_register_damaging_group('enemies')
	var width = ProjectSettings.get_setting('display/window/size/width')
	var height = ProjectSettings.get_setting('display/window/size/height')
	$ui/DeathLabel.rect_position = (Vector2(width, height) - $ui/DeathLabel.rect_size) / 2
	if health_regen_per_second == 0:
		$HealthRegenTimer.autostart = false
	else:
		$HealthRegenTimer.wait_time = 1/health_regen_per_second


func _process(delta):
	if Input.is_action_just_pressed('attack'):
		add_child(sword)
		var starting_angle = get_angle_to(get_global_mouse_position())
		var target_angle = starting_angle + PI
		sword.rotation = starting_angle
		sword.swing_to(target_angle)


func _on_sword_finish_swing():
	remove_child(sword)


func _integrate_forces(state):
	var velocity = state.get_linear_velocity()
	
	if not is_using_jetpack:
		if fuel < max_jetpack_fuel:
			fuel += jetpack_recharge_rate * state.step
	fuel = clamp(fuel, 0, max_jetpack_fuel + 1)
	
	var gained_velocity = acceleration * state.step
	if Input.is_action_pressed('boost'):
		gained_velocity *= 2
	
	if Input.is_action_pressed('move_left') and velocity.x > -max_movement_speed:
		velocity.x -= gained_velocity
	if Input.is_action_pressed('move_right') and velocity.x < max_movement_speed:
		velocity.x += gained_velocity
	if Input.is_action_just_pressed('toggle_jetpack') and allow_jetpack:
		is_using_jetpack = not is_using_jetpack
		gravity_scale = 0 if is_using_jetpack else 2
	
	if is_using_jetpack:
		if Input.is_action_pressed('move_up') and velocity.y > -max_movement_speed:
			velocity.y -= gained_velocity
		if Input.is_action_pressed('move_down') and velocity.y < max_movement_speed:
			velocity.y += gained_velocity
	
		rotate(velocity.x / max_movement_speed)
	
	$Collision.rotation = rotation
	
	var lost_fuel = jetpack_consumption_rate * state.step
	if is_using_jetpack and velocity.abs().length() < 20:
		lost_fuel /= 6
		velocity = Vector2(0, float_down_speed)
	
	velocity = Vector2(lerp(velocity.x, 0, 0.05), lerp(velocity.y, 0, 0.05))
	velocity += state.get_total_gravity() * state.step
	state.set_linear_velocity(velocity)
	
	if Input.is_action_just_released('jump'):
		apply_impulse(Vector2(0, 0), Vector2(0, -600))
	
	if is_using_jetpack and (
		Input.is_action_pressed('move_left') 
		or Input.is_action_pressed('move_right')
		or Input.is_action_pressed('move_up')
		or Input.is_action_pressed('move_down')
		):
		lost_fuel *= 2
		if Input.is_action_pressed('boost'):
			lost_fuel *= 2
	
	fuel -= lost_fuel
	if fuel <= 0:
		is_using_jetpack = false
		gravity_scale = 2
	
	sword.damage_to_deal = sword.damage + velocity.length() / 200
	
	emit_signal('fuel_change', fuel, max_jetpack_fuel)
	emit_signal('health_change', health, max_health)

func _unhandled_key_input(event):
	if is_dead:
		get_tree().change_scene('res://prototype/Main.tscn')


func _on_health_regen():
	if health < max_health:
		health += 1
