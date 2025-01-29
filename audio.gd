extends Node

@onready var player_movement: AudioStreamPlayer = %Player_movement
@onready var player_falling: AudioStreamPlayer = %Player_falling
@onready var player_splash: AudioStreamPlayer = %Player_splash

@onready var aliens_eating: Node = %Aliens_Eating
@onready var electric_shock: AudioStreamPlayer = %Electric_Shock

@onready var door_creak: AudioStreamPlayer = %Door_Creak
@onready var door_close: AudioStreamPlayer = %Door_Close

@onready var collect_01: AudioStreamPlayer = %Collect_01
@onready var wall_collide: AudioStreamPlayer = %Wall_Collide

@onready var oof: AudioStreamPlayer = %Oof



func _ready() -> void:
	Messenger.player_moved.connect(_on_player_moved)
	Messenger.player_fell_off_edge.connect(_on_player_fell_off_edge)
	Messenger.alien_eating.connect(_on_alien_eating)
	Messenger.electric_shock.connect(_on_electric_shock)
	Messenger.player_falling.connect(_on_player_falling)
	Messenger.door_closing.connect(_on_door_closing)
	Messenger.door_closed.connect(_on_door_closed)
	Messenger.player_died_of_time.connect(_on_player_died_of_time)
	Messenger.bonus_collected_at_finish.connect(_on_bonus_collected_at_finish)
	Messenger.wall_collided_at_finish.connect(_on_wall_collided_at_finish)
	
func _on_player_moved():
	var rand_pitch: float = randf_range(.7,1.3)
	player_movement.pitch_scale = rand_pitch
	player_movement.playing = true

func _on_alien_eating():
	var alien_eating_sounds := []
	alien_eating_sounds.append_array(aliens_eating.get_children())
	var alien_eating_sound: AudioStreamPlayer = alien_eating_sounds.pick_random()
	
	alien_eating_sound.playing = true
	
func _on_electric_shock():
	electric_shock.playing = true
	
func _on_player_falling():
	player_falling.playing = true

func _on_door_closing():
	door_creak.playing = true
	
func _on_door_closed():
	door_close.playing = true
	
func _on_bonus_collected_at_finish():
	collect_01.playing = true

func _on_wall_collided_at_finish():
	wall_collide.playing = true

func _on_player_fell_off_edge():
	player_splash.playing = true

func _on_player_died_of_time():
	oof.playing = true
