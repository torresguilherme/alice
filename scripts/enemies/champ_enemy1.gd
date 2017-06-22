extends Area2D

#stats
var speed = 80
var hp = 150
var cooldown = 1
var last_shot = 0
var aggro_distance = 800
var shot_speed = 100

#shot type
var pre_shot = preload("res://scenes/enemies/champ_bullet.tscn")

#state
var attacking = false

#attack parameters
var player_position
var shooting_direction

# animation
onready var anim = get_node("anim")
onready var hit_anim = get_node("hit_anim")

func _ready():
	add_to_group(global.ENEMY_GROUP)
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
			# calculates unit vector
			var sum = sqrt(abs(pow((player_position.x - get_global_pos().x), 2) + pow((player_position.y - get_global_pos().y), 2)))
			shooting_direction = Vector2((player_position.x - get_global_pos().x)/sum, (player_position.y - get_global_pos().y)/sum)
			
			# shoots
			Shoot(shooting_direction)
			last_shot = cooldown
		else:
			############# RECOVERS FROM COOLDOWN
			last_shot -= delta

func Shoot(direction):
	#instance shots
	var shot = pre_shot.instance()
	shot.speed = shot_speed
	shot.direction = direction
	shot.set_global_pos(get_global_pos())
	get_owner().add_child(shot)
	pass

func TakeDamage(value):
	hit_anim.play("hit")
	hp -= value
	if hp <= 0:
		queue_free()
