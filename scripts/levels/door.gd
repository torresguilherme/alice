extends Area2D

onready var transition = get_node("../").get_node("transition")

func _ready():
	add_to_group(global.WALL_GROUP)
	pass

func _on_door_area_enter( area ):
	transition.play("end")
	pass
