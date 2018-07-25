extends Node2D

export (int) var clip_size = 6
export (float) var seconds_to_reload = 1.5
export (int) var starting_bullets = 30

export (float) var bullets_per_second = 3.0

signal shoot_bullet(bullet)
signal num_bullet_change(new_clip, new_outside)

onready var bullets_outside_clip = starting_bullets - clip_size
onready var bullets_in_clip = clip_size
onready var reload_timer = $ReloadTimer  # cache for faster use

var seconds_since_last_gunfire = 999
var bullet_cls = preload('res://prototype/Bullet/PlayerBullet.tscn')
var reloading = false

func _ready():
	reload_timer.wait_time = seconds_to_reload

func _process(delta):
	seconds_since_last_gunfire += delta

	if (global.config.enable_gun == true 
		and Input.is_action_pressed('shoot') 
		and seconds_since_last_gunfire > 1/bullets_per_second 
		and not reloading
		and bullets_in_clip > 0):

			bullets_in_clip -= 1
			seconds_since_last_gunfire = 0

			var angle = global_position.angle_to_point(get_global_mouse_position())
			var bullet = bullet_cls.instance()
			bullet.init(get_parent().position.x, get_parent().position.y, angle)
			emit_signal("shoot_bullet", bullet)
			if bullets_in_clip == 0:
				_reload_gun()
		
	if global.config.enable_gun == true and Input.is_action_just_pressed('reload') and not reloading:
		_reload_gun()
	
	emit_signal("num_bullet_change", bullets_in_clip, bullets_outside_clip)

func _reload_gun():
	reloading = true
	reload_timer.start()

func _on_finish_reload():
	var bullets_to_fill_clip = clip_size - bullets_in_clip
	var bullets_to_reload
	
	if bullets_to_fill_clip > bullets_outside_clip:
		bullets_to_reload = bullets_outside_clip
	else:
		bullets_to_reload = bullets_to_fill_clip
	
	bullets_in_clip += bullets_to_reload
	bullets_outside_clip -= bullets_to_reload
	reloading = false

func pickup_bullets(bullets_to_pickup):
	bullets_outside_clip += bullets_to_pickup