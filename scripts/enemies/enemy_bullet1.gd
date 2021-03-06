extends Area2D

var speed = 300
var damage = 1
var bullet_range = 1500
var direction = Vector2(0, 0)
var initial_pos = Vector2(0, 0)

func _ready():
	add_to_group(global.ENEMY_BULLET_GROUP)
	set_pause_mode(1)
	initial_pos = get_pos()
	set_process(true)
	pass

func _process(delta):
	############ MOVEMENT
	set_pos(get_pos() + direction * speed * delta)
	
	############ FREE MEMORY
	if(get_pos().x >= (initial_pos.x + bullet_range) || get_pos().x <= (initial_pos.x - bullet_range)
	|| get_pos().y >= (initial_pos.y + bullet_range) || get_pos().y <= (initial_pos.y - bullet_range)):
		queue_free()

func _on_enemy_bullet1_area_enter( area ):
	if area.is_in_group(global.PLAYER_HITBOX_GROUP):
		area.get_node("../").TakeDamage(damage)
		queue_free()
	elif area.is_in_group(global.WALL_GROUP):
		queue_free()
	pass

func _on_enemy_bullet2_area_enter( area ):
	if area.is_in_group(global.PLAYER_HITBOX_GROUP):
		area.get_node("../").TakeDamage(damage)
		queue_free()
	elif area.is_in_group(global.WALL_GROUP):
		queue_free()
	pass

func _on_enemy_bullet3_area_enter( area ):
	if area.is_in_group(global.PLAYER_HITBOX_GROUP):
		area.get_node("../").TakeDamage(damage)
		queue_free()
	elif area.is_in_group(global.WALL_GROUP):
		queue_free()
	pass

func _on_enemy_bullet4_area_enter( area ):
	if area.is_in_group(global.PLAYER_HITBOX_GROUP):
		area.get_node("../").TakeDamage(damage)
		queue_free()
	elif area.is_in_group(global.WALL_GROUP):
		queue_free()
	pass
