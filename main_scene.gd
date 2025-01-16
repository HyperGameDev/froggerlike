extends Node3D
@onready var spawned: Node3D = %Spawned

@export var player_spawn_pos_x: int = 1
@export var player_spawn_pos_z: int = -1

func _ready() -> void:
	spawn_player()
	
	Messenger.player_freed.connect(_on_player_freed)
	
func _on_player_freed():
	spawn_player()
	
func spawn_player():
	await get_tree().create_timer(1).timeout
	var player = preload("res://player.tscn").instantiate()
	
	spawned.add_child(player)
	player.global_position.x = player_spawn_pos_x
	player.global_position.z = player_spawn_pos_z
