extends Area3D

@export var target_type: target_types
@export var has_other_side_point: bool = false
enum target_types {PLAYER,ENEMY,PLATFORM}


var right_wrap: Area3D
var left_wrap: Area3D



func _ready():
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)
	set_collision_mask_value(Globals.collision.GROUND, false)
	
	collisions_to_wrap()
	
func collisions_to_wrap():
	match target_type:
		target_types.PLAYER:
			set_collision_mask_value(Globals.collision.PLAYER_WRAP, true)
			
		target_types.ENEMY:
			set_collision_mask_value(Globals.collision.ENEMY_WRAP, true)
			
		target_types.PLATFORM:
			set_collision_mask_value(Globals.collision.PLATFORM_WRAP, true)

func _on_area_entered(area):
	teleport_object(area)
	
func _on_body_entered(body):
	if body.is_in_group("Player"):
		Messenger.remove_player.emit(true,Player.death_states.EDGE)
	
func teleport_object(object):
	if target_type == target_types.PLAYER:
		var pos_flip: float = -1.
		object.global_position.x *= pos_flip
		
	else:
		if has_other_side_point:
			object.global_position.x = get_node("other_side_point").global_position.x
	
