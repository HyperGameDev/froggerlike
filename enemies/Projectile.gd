extends Area3D

class_name Projectile


var speed : float = 25.0
var direction : Vector3 = Vector3(0,0,1)

var target: Vector3



func _ready() -> void:		
	look_at(target, Vector3.UP)
	area_entered.connect(on_area_entered)
	
	set_collision_layer_value(Globals.collision.GROUND, false)
	
	set_collision_mask_value(Globals.collision.GROUND, false)
	set_collision_mask_value(Globals.collision.PLAYER, true)
		



func on_area_entered(area):
	print("Bullet passed through ",area,"!")
	
func _physics_process(delta: float) -> void:
	var direction = (target - global_position).normalized()
		
	if global_position.z >= 4:
		queue_free()

		
