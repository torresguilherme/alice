extends Node2D

var selected = 0
onready var menu_buttons = get_node("buttons")
onready var anim = get_node("anim")
onready var audio = get_node("ui_audio")
onready var button_anim = menu_buttons.get_node("button_anim")
var menu_cd = .05
var last_pressed = 0

func _ready():
	pass

func _process(delta):
	if selected == 0:
		button_anim.play("start_selected")
	elif selected == 1:
		button_anim.play("quit_selected")
	
	if Input.is_action_pressed("ui_up") || Input.is_action_pressed("ui_down"):
		if last_pressed <= 0:
			selected = (selected + 1)%2
			audio.play("ui_select2")
			last_pressed = menu_cd
	if last_pressed > 0:
		last_pressed -= delta
	
	if Input.is_action_pressed("ui_select"):
		if selected == 0:
			anim.play("on_select")
		elif selected == 1:
			anim.play("on_quit")

func Start():
	global.ChangeScene(1)

func Quit():
	get_tree().quit()