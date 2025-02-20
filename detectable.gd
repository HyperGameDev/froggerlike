extends Area3D

class_name Detectable


@export_range(0,13) var row
#var start_pos: float
var move_ok: bool = false

@export var speed: float = .5
@export var speed_increase_amount: float = .5
@export_range(-1.,1.,1.) var direction: int = 0

@onready var player: CharacterBody3D
		
	
#func _on_return_to_start_pos():
	#global_position.x = start_pos

func _on_player_ready():
	player =  get_tree().get_current_scene().get_node("Spawned/Player")

func move_object(rate,direction,object):
	object.global_position.x += rate * direction
	
	
func _on_state_msg_start():
	if speed < Globals.row_max_speeds[row]:
		speed += speed_increase_amount
		#print("Sped up!")
