extends Area2D

var speed = 300
var damage = 1
var bullet_range = 1500
var direction = Vector2(0, 0)

# movement variables
var rot = 0
var rot_dir = 5

#shooting
var shot_speed = 400
var cooldown = .3
var last_shot = 0
var pre_shot = preload("res://scenes/enemies/enemy_bullet1.tscn")

func _ready():
	add_to_group(global.ENEMY_BULLET_GROUP)
	set_process(true)
	pass

func _process(delta):
	############ MOVEMENT
	set_pos(get_pos() + direction * speed * delta)
	rotate(rot * delta)
	rot += rot_dir
	if rot >= 90:
		rot_dir = -5
	elif rot <= -90:
		rot_dir = 5
	
	############ SHOOTING
	if last_shot <= 0:
		var positions = []
		GetPositions(positions)
		print(positions[0])
		Shoot(positions)
		last_shot = cooldown
	else:
		last_shot -= delta
	
	############ FREE MEMORY
	if(get_pos().x >= bullet_range || get_pos().x <= -bullet_range || get_pos().y >= bullet_range || get_pos().y <= -bullet_range):
		queue_free()

func GetPositions(positions):
	positions.append(get_node("firepoint1").get_global_pos())
	positions.append(get_node("firepoint2").get_global_pos())
	positions.append(get_node("firepoint3").get_global_pos())
	positions.append(get_node("firepoint4").get_global_pos())
	positions.append(get_node("firepoint5").get_global_pos())
	positions.append(get_node("firepoint6").get_global_pos())
	positions.append(get_node("firepoint7").get_global_pos())
	positions.append(get_node("firepoint8").get_global_pos())

func Shoot(positions):
	var shots = []
	for i in range(positions.size()):
		shots[i] = pre_shot.instance()
		shots[i].speed = shot_speed
		shots[i].direction = Vector2(positions[i].x/30, positions[i].y/30)
		shots[i].set_global_pos(positions[i])
		get_owner().add_child(shots[i])
	pass

func _on_enemy_bullet1_area_enter( area ):
	if area.is_in_group(global.PLAYER_GROUP):
		area.TakeDamage(damage)
		queue_free()
	pass