extends Node2D

var speed = 600
var damage = 2
var dir_y = 0
var dir_x = 0

func _ready():
	set_process(true)
	pass

func _process(delta):
	############ MOVEMENT
	set_pos(get_pos() + Vector2(dir_x, dir_y) * speed * delta)
	
	############# FREE FROM MEMORY
	if(get_pos().x >= 1200 || get_pos().x <= -200 || get_pos().y >= 1000 || get_pos().y <= -200):
		queue_free()
