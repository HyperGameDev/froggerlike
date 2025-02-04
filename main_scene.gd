extends Node3D
@onready var spawned: Node3D = %Spawned

@export var player_spawn_pos_x: int = 1
@export var player_spawn_pos_z: int = -1

@onready var rows_8_12: Node3D = %"Rows 8-12"
@onready var rows_0_7: Node3D = %"Rows_0-7"

@onready var respawn_timer: Timer = %Respawn_Timer
var respawn_time: float = 1.3

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
	Messenger.return_to_start_pos.emit()
	
	rows_0_7.visible = true
	rows_8_12.visible = true
	
func spawn_player():
	var player = preload("res://player.tscn").instantiate()
	
	spawned.add_child(player,true)
	
	player.global_position.x = player_spawn_pos_x
	player.global_position.z = player_spawn_pos_z
	
	Messenger.start_progress_timer.emit()
