extends Area2D

var speed = 70
var damage = 1
var bullet_range = 1500
var direction = Vector2(0, 0)
var hp = 10

# rotation variables
var rot = 90
var rot_dir = 1
var rot_max = 90

#shooting
var shot_speed = 200
var cooldown = .2
var last_shot = 0
var pre_shot = preload("res://scenes/enemies/enemy_bullet1.tscn")

# marked shooting positions
var local_positions = []

func _ready():
	add_to_group(global.ENEMY_BULLET_GROUP)
	add_to_group(global.ENEMY_GROUP)
	local_positions.append(get_node("firepoint1").get_pos())
	local_positions.append(get_node("firepoint2").get_pos())
	local_positions.append(get_node("firepoint3").get_pos())
	local_positions.append(get_node("firepoint4").get_pos())
	local_positions.append(get_node("firepoint5").get_pos())
	local_positions.append(get_node("firepoint6").get_pos())
	local_positions.append(get_node("firepoint7").get_pos())
	local_positions.append(get_node("firepoint8").get_pos())
	set_process(true)
	pass

func _process(delta):
	############ MOVEMENT
	set_pos(get_pos() + direction * speed * delta)
	rotate(rot * delta)
	rot += rot_dir
	if rot >= rot_max:
		rot_dir = -rot_dir
	elif rot <= -rot_max:
		rot_dir = rot_dir
	
	############ SHOOTING
	if last_shot <= 0:
		var positions = []
		GetPositions(positions, local_positions)
		Shoot(positions, local_positions)
		last_shot = cooldown
	else:
		last_shot -= delta
	
	############ FREE MEMORY
	if(get_pos().x >= bullet_range || get_pos().x <= -bullet_range || get_pos().y >= bullet_range || get_pos().y <= -bullet_range):
		queue_free()

func GetPositions(positions, local_positions):
	positions.append(get_node("firepoint1").get_global_pos())
	positions.append(get_node("firepoint2").get_global_pos())
	positions.append(get_node("firepoint3").get_global_pos())
	positions.append(get_node("firepoint4").get_global_pos())
	positions.append(get_node("firepoint5").get_global_pos())
	positions.append(get_node("firepoint6").get_global_pos())
	positions.append(get_node("firepoint7").get_global_pos())
	positions.append(get_node("firepoint8").get_global_pos())
	pass

func Shoot(positions, local_positions):
	var shots = []
	for i in range(positions.size()):
		shots.append(pre_shot.instance())
		shots[i].speed = shot_speed
		shots[i].direction = Vector2(local_positions[i].x/30, local_positions[i].y/30)
		shots[i].set_global_pos(positions[i])
		get_node("../").add_child(shots[i])
	pass

func TakeDamage(value):
	hp -= value
	if hp <= 0:
		queue_free()

func _on_champ_bullet_area_enter( area ):
	if area.is_in_group(global.PLAYER_GROUP):
		area.TakeDamage(damage)
		queue_free()
	elif area.is_in_group(global.WALL_GROUP):
		queue_free()
	pass
