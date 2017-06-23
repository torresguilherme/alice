extends Node2D

onready var player = get_node("player")
onready var player_hitbox = player.get_node("hitbox")
onready var music = get_node("music")
var player_position
var player_hitbox_position

func _ready():
	music.play()
	set_process(true)
	pass

func _process(delta):
	player_position = player.get_global_pos()
	player_hitbox_position = player_hitbox.get_global_pos()