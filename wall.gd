extends Area3D

func _ready() -> void:
	set_collision_layer_value(Globals.collision.GROUND, false)
	set_collision_layer_value(Globals.collision.WALL, true)
	
