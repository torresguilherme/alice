extends Area2D

var speed = 300
var damage = 1
var bullet_range = 1500
var direction = Vector2(0, 0)

func _ready():
	set_process(true)
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	############ MOVEMENT
	set_pos(get_pos() + direction * speed * delta)
	
	############ FREE MEMORY
	if(get_pos().x >= bullet_range || get_pos().x <= -bullet_range || get_pos().y >= bullet_range || get_pos().y <= -bullet_range):
		queue_free()

func _on_enemy_bullet1_area_enter( area ):
	if area.is_in_group(global.PLAYER_GROUP):
		if area.has_method("TakeDamage"):
			area.TakeDamage(damage)
		else:
			area.queue_free()
		queue_free()
	pass