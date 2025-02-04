extends Detectable

class_name Platform

@onready var ground: AnimatableBody3D = %Ground_platform

@onready var killer_gap_l: Area3D = %KillerGap_L
@onready var killer_gap_r: Area3D = %KillerGap_R

var animation: AnimationPlayer
@export var meshes: Node3D

@export var has_sinking: bool = false
@export var has_two_killer_gaps: bool = false
@export var uses_alt_killer_gap: bool = false

func _ready() -> void:
	#start_pos = global_position.x
	#Messenger.return_to_start_pos.connect(_on_return_to_start_pos)
	Messenger.player_ready.connect(_on_player_ready)
	Messenger.state_msg_start.connect(_on_state_msg_start)
	Messenger.state_play.connect(_on_state_play)
	area_entered.connect(_on_area_entered)
	
	set_collision_layer_value(Globals.collision.PLATFORM_WRAP, true)	
	set_collision_mask_value(Globals.collision.GROUND,false)
	
	if uses_alt_killer_gap:
		change_killer_gap()
		
	if has_sinking:
		setup_sinking()
		
	add_killer_gap()


func _on_state_play():
	move_ok = true
	
func _on_area_entered(area):
	#print("PLAT ",name," sees ",area)
	if area.is_in_group("Player Area"):
		Messenger.remove_player.emit(true,Player.death_states.WATER)

func setup_sinking():
	animation = %AnimationPlayer
	animation.play("sink")
	
func sink_removed_collision():
	ground.set_collision_layer_value(Globals.collision.GROUND,false)
	set_collision_mask_value(Globals.collision.GROUND,true)
	
func sink_added_collision():
	ground.set_collision_layer_value(Globals.collision.GROUND,true)
	set_collision_mask_value(Globals.collision.GROUND,false)

func change_killer_gap():
	killer_gap_l = %KillerGap_L2
	killer_gap_r = %KillerGap_R2
	
func add_killer_gap():
	#killer_gap_r.mesh.visible = true
	killer_gap_r.collision.disabled = false
	if has_two_killer_gaps:
		#killer_gap_l.mesh.visible = true
		killer_gap_l.collision.disabled = false

func _physics_process(delta: float) -> void:
	if not direction == 0:
		var rate: float = speed * delta

		if move_ok:
			move_object(rate,direction,ground)
			
		
		self.global_position.x = ground.global_position.x
	
