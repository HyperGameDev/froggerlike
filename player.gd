extends CharacterBody3D

class_name Player

@export var fall_death_pos: float = -1.1
@export var fall_oob_pos: float = -5.
@export var fall_speed: float = 10.

@onready var move_timer: Timer = %Move_Timer
var move_time: float = .1

const SPEED = .1
const JUMP_VELOCITY = 4.5
const wall_ray_l_x: float = -.5
const wall_ray_r_x: float = .5

var move: Vector3 = Vector3.ZERO

var move_direction: move_directions
enum move_directions {FORWARD,BACK,LEFT,RIGHT}

var death_state: death_states
enum death_states {NON,ENEMY,WATER,TIME,EDGE,WALL}

@export var move_state: move_states
enum move_states {MOVABLE,MOVING}

var animation: AnimationTree
@onready var animation_death: AnimationPlayer = %Animation_death

@onready var collision: CollisionShape3D = $collision
@onready var area: Area3D = %Area_Player


@onready var ray_forward_l: RayCast3D = %ray_forward_l
@onready var ray_forward_r: RayCast3D = %ray_forward_r
var wall_is_forward: bool = false
@onready var ray_back_l: RayCast3D = %ray_back_l
@onready var ray_back_r: RayCast3D = %ray_back_r
var wall_is_back: bool = false
@onready var ray_left_l: RayCast3D = %ray_left_l
@onready var ray_left_r: RayCast3D = %ray_left_r
var wall_is_left: bool = false
@onready var ray_right_l: RayCast3D = %ray_right_l
@onready var ray_right_r: RayCast3D = %ray_right_r
var wall_is_right: bool = false

var left_rays := []
var right_rays := []

var left_side_rays := []
var right_side_rays := []

var score_value_row: int = 10
var score_min_row: int = 1
var score_max_row: int = 12


func _ready() -> void:
	move_timer.timeout.connect(_on_move_timer_timeout)
	Messenger.player_ready.emit()
	
	
	animation = get_tree().get_current_scene().get_node("Spawned/Player/human_03_00/AnimationTree")
	#set_animation_tree()
	
	add_to_group("Player")
	area.add_to_group("Player Area")
	
	set_ray_masks()
	
	set_collision_layer_value(Globals.collision.PLAYER, true)	
	set_collision_layer_value(Globals.collision.PLAYER_WRAP, true)
	
	Messenger.remove_player.connect(_on_remove_player)
	Messenger.wall_collided_at_finish.connect(_on_wall_collided_at_finish)
	
	left_rays = [ray_left_l,ray_left_r]
	right_rays = [ray_right_l,ray_right_r]
	
	left_side_rays = [ray_right_l,ray_left_l]
	right_side_rays = [ray_left_r,ray_right_r]
	
func set_animation_tree():	
	var player_string: String
	if name.contains("Player"):
		player_string = name
	
	print("Spawned/" + player_string + "/human_03_00/AnimationTree")
	animation = get_tree().get_current_scene().get_node("Spawned/" + str(player_string) + "/human_03_00/AnimationTree")
	
func set_ray_masks():
	for node in get_children():
		if node is RayCast3D:
			node.set_collision_mask_value(Globals.collision.GROUND, false)
			node.set_collision_mask_value(Globals.collision.WALL, true)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Forward"):
		move = Vector3(0,0,-1)
		try_grid_movement("z",move)
	if event.is_action_pressed("Back"):
		move = Vector3(0,0,1)
		try_grid_movement("z",move)
	if event.is_action_pressed("Left"):
		move = Vector3(-1,0,0)
		try_grid_movement("x",move)
	if event.is_action_pressed("Right"):
		move = Vector3(1,0,0)
		try_grid_movement("x",move)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if global_position.y <= fall_death_pos:
		if death_state == death_states.WATER:
			queue_free()
		else:
			Messenger.remove_player.emit(true,Player.death_states.EDGE)
	
	check_for_walls()
	
	move_and_slide()
	
func check_for_walls():
	wall_is_forward = ray_forward_l.is_colliding() or ray_forward_r.is_colliding()
	wall_is_back = ray_back_l.is_colliding() or ray_back_r.is_colliding()
	wall_is_left = ray_left_l.is_colliding() or ray_left_r.is_colliding()
	wall_is_right = ray_right_l.is_colliding() or ray_right_r.is_colliding()
	
	#walls_debug()
	
