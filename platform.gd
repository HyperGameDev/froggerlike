extends Detectable

class_name Platform

@onready var ground: AnimatableBody3D = %Ground_platform

@onready var killer_gap_l: Area3D = %KillerGap_L
@onready var killer_gap_r: Area3D = %KillerGap_R


@export var has_two_killer_gaps: bool = false
@export var uses_alt_killer_gap: bool = false


func _ready() -> void:
	
	Messenger.player_ready.connect(_on_player_ready)
	
	set_collision_layer_value(Globals.collision.PLATFORM, true)
	
	if uses_alt_killer_gap:
		change_killer_gap()
		
	add_killer_gap()
	

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
		move_object(rate,direction,ground)
		self.global_position.x = ground.global_position.x
