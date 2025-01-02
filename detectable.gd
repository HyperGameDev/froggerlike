extends Area3D

class_name Detectable

@export var collision_type: collision_types
enum collision_types {
	ENEMY,
	BONUS_END,
	BONUS_CARRY,
	FINISH,
	}
	

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body):
	if body.is_in_group("Player"):
		print(name," overlapped with ",body.name)
