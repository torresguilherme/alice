extends Node

const PLAYER_GROUP = ("player")
const ENEMY_GROUP = ("enemy")
const WALL_GROUP = ("wall")
const ENEMY_BULLET_GROUP = ("enemy_bullet")
const PLAYER_BULLET_GROUP = ("player_bullet")
const PLAYER_HITBOX_GROUP = ("player_hitbox")
const PLAYER_MAX_HP = 5

var current_scene = 0
var scenes = []
var player_hp = PLAYER_MAX_HP

func _ready():
	scenes.append(load("res://scenes/levels/main_menu.tscn"))
	scenes.append(load("res://scenes/levels/level1.tscn"))
	scenes.append(load("res://scenes/levels/boss_room.tscn"))
	scenes.append(load("res://scenes/levels/credits.tscn"))
	scenes.append(load("res://scenes/levels/game_over_screen.tscn"))
	pass

func ChangeScene(index):
	if current_scene == 1 || current_scene == 2:
		player_hp = get_tree().get_current_scene().get_node("player").hp
	get_tree().change_scene_to(scenes[index])
	current_scene = index
	get_tree().set_pause(false)