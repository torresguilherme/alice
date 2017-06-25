extends Node2D

onready var player = get_node("player")
onready var player_hitbox = player.get_node("hitbox")
onready var music = get_node("music")
onready var transition = get_node("transition")
onready var hud = get_node("hud")

var pause_screen = preload("res://scenes/levels/pause_screen.tscn")
var game_over_screen = preload("res://scenes/levels/game_over_screen.tscn")
var player_position
var player_hitbox_position
var pause_cooldown = 1
var last_pause = 1
var ps

func _ready():
	music.play()
	if global.current_scene == 1:
		player.hp = global.PLAYER_MAX_HP
	else:
		player.hp = global.player_hp
	for i in range(player.hp):
		hud.AddHeart()
	set_process(true)
	pass

func _process(delta):
	player_position = player.get_global_pos()
	player_hitbox_position = player_hitbox.get_global_pos()
	
	if Input.is_action_pressed("ui_cancel"):
		if last_pause <= 0:
			if !get_tree().is_paused():
				get_tree().set_pause(true)
				ps = pause_screen.instance()
				ps.set_global_pos(get_node("player/camera").get_global_pos() + Vector2(-512, -400))
				add_child(ps)
				PauseMusic()
			else:
				get_tree().set_pause(false)
				UnpauseMusic()
				ps.queue_free()
			last_pause = pause_cooldown
	if last_pause > 0:
		last_pause -= delta
	
	if player.hp <= 0:
		transition.play("game_over")
		set_process(false)

func NextScene(value):
	global.ChangeScene(value)

func PlayMusic():
	music.play()

func PauseMusic():
	music.set_paused(true)

func UnpauseMusic():
	music.set_paused(false)