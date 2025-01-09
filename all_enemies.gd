extends Rows

func _ready() -> void:
	Messenger.update_row_speed.connect(_on_update_row_speed)
	
func _on_update_row_speed(type,row_number,speed):
	if type == rows_type:
		for plat in get_children():
			if plat.row == row_number:
				plat.speed = speed
