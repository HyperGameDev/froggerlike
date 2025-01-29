extends CanvasLayer

@onready var label_score: Label = %"Label_Score-Value"
@onready var label_hiscore: Label = %"Label_HiScore-Value"
@onready var vbox_score: VBoxContainer = %VBox_Score

@onready var container_top: MarginContainer = %Container_Top
@onready var container_bottom: MarginContainer = %Container_Bottom

@onready var lives: HFlowContainer = %HBox_Lives
@onready var level: Label = %Label_Level

@onready var progress_bar: ProgressBar = %Progress_Time
@onready var progress_timer: Timer = %Progress_Timer
@export var progress_timer_length: float = 30.

var start_time: bool = false


@onready var rows_8_12: Node3D = %"Rows 8-12"
@onready var rows_0_7: Node3D = %"Rows_0-7"


func _ready() -> void:
	progress_timer.timeout.connect(_on_progress_timer_timeout)
	Messenger.update_score.connect(_on_update_score)
	Messenger.state_menu.connect(_on_state_menu)
	Messenger.state_play.connect(_on_state_play)
	Messenger.update_lives.connect(_on_update_lives)
	Messenger.update_level.connect(_on_update_level)
	Messenger.start_progress_timer.connect(_on_start_progress_timer)
	
	Messenger.update_score.emit(0)
	
func _on_start_progress_timer():
	progress_timer.start(progress_timer_length)
	start_time = true
	
func _process(delta: float) -> void:
	if start_time:
		update_progress_timer()
	
func update_progress_timer():
	var time_left: float = progress_timer.time_left
	Globals.time_left = time_left
	
	progress_bar.value = time_left
	
	
	if time_left <= 10.:
		progress_bar.modulate = Color(2,0,0)
	else:
		progress_bar.modulate = Color(1,1,1)
	
func _on_update_score(score:int) -> void:
	Globals.score += score
	if Globals.score > Globals.score_high:
		Globals.score_high = Globals.score
		Globals.save_game()
		
	label_score.text = str(Globals.score)
	label_hiscore.text = str(Globals.score_high)
	
	
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
	vbox_score.visible = false
	container_bottom.visible = false
	
func _on_state_play() -> void:
	rows_0_7.visible = true
	rows_8_12.visible = true
	vbox_score.visible = true
	container_bottom.visible = true

func _on_update_level():
	Globals.level += 1
	level.text = "LEVEL: " + str(Globals.level)

func _on_progress_timer_timeout():
	Messenger.remove_player.emit(true,Player.death_states.TIME)
	start_time = false
