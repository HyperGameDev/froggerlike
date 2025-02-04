extends CanvasLayer

@onready var label_score: Label = %"Label_Score-Value"
@onready var label_hiscore: Label = %"Label_HiScore-Value"
@onready var vbox_score: VBoxContainer = %VBox_Score

@onready var hbox_scorepopups: HFlowContainer = %HBox_Scorepopups
@onready var animation_scorepopup: AnimationPlayer = %Animation_scorepopup


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
	Messenger.stop_progress_timer.connect(_on_stop_progress_timer)
	
	Messenger.update_score.emit(0)
	
func _on_start_progress_timer():
	progress_timer.start(progress_timer_length)
	start_time = true
	
func _on_stop_progress_timer():
	progress_timer.stop()
	
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
	if score > 0:
		score_popup(score)
	
	Globals.score += score
	Globals.extra_life_tracker += score
	

	
	track_extra_lives(Globals.score)
	
	if Globals.score > Globals.score_high:
		Globals.score_high = Globals.score
		Globals.save_game()
		
	label_score.text = str(Globals.score)
	label_hiscore.text = str(Globals.score_high)
	
func kill_score_popup():
	Messenger.kill_score_popup.emit()
	
func score_popup(score):
	var popup := preload("res://UI/label_scorepopup.tscn").instantiate()
	hbox_scorepopups.add_child(popup)
	popup.text = "+" + str(score) + " "
	#popup.timer.start(1.1)
	animation_scorepopup.seek(0.0,true)
	animation_scorepopup.play("show_score")
	
func track_extra_lives(current_score):
	if Globals.extra_life_tracker >= Globals.extra_life_score:
		Globals.extra_life_tracker -= Globals.extra_life_score
		Messenger.update_lives.emit(1)
	
	
func _on_update_lives(amount) -> void:
	var lives_children = []
	lives_children.append_array(lives.get_children())
	
	var lives_array = []
	lives_array.append_array(lives_children)
	
	if amount < 0: # If life lost
		if lives_children.size() > 0:
			var pop_back_life = lives_array.pop_back()
			pop_back_life.queue_free()
			
		else:
			Messenger.update_game_state.emit(Globals.game_states.MESSAGE_OVER,true)
			
			
	else: # If life gained
		var extra_life := preload("res://UI/panel_life_01.tscn").instantiate()
		
		lives.add_child(extra_life)

		
	
func _on_state_menu() -> void:
	rows_0_7.visible = false
	rows_8_12.visible = false
	vbox_score.visible = false
	container_bottom.visible = false
	
func _on_state_play() -> void:
	vbox_score.visible = true
	container_bottom.visible = true

func _on_update_level():
	Globals.level += 1
	level.text = "LEVEL: " + str(Globals.level)

func _on_progress_timer_timeout():
	Messenger.remove_player.emit(true,Player.death_states.TIME)
	start_time = false
