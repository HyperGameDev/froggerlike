extends Node3D
@onready var spawned: Node3D = %Spawned

@export var player_spawn_pos_x: int = 1
@export var player_spawn_pos_z: int = -1

@onready var respawn_timer: Timer = %Respawn_Timer
var respawn_time: float = 1.

func _ready() -> void:	
	Messenger.respawn.connect(_on_respawn)
	Messenger.state_play.connect(_on_state_play)
	
	Messenger.update_game_state.emit(Globals.game_states.MENU,true)
	respawn_timer.timeout.connect(_on_respawn_timer_timeout)
	
func _on_state_play():
	_on_respawn()
	
func _on_respawn():
	if not Globals.game_state == Globals.game_states.MESSAGE_OVER:
		respawn_timer.start(respawn_time)

func _on_respawn_timer_timeout():
	spawn_player()
	
func spawn_player():
	var player = preload("res://player.tscn").instantiate()
	
	spawned.add_child(player,true)
	
	player.global_position.x = player_spawn_pos_x
	player.global_position.z = player_spawn_pos_z
