extends Detectable

@onready var animation: AnimationPlayer = %AnimationPlayer


@onready var collision: CollisionShape3D = $collision

var finish_line_state: finish_line_states
enum finish_line_states {EMPTY,FILLED,BONUS,ENEMY,}


func _ready() -> void:
	add_to_group("Finish Line")
	
	set_collision_layer_value(Globals.collision.GROUND, false)
	
	set_collision_mask_value(Globals.collision.GROUND, false)
	set_collision_mask_value(Globals.collision.PLAYER, true)
	
	body_entered.connect(_on_body_entered)
	
func fill_finish_line():
	finish_line_state = finish_line_states.FILLED
	Messenger.update_finish_lines.emit()
	animation.play("close_doors")
	set_collision_layer_value(Globals.collision.WALL, true)
	
func _on_body_entered(body):
	if body.is_in_group("Player"):
		match finish_line_state:
			finish_line_states.EMPTY:
				Messenger.remove_player.emit(false,Player.death_states.NON)	
				
				fill_finish_line()
				
			finish_line_states.FILLED:
				pass
				
			finish_line_states.BONUS:
				Messenger.bonus_collected_at_finish.emit()
				Messenger.remove_player.emit(false,Player.death_states.NON)	
				
				fill_finish_line()
				
			finish_line_states.ENEMY: #remember to add respawn!
				Messenger.remove_player.emit(true,Player.death_states.ENEMY)			
