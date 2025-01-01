extends CharacterBody3D


const SPEED = .1
const JUMP_VELOCITY = 4.5

var move: Vector3 = Vector3.ZERO

@export var move_state: move_states
enum move_states {MOVE,STAY}

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Forward"):
		move = Vector3(0,0,-1)
		try_grid_movement("z")
	if event.is_action_pressed("Back"):
		move = Vector3(0,0,1)
		try_grid_movement("z")
	if event.is_action_pressed("Left"):
		move = Vector3(-1,0,0)
		try_grid_movement("x")
	if event.is_action_pressed("Right"):
		move = Vector3(1,0,0)
		try_grid_movement("x")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

func try_grid_movement(direction):
	if move_state == move_states.MOVE:
		grid_movement(direction)
	
func grid_movement(direction):
	match direction:
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
	print("X to: ",global_position)
	
func _on_move_z_finished():
	print("Z to: ",global_position)
	
