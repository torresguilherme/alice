extends Area2D

var speed = 600
var damage = 2
var dir_y = 0
var dir_x = 0
var bullet_range = 350
var initial_pos = Vector2(0, 0)

func _ready():
	add_to_group(global.PLAYER_BULLET_GROUP)
	initial_pos = get_pos()
	set_process(true)
	pass

func _process(delta):
	############ MOVEMENT
	set_pos(get_pos() + Vector2(dir_x, dir_y) * speed * delta)
	
	############# FREE FROM MEMORY
	if(get_pos().x >= (initial_pos.x + bullet_range) || get_pos().x <= (initial_pos.x - bullet_range)
	|| get_pos().y >= (initial_pos.y + bullet_range) || get_pos().y <= (initial_pos.y - bullet_range)):
		queue_free()

func _on_player_bullet_area_enter( area ):
	if area.is_in_group(global.ENEMY_GROUP):
		if area.has_method("TakeDamage"):
			area.TakeDamage(damage)
		queue_free()
	if area.is_in_group(global.WALL_GROUP):
		queue_free()
	pass
