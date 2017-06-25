extends Node2D

var selected = 0
onready var menu_buttons = get_node("buttons")
onready var audio = get_node("ui_audio")
onready var button_anim = menu_buttons.get_node("button_anim")
var menu_cd = .05
var last_pressed = 0

func _ready():
	set_process(true)
	pass

func _process(delta):
	if selected == 0:
		button_anim.play("retry-selected")
	elif selected == 1:
		button_anim.play("quit-selected")
	
	if Input.is_action_pressed("ui_up") || Input.is_action_pressed("ui_down"):
		if last_pressed <= 0:
			selected = (selected + 1)%2
			audio.play("ui_select2")
			last_pressed = menu_cd
	if last_pressed > 0:
		last_pressed -= delta
	
	if Input.is_action_pressed("ui_select"):
		if selected == 0:
			button_anim.play("on_retry")
		elif selected == 1:
			button_anim.play("on_quit")

func Retry():
	global.player_hp = global.PLAYER_MAX_HP
	global.ChangeScene(1)
	queue_free()

func Quit():
	get_tree().quit()
	queue_free()