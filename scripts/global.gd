extends Node

const PLAYER_GROUP = ("player")
const ENEMY_GROUP = ("enemy")
const WALL_GROUP = ("wall")
const ENEMY_BULLET_GROUP = ("enemy_bullet")
const PLAYER_BULLET_GROUP = ("player_bullet")
const PLAYER_HITBOX_GROUP = ("player_hitbox")

var current_scene = 0
var scenes = []
var player_hp = 4

func _ready():
	scenes.append(load("res://scenes/levels/level1.tscn"))
	scenes.append(load("res://scenes/levels/boss_room.tscn"))
	pass

func ChangeScene(index):
	player_hp = get_tree().get_current_scene().get_node("player").hp
	get_tree().change_scene_to(scenes[index])
	get_tree().get_current_scene().get_node("player").hp = player_hp
	current_scene = index