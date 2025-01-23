extends CanvasLayer

@onready var label_score: Label = %"Label_Score-Value"
@onready var label_hiscore: Label = %"Label_HiScore-Value"

@onready var container_top: MarginContainer = %Container_Top
@onready var container_bottom: MarginContainer = %Container_Bottom


@onready var rows_8_12: Node3D = %"Rows 8-12"
@onready var rows_0_7: Node3D = %"Rows_0-7"


func _ready() -> void:
	Messenger.update_score.connect(_on_update_score)
	Messenger.state_menu.connect(_on_state_menu)
	Messenger.state_play.connect(_on_state_play)
	
func _on_update_score(score:int) -> void:
	Globals.score += score
	label_score.text = str(Globals.score)
	
func _on_state_menu() -> void:
	rows_0_7.visible = false
	rows_8_12.visible = false
	container_top.visible = false
	container_bottom.visible = false
	
func _on_state_play() -> void:
	rows_0_7.visible = true
	rows_8_12.visible = true
	container_top.visible = true
	container_bottom.visible = true
