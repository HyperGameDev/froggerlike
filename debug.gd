extends CanvasLayer

@onready var row_type: OptionButton = %Option_rowType
@onready var row_number: LineEdit = %Line_rowNumber
@onready var row_speed: LineEdit = %Line_rowSpeed
@onready var row_update: Button = %Button_rowUpdate

var set_row_type: int

func _ready() -> void:
	row_update_debug()
	
func row_update_debug():
	row_type.item_selected.connect(_on_row_type_selected)
	
	row_update.pressed.connect(_on_row_update_pressed)

func _on_row_type_selected(type):
	set_row_type = type
	
	
func _on_row_update_pressed():
	Messenger.update_row_speed.emit(set_row_type,int(row_number.get_text()),int(row_speed.get_text()))
