extends Detectable

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	player_just_landed.connect(_on_player_just_landed)
	player_just_left.connect(_on_player_just_left)

func _on_player_just_landed():
	print(player.name, " is aligned with ",self.name)
	
func _on_player_just_left():
	print(player.name, " has left ",self.name)
	
func _on_body_entered(body):
	if body.is_in_group("Player"):
		print(name," overlapped with ",body.name)
		player_overlapped = true
		
func _on_body_exited(body):
	player_overlapped = false
