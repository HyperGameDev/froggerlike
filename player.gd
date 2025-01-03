extends CharacterBody3D

const SPEED = .1
const JUMP_VELOCITY = 4.5

var move: Vector3 = Vector3.ZERO

var move_direction: move_directions
enum move_directions {FORWARD,BACK,LEFT,RIGHT}

@export var move_state: move_states
enum move_states {MOVABLE,MOVING}

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


func _ready() -> void:
	add_to_group("Player")
	
	set_ray_masks()
	
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
	check_for_walls()
	
	move_and_slide()
	
func check_for_walls():
	wall_is_forward = ray_forward_l.is_colliding() or ray_forward_r.is_colliding()
	wall_is_back = ray_back_l.is_colliding() or ray_back_r.is_colliding()
	wall_is_left = ray_left_l.is_colliding() or ray_left_r.is_colliding()
	wall_is_right = ray_right_l.is_colliding() or ray_right_r.is_colliding()
	
	walls_debug()
	
func walls_debug():
	if ray_forward_l.is_colliding() or ray_forward_r.is_colliding():
		print("Front wall detected")
	if ray_back_l.is_colliding() or ray_back_r.is_colliding():
		print("Back wall detected")
	if ray_left_l.is_colliding() or ray_left_r.is_colliding():
		print("Left wall detected")
	if ray_right_l.is_colliding() or ray_right_r.is_colliding():
		print("Right wall detected")
	
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
	if axis == "x" or axis == "z":
		move_state = move_states.MOVING
		
	match axis:
		"x":
			var tween_move_x = get_tree().create_tween()
			var to_move_x: float = global_position.x + move.x
			
			tween_move_x.tween_property(self, "global_position:x", to_move_x, SPEED)
			tween_move_x.connect("finished", _on_move_x_finished)
			
		"z":
			var tween_move_z = get_tree().create_tween()
			var to_move_z: float = global_position.z + move.z
			
			tween_move_z.tween_property(self, "global_position:z", to_move_z, SPEED)
			tween_move_z.connect("finished", _on_move_z_finished)
			
		_:
			print("Unexpected input direction received!")
		

func _on_move_x_finished():
	move_state = move_states.MOVABLE
	
func _on_move_z_finished():
	move_state = move_states.MOVABLE
	
