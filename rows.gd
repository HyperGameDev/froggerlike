extends Node3D

@export var rows_type: rows_types
enum rows_types {
	ENEMY = 0,
	PLATFORM = 1,
}


func _ready() -> void:
	Messenger.update_row_speed.connect(_on_update_row_speed)
	Messenger.debug_max_speed.connect(_on_debug_max_speed)

	
	
func _on_update_row_speed(type: int,row_number,speed):
	if type == rows_type:
		for node in get_children():
			if node.row == row_number:
				node.speed = speed
				
func _on_debug_max_speed():
	for node in get_children():
		node.speed = Globals.row_max_speeds[node.row]
