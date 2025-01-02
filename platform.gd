extends Detectable

class_name Platform

@onready var ground: AnimatableBody3D = %Ground_platform

func _physics_process(delta: float) -> void:
	if not direction == 0:
		var rate: float = speed * delta
		move_object(rate,direction,ground)
		self.global_position.x = ground.global_position.x
