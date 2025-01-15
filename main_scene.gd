extends Node3D
@onready var spawned: Node3D = %Spawned

@export var player_spawn_pos_x: int = 1

func _ready() -> void:
	var player = preload("res://player.tscn").instantiate()
	
	spawned.add_child(player)
	player.global_position.x = player_spawn_pos_x
