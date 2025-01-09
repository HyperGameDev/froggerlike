extends Area3D

@export var is_right: bool = true

var right_wrap: Area3D
var left_wrap: Area3D



func _ready():
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)
	
	set_collision_mask_value(Globals.collision.GROUND, false)
	set_collision_mask_value(Globals.collision.ENEMY, true)
	set_collision_mask_value(Globals.collision.PLAYER_WRAP, true)

func _on_area_entered(area):
	teleport_object(area)
	
func _on_body_entered(body):
	if body.is_in_group("Player"):
		player_visibility(body,false)
		teleport_object(body)
		await get_tree().create_timer(.3).timeout
		player_visibility(body,true)
		
func player_visibility(player,is_visible):
		player.visible = is_visible
		player.set_collision_layer_value(Globals.collision.PLAYER, is_visible)
	
func teleport_object(object):
	var pos_flip: float = -.97
		
	object.global_position.x *= pos_flip
	#object.direction *= pos_flip
	