func walls_debug():
	if ray_forward_l.is_colliding() or ray_forward_r.is_colliding():
		print("Front wall detected")
	if ray_back_l.is_colliding() or ray_back_r.is_colliding():
		print("Back wall detected")
	if ray_left_l.is_colliding() or ray_left_r.is_colliding():
		print("Left wall detected")
	if ray_right_l.is_colliding() or ray_right_r.is_colliding():
		print("Right wall detected")
	
var previous_pos: Vector3 = Vector3.ZERO

	
func try_grid_movement(axis,direction):
	if can_move():
		var moved_direction = check_direction(direction)
		match moved_direction:
			move_directions.FORWARD:
				if not wall_is_forward:
					grid_movement(axis)
			move_directions.BACK:
				if not wall_is_back:
					grid_movement(axis)
			move_directions.LEFT:
				if not wall_is_left:
					grid_movement(axis)
			move_directions.RIGHT:
				if not wall_is_right:
					grid_movement(axis)

func can_move():
	return move_state == move_states.MOVABLE and is_on_floor()
		
func check_direction(direction):
	match direction:
		Vector3(0,0,-1):
			move_direction = move_directions.FORWARD
		Vector3(0,0,1):
			move_direction = move_directions.BACK
		Vector3(-1,0,0):
			move_direction = move_directions.LEFT
		Vector3(1,0,0):
			move_direction = move_directions.RIGHT
			
	return move_direction
		
	
func grid_movement(axis):
	#print("PLAYER: GRID MOVE")
	Messenger.player_moved.emit()
	animation.set("parameters/Transition/transition_request", "running")
	
	if axis == "x" or axis == "z":
		move_state = move_states.MOVING
		
	match axis:
		"x":
			var tween_move_x = get_tree().get_current_scene().get_node("%Player_Tweens").create_tween()
			var to_move_x: float = global_position.x + move.x
			
			tween_move_x.tween_property(self, "global_position:x", to_move_x, SPEED)
			tween_move_x.connect("finished", _on_move_x_finished)
			
		"z":
			var tween_move_z = get_tree().get_current_scene().get_node("%Player_Tweens").create_tween()
			var to_move_z: float = global_position.z + move.z
			
			tween_move_z.tween_property(self, "global_position:z", to_move_z, SPEED)
			tween_move_z.connect("finished", _on_move_z_finished)
			
		_:
			print("Unexpected input direction received!")
		

func _on_move_x_finished():
	move_state = move_states.MOVABLE
	move_timer.start(move_time)
	
	
func _on_move_z_finished():
	move_state = move_states.MOVABLE
	move_timer.start(move_time)
	
func _on_move_timer_timeout():
	animation.set("parameters/Transition/transition_request", "idling")
	
	
	check_row_score()

func check_row_score():
	var row: int = abs(floor(global_position.z))
	
	if not score_min_row == score_max_row:
		if row > score_min_row:
			score_min_row += 1
			if not row == 7:
				Messenger.update_score.emit(score_value_row)
			
	
	
func _on_remove_player(is_dead,state):
	if is_dead:
		Messenger.update_lives.emit(-1)
		Messenger.respawn.emit()
		match state:
			death_states.NON:
				pass
			death_states.ENEMY:
				death_state = death_states.ENEMY
				free_player()
			death_states.WATER:
				Messenger.player_falling.emit()
				death_state = death_states.WATER
				collision.set_deferred("disabled", true)
				call_deferred("apply_velocity_change")
			death_states.TIME:
				death_state = death_states.TIME
				
				Messenger.player_died_of_time.emit()
				Messenger.update_game_state.emit(Globals.game_states.MESSAGE_TIME_OVER,true)
				free_player()
				
			death_states.EDGE:
				Messenger.player_fell_off_edge.emit()
				death_state = death_states.EDGE
				free_player()
				
			death_states.WALL:
				death_state = death_states.WALL
				free_player()
			
	else:
		#add filled finish line
		free_player()
			
func free_player():
	queue_free()
	
			
func apply_velocity_change():
	velocity.y -= fall_speed
	
func _on_wall_collided_at_finish():
	animation_death.play("fall_over")
	
	
func animation_death_fall_overed():
	Messenger.remove_player.emit(true,Player.death_states.WALL)
