extends CharacterBody3D


const SPEED = 1.0
const JUMP_VELOCITY = 4.5

var move: Vector3 = Vector3.ZERO


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Forward"):
		move = Vector3(0,0,-1)
		grid_movement()
	if event.is_action_pressed("Back"):
		move = Vector3(0,0,1)
		grid_movement()
	if event.is_action_pressed("Left"):
		move = Vector3(-1,0,0)
		grid_movement()
	if event.is_action_pressed("Right"):
		move = Vector3(1,0,0)
		grid_movement()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	
func grid_movement():
	global_position += move
	print(global_position)
