extends Node3D

@onready var blood: GPUParticles3D = %"Particles_Blood-Human"
@onready var electric: GPUParticles3D = %Particles_Electric
@onready var orb_preload: MeshInstance3D = %Orb_preload


func _ready() -> void:
	blood.emitting = true
	electric.emitting = true
	Messenger.state_play.connect(_on_state_play)
	
func _on_state_play():
	for node in get_children():
		node.queue_free()
