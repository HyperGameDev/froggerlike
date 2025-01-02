extends Area3D

class_name Detectable

signal player_just_landed
signal player_just_left

@onready var player: CharacterBody3D = get_tree().get_current_scene().get_node("Player")

var player_landed: bool = false
var player_overlapped: bool = false

@export var collision_type: collision_types
enum collision_types {
	ENEMY,
	BONUS_END,
	BONUS_CARRY,
	FINISH,
	PLATFORM,
	}

func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	if alignment_check():
		if not player_landed:
			player_landed = true
			player_just_landed.emit()
	else:
		if player_landed:
			player_landed = false
			player_just_left.emit()
	
func alignment_check():
	if not player_overlapped:
		return
		
	var type_needs_alignment: bool = collision_type == collision_types.PLATFORM or collision_type == collision_types.FINISH
	
	if not type_needs_alignment:
		return
	
	var is_aligned: bool = player.global_position.z == self.global_position.z
	
	var alignment_confirmed: bool = type_needs_alignment and is_aligned
	
	return alignment_confirmed
			
