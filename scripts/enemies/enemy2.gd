extends Area2D

#stats
var speed = 80
var hp = 80
var cooldown = .5
var cooldown2 = 1
var last_shot = 0
var shot_count = 1
var aggro_distance = 400
var shot_speed = [350, 300, 250]

#shot type
var pre_shot = preload("res://scenes/enemies/enemy_bullet2.tscn")
var pre_shot2 = preload("res://scenes/enemies/enemy_bullet3.tscn")

#state
var attacking = false

#attack parameters
var player_position
var player_hitbox_position
var shooting_direction

# animation
onready var anim = get_node("anim")
onready var hit_anim = get_node("hit_anim")

# audio
onready var audio = get_node("audio")

func _ready():
	add_to_group(global.ENEMY_GROUP)
	set_process(true)
	pass

func _process(delta):
	############ STATE CHANGE
	player_position = get_owner().player_position
	player_hitbox_position = get_owner().player_hitbox_position
	if get_global_pos().distance_to(player_hitbox_position) <= aggro_distance:
		var vision = get_world_2d().get_direct_space_state().intersect_ray(get_global_pos(), player_hitbox_position, [self])
		if !vision.values().empty():
			if vision.values()[1].is_in_group(global.PLAYER_GROUP):
				attacking = true
			else:
				attacking = false
		else:
			attacking = false
	else:
		attacking = false
	
	############ ATTACK
	if attacking:
		if last_shot <= 0:
			# calculates unit vector
			var sum = sqrt(abs(pow((player_position.x - get_global_pos().x), 2) + pow((player_position.y - get_global_pos().y), 2)))
			shooting_direction = Vector2((player_position.x - get_global_pos().x)/sum, (player_position.y - get_global_pos().y)/sum)
			
			# shoots
			if shot_count == 1 || shot_count == 2:
				Shoot1(shooting_direction)
				shot_count += 1
				last_shot = cooldown
			elif shot_count == 3:
				Shoot2(shooting_direction)
				shot_count = 1
				last_shot = cooldown2
		else:
			############# RECOVERS FROM COOLDOWN
			last_shot -= delta

func Shoot1(shooting_direction):
	var shot = pre_shot.instance()
	shot.set_global_pos(get_global_pos())
	shot.speed = shot_speed[2]
	shot.direction = shooting_direction
	get_owner().add_child(shot)
	audio.play("enemy_shoot4")
	pass

func Shoot2(shooting_direction):
	var shots = []
	shots.append(pre_shot2.instance())
	shots.append(pre_shot.instance())
	shots.append(pre_shot.instance())
	for i in range(shots.size()):
		shots[i].set_global_pos(get_global_pos())
		shots[i].direction = shooting_direction
		shots[i].speed = shot_speed[i]
		get_owner().add_child(shots[i])
	audio.play("enemy_shoot2")
	pass

func TakeDamage(value):
	hit_anim.play("hit")
	hp -= value
	if hp <= 0:
		queue_free()
	audio.play("enemy_damage1")

func DeathSound():
	audio.play("enemy_death1")

func _on_enemy2_area_enter( area ):
	if area.is_in_group(global.PLAYER_HITBOX_GROUP):
		area.get_node("../").TakeDamage(1)
		TakeDamage(10)
	pass
