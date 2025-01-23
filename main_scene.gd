extends Node3D
@onready var spawned: Node3D = %Spawned

@export var player_spawn_pos_x: int = 1
@export var player_spawn_pos_z: int = -1

func _ready() -> void:	
	Messenger.player_freed.connect(_on_player_freed)
	Messenger.state_play.connect(_on_state_play)
	
	Messenger.update_game_state.emit(Globals.game_states.MENU,true)
	
func _on_state_play():
	spawn_player()
	
func _on_player_freed():
	if not Globals.game_state == Globals.game_states.MESSAGE_OVER:
		spawn_player()
	
func spawn_player():
	await get_tree().create_timer(1).timeout
	var player = preload("res://player.tscn").instantiate()
	
	spawned.add_child(player)
	player.global_position.x = player_spawn_pos_x
	player.global_position.z = player_spawn_pos_z
