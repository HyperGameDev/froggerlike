extends Area3D

func _ready() -> void:
	set_collision_layer_value(Globals.collision.GROUND, false)
	set_collision_mask_value(Globals.collision.GROUND, false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
