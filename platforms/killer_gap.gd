extends Detectable

@onready var collision: CollisionShape3D = $collision
@onready var mesh: MeshInstance3D = $mesh

func _ready() -> void:
	set_collision_layer_value(Globals.collision.GROUND, false)
	set_collision_mask_value(Globals.collision.PLAYER, true)
	
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body):
	if body.is_in_group("Player"):
		Messenger.player_respawn.emit(true,Player.death_states.WATER)