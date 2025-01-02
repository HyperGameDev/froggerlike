extends Detectable

class_name Enemy


@export var is_moving: bool = true
@export var speed: float = 1.

func _ready() -> void:
	collision_type = collision_types.ENEMY
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	

func _physics_process(delta: float) -> void:
	if is_moving:
		var movement_rate: float = speed * delta
		move_platform(movement_rate)

	
func move_platform(movement_rate):
	self.global_position.x += movement_rate


func player_just_landed():
	print(player.name, " is aligned with ",self.name)
	
func player_just_left():
	print(player.name, " has left ",self.name)
		
func _on_body_entered(body):
	if body.is_in_group("Player"):
		print(name," overlapped with ",body.name)
		player_overlapped = true
		
func _on_body_exited(body):
	player_overlapped = false
