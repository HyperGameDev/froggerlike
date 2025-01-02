extends Detectable

class_name Enemy

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	

func _physics_process(delta: float) -> void:
	if not direction == 0:
		var rate: float = speed * delta
		move_object(rate,direction,self)

func player_just_landed():
	print(player.name, " is aligned with ",self.name)
	
func player_just_left():
	print(player.name, " has left ",self.name)
		
func _on_body_entered(body):
	if body.is_in_group("Player"):
		print(name," overlapped with ",body.name)
