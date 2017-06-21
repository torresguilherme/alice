extends Node2D

onready var player = get_node("player")
var player_position

func _ready():
	set_process(true)
	pass

func _process(delta):
	player_position = player.get_global_pos()