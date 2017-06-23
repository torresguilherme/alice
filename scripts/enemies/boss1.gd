extends Area2D

#stats
var speed = 80
var hp = 1000
var cooldown = .2
var cooldown2 = .05
var cooldown3 = 1
var cooldown4 = 2
var last_shot = 0
var shot_count = 1
var aggro_distance = 500
var shot_speed = [450, 400, 350]
var quad_shot_speed = [450, 400, 350, 300]

#shot type
var pre_shot = preload("res://scenes/enemies/enemy_bullet1.tscn")
var pre_shot2 = preload("res://scenes/enemies/enemy_bullet2.tscn")
var pre_shot3 = preload("res://scenes/enemies/enemy_bullet3.tscn")
var pre_shot4 = preload("res://scenes/enemies/enemy_bullet4.tscn")
var pre_shot5 = preload("res://scenes/enemies/champ_bullet.tscn")


#state
var attacking = false

#attack parameters
var player_position
var shooting_direction
var firepoints = []

#animation
onready var anim = get_node("anim")
onready var hit_anim = get_node("hit_anim")

# audio
onready var audio = get_node("audio")

func _ready():
	add_to_group(global.ENEMY_GROUP)
	firepoints.append(get_node("firepoint_l").get_global_pos())
	firepoints.append(get_node("firepoint_r").get_global_pos())
	set_process(true)
	pass

func _process(delta):
	############ STATE CHANGE
	player_position = get_owner().player_position
	if get_global_pos().distance_to(player_position) <= aggro_distance:
		attacking = true
	else:
		attacking = false
	
	############ ATTACK
	if attacking:
		if last_shot <= 0:
			if 1 <= shot_count && shot_count <= 15:
				# calculates unit vector
				var sum = sqrt(abs(pow((player_position.x - get_global_pos().x), 2) + pow((player_position.y - get_global_pos().y), 2)))
				shooting_direction = Vector2((player_position.x - get_global_pos().x)/sum, (player_position.y - get_global_pos().y)/sum)
				if shot_count % 5 == 0:
					Shoot2(shooting_direction)
					last_shot = cooldown
				else:
					Shoot1(shooting_direction)
					last_shot = cooldown2
				shot_count += 1
			elif 16 <= shot_count && shot_count <= 18:
				var sum = sqrt(abs(pow((player_position.x - get_global_pos().x), 2) + pow((player_position.y - get_global_pos().y), 2)))
				shooting_direction = Vector2((player_position.x - get_global_pos().x)/sum, (player_position.y - get_global_pos().y)/sum)
				Shoot3(shooting_direction)
				last_shot += cooldown3
				shot_count += 1
			else:
				var shooting_directions = []
				var sum = sqrt(abs(pow((player_position.x - firepoints[0].x), 2) + pow((player_position.y - firepoints[0].y), 2)))
				shooting_directions.append(Vector2((player_position.x - firepoints[0].x)/sum, (player_position.y - firepoints[0].y)/sum))
				var sum = sqrt(abs(pow((player_position.x - firepoints[1].x), 2) + pow((player_position.y - firepoints[1].y), 2)))
				shooting_directions.append(Vector2((player_position.x - firepoints[1].x)/sum, (player_position.y - firepoints[1].y)/sum))
				Shoot4(shooting_directions, firepoints)
				if shot_count < 26:
					last_shot = cooldown2
					shot_count += 1
				else:
					last_shot = cooldown4
					shot_count = 1
		else:
			############# RECOVERS FROM COOLDOWN
			last_shot -= delta

 # shoots 3 bullets at the same time, aimed, the ones in the front are faster
func Shoot1(shooting_direction):
	var shots = []
	for i in range(shot_speed.size()):
		shots.append(pre_shot2.instance())
		shots[i].speed = shot_speed[i]
		shots[i].direction = shooting_direction
		shots[i].set_global_pos(get_global_pos())
		get_owner().add_child(shots[i])
	audio.play("enemy_shoot4")
	pass

# same as before with enemy_bullet4
func Shoot2(shooting_direction):
	var shots = []
	for i in range(shot_speed.size()):
		shots.append(pre_shot4.instance())
		shots[i].speed = shot_speed[i]
		shots[i].direction = shooting_direction
		shots[i].set_global_pos(get_global_pos())
		get_owner().add_child(shots[i])
	audio.play("enemy_shoot2")
	pass

# shoots the champion bullet
func Shoot3(shooting_direction):
	#instance shots
	var shot = pre_shot5.instance()
	shot.direction = shooting_direction
	shot.set_global_pos(get_global_pos())
	get_owner().add_child(shot)
	audio.play("enemy_shoot4")
	pass

#hands shoot at player direction
func Shoot4(shooting_directions, firepoints):
	var shots = []
	var counter = 0
	for i in range(shooting_directions.size()):
		for j in range(quad_shot_speed.size()):
			shots.append(pre_shot3.instance())
			shots[counter].direction = shooting_directions[i]
			shots[counter].speed = quad_shot_speed[j]
			shots[counter].set_global_pos(firepoints[i])
			get_owner().add_child(shots[counter])
			counter += 1
		audio.play("enemy_shoot1")
	pass

func TakeDamage(value):
	hit_anim.play("hit")
	hp -= value
	if hp <= 0:
		queue_free()
	audio.play("enemy_damage1")

func DeathSound():
	audio.play("enemy_death1")