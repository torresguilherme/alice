extends Node2D

#stats
var max_hp = 4
var hp = 0
var speed = 250
var cooldown = .05
var last_fired = 0

#directions
var dir_y = 0
var dir_x = 0
var right = 0
var left = 0
var up = 0
var down = 0

# shot types
var pre_shot = preload("res://scenes/player/player_bullet.tscn")

func _ready():
	dir_y = 1
	hp = 4
	set_process(true)
	pass

func _process(delta):
	#######################
	############## MOVEMENT
	#######################
	right = 0
	left = 0
	up = 0
	down = 0
	
	if Input.is_action_pressed("walk_right"):
		dir_y = 0
		dir_x = 1
		right = 1
	if Input.is_action_pressed("walk_left"):
		dir_y = 0
		dir_x = -1
		left = -1
	if Input.is_action_pressed("walk_up"):
		dir_y = -1
		dir_x = 0
		up = -1
	if Input.is_action_pressed("walk_down"):
		dir_y = 1
		dir_x = 0
		down = 1
	
	set_pos(get_pos() + Vector2(1, 0) * speed * delta * (right + left))
	set_pos(get_pos() + Vector2(0, 1) * speed * delta * (up + down))
	
	########################
	############### SHOOTING
	########################
	if last_fired <= 0:
		if Input.is_action_pressed("shoot_up"):
			dir_y = -1
			dir_x = 0
			var shot = pre_shot.instance()
			Shoot(shot)
		if Input.is_action_pressed("shoot_down"):
			dir_y = 1
			dir_x = 0
			var shot = pre_shot.instance()
			Shoot(shot)
		if Input.is_action_pressed("shoot_right"):
			dir_y = 0
			dir_x = 1
			var shot = pre_shot.instance()
			Shoot(shot)
		if Input.is_action_pressed("shoot_left"):
			dir_y = 0
			dir_x = -1
			var shot = pre_shot.instance()
			Shoot(shot)
	
	#updates shot cooldown
	if last_fired > 0:
		last_fired  = last_fired - delta
	

func Shoot(shot):
	shot.set_global_pos(get_global_pos() + Vector2(dir_x, dir_y) * 30)
	get_owner().add_child(shot)
	shot.dir_y = dir_y
	shot.dir_x = dir_x
	last_fired = cooldown
	pass