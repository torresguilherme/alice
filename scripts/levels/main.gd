extends Node2D

onready var player = get_node("player")
onready var player_hitbox = player.get_node("hitbox")
onready var music = get_node("music")
var player_position
var player_hitbox_position
var pause_cooldown = 1
var last_pause = 1

func _ready():
	music.play()
	set_process(true)
	pass

func _process(delta):
	player_position = player.get_global_pos()
	player_hitbox_position = player_hitbox.get_global_pos()
	
	if Input.is_action_pressed("ui_cancel"):
		if last_pause <= 0:
			if !get_tree().is_paused():
				print("pause")
				get_tree().set_pause(true)
			else:
				print("unpause")
				get_tree().set_pause(false)
			last_pause = pause_cooldown
	if last_pause > 0:
		last_pause -= delta

func NextScene(value):
	global.ChangeScene(value)

func PlayMusic():
	music.play()

func PauseMusic():
	music.set_paused(true)

func UnpauseMusic():
	music.set_paused(false)