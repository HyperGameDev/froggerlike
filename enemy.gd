extends Detectable

class_name Enemy

@export var has_animation: bool = false
@export var has_blood: bool = false
@export var has_electric: bool = false

func _ready() -> void:
	Messenger.player_ready.connect(_on_player_ready)

	if not has_electric:
		Messenger.state_msg_start.connect(_on_state_msg_start)
	body_entered.connect(_on_body_entered)
	
	if not has_electric:	
		set_collision_layer_value(Globals.collision.ENEMY, true)
	set_collision_mask_value(Globals.collision.PLAYER, true)


func _physics_process(delta: float) -> void:
	if not direction == 0:
		var rate: float = speed * delta
		move_object(rate,direction,self)

#func player_just_landed():
	#print(player.name, " is aligned with ",self.name)
	#
#func player_just_left():
	#print(player.name, " has left ",self.name)
		
func _on_body_entered(body):
	if body.is_in_group("Player"):
		if has_electric:
			Messenger.electric_shock.emit()
		else:
			Messenger.alien_eating.emit()
		Messenger.remove_player.emit(true,Player.death_states.ENEMY)
		death_animation()
		
	
	
func death_animation():
	if has_animation:
		get_node("alien").get_node("AnimationTree").set("parameters/feed/request", 1)
	if has_blood:
		get_node("alien").get_node("Blood").get_node("AnimationPlayer").play("feed")
	
	if has_electric:
		get_node("Electric").get_node("AnimationPlayer").play("feed")
		
