extends Detectable

@onready var animation: AnimationPlayer = %AnimationPlayer


@onready var collision: CollisionShape3D = $collision

var finish_line_state: finish_line_states
enum finish_line_states {EMPTY,FILLED,BONUS,ENEMY,}


func _ready() -> void:
	set_collision_layer_value(Globals.collision.GROUND, false)
	set_collision_mask_value(Globals.collision.PLAYER, true)
	
	body_entered.connect(_on_body_entered)
	
func fill_finish_line():
	finish_line_state = finish_line_states.FILLED
	animation.play("close_doors")
	set_collision_layer_value(Globals.collision.WALL, true)
	
func _on_body_entered(body):
	if body.is_in_group("Player"):
		match finish_line_state:
			finish_line_states.EMPTY:
				Messenger.player_respawn.emit(false,Player.death_states.NON)	
				
				fill_finish_line()
				
			finish_line_states.FILLED:
				pass
				
			finish_line_states.BONUS:
				pass
				finish_line_state = finish_line_states.FILLED
				
			finish_line_states.ENEMY:
				Messenger.player_respawn.emit(true,Player.death_states.ENEMY)			
