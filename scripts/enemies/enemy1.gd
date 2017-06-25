extends Area2D

#stats
var speed = 80
var hp = 40
var cooldown = .5
var last_shot = 0
var aggro_distance = 400
var shot_speed = [400, 350, 300]

#shot type
var pre_shot = preload("res://scenes/enemies/enemy_bullet1.tscn")

#state
var attacking = false

#attack parameters
var player_position
var player_hitbox_position
var shooting_direction

# animation
onready var anim = get_node("anim")

# audio
onready var audio = get_node("audio")

func _ready():
	anim.play("default")
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
			Shoot3(shooting_direction)
			last_shot = cooldown
		else:
			############# RECOVERS FROM COOLDOWN
			last_shot -= delta

func Shoot3(direction):
	#instance shots
	var shots = []
	for i in range(shot_speed.size()):
		shots.append(pre_shot.instance())
		shots[i].speed = shot_speed[i]
		shots[i].direction = direction
		shots[i].set_global_pos(get_global_pos())
		get_owner().add_child(shots[i])
		audio.play("enemy_shoot4")
	pass

func TakeDamage(value):
	anim.play("hit")
	hp -= value
	if hp <= 0:
		queue_free()
	audio.play("enemy_damage1")

func return_anim_to_default():
	anim.play("default")

func DeathSound():
	audio.play("enemy_death1")

func _on_enemy1_area_enter( area ):
	if area.is_in_group(global.PLAYER_HITBOX_GROUP):
		area.get_node("../").TakeDamage(1)
		TakeDamage(10)
	pass
