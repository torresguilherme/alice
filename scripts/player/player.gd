extends Node2D

#stats
var max_hp = 4
var hp = 0
var speed = 250
var cooldown = .1
var last_fired = 0

func _ready():
	hp = 4
	set_process(true)
	pass

func _process(delta):
	