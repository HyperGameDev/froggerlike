extends CanvasLayer

@onready var label_score: Label = %"Label_Score-Value"
@onready var label_hiscore: Label = %"Label_HiScore-Value"

@onready var container_top: MarginContainer = %Container_Top
@onready var container_bottom: MarginContainer = %Container_Bottom

@onready var lives: HFlowContainer = %HBox_Lives
@onready var level: Label = %Label_Level



@onready var rows_8_12: Node3D = %"Rows 8-12"
@onready var rows_0_7: Node3D = %"Rows_0-7"


func _ready() -> void:
	Messenger.update_score.connect(_on_update_score)
	Messenger.state_menu.connect(_on_state_menu)
	Messenger.state_play.connect(_on_state_play)
	Messenger.update_lives.connect(_on_update_lives)
	Messenger.update_level.connect(_on_update_level)
	
func _on_update_score(score:int) -> void:
	Globals.score += score
	label_score.text = str(Globals.score)
	
func _on_update_lives(amount) -> void:
	var lives_children = []
	lives_children.append_array(lives.get_children())
	
	if amount < 0 and lives_children.size() > 0:
		var lives_array = []
		lives_array.append_array(lives_children)
		var last_life = lives_array.pop_back()
		last_life.queue_free()
		
	if lives_children.size() <= 0:
		Messenger.update_game_state.emit(Globals.game_states.MESSAGE_OVER,true)
	
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

func _on_update_level():
	Globals.level += 1
	level.text = "LEVEL: " + str(Globals.level)
