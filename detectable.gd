extends Area3D

class_name Detectable


@export_range(0,13) var row

@export var speed: float = .5
@export_range(-1.,1.,1.) var direction: int = 0

@onready var player: CharacterBody3D = get_tree().get_current_scene().get_node("Player")

func move_object(rate,direction,object):
	object.global_position.x += rate * direction
