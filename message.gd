extends CanvasLayer

@onready var message: Label = %Label_Message

@onready var timer_over: Timer = %Timer_Over
@export var timer_over_length: float = 3

@onready var timer_time: Timer = %Timer_Time
@export var timer_time_length: float = 2.5

@onready var timer_start: Timer = %Timer_Start
@export var timer_start_length: float = 1.5

@onready var timer_start2: Timer = %Timer_Start2
@export var timer_start2_length: float = 3

@onready var timer_spawn: Timer = %Timer_Spawn
@export var timer_spawn_length: float = 1.5


func _ready() -> void:
	Messenger.state_msg_over.connect(_on_state_msg_over)
	Messenger.state_msg_time.connect(_on_state_msg_time)
	Messenger.state_msg_time_over.connect(_on_state_msg_time_over)
	Messenger.state_msg_start.connect(_on_state_msg_start)
	
	
	timer_over.timeout.connect(_on_timer_over_timeout)
	timer_time.timeout.connect(_on_timer_time_timeout)
	timer_start.timeout.connect(_on_timer_start_timeout)
	timer_start2.timeout.connect(_on_timer_start2_timeout)
	timer_spawn.timeout.connect(_on_timer_spawn_timeout)
	
func _on_state_msg_over():
	visible = true
	update_text("GAME OVER",true)
	
func _on_state_msg_time():
	#print("MESSSAGE: Time should show")
	var time_left: int = roundi(Globals.time_left)
	var score_multiplier: int = 10
	var time_score: int = time_left * score_multiplier
	Messenger.update_score.emit(time_score)
	visible = true
	update_text("TIME: " + str(time_left),true)
	
func _on_state_msg_start():
	#print("MESSSAGE: Start should show")
	visible = true
	update_text("TIME: " + str(10),true)
	
func _on_state_msg_time_over():
	visible = true
	#print("MESSAGE: Lives left: ", Globals.lives)
	if Globals.lives == -1:
		update_text("GAME OVER",true)
	else:
		update_text("TIME OVER",true)
	
	
func update_text(new_text,run_timer):
	message.text = new_text
	
	if run_timer:
		match Globals.game_state:
			Globals.game_states.MESSAGE_OVER:
				timer_over.start(timer_over_length)
			Globals.game_states.MESSAGE_TIME:
				timer_time.start(timer_time_length)
				timer_spawn.start(timer_spawn_length)
			Globals.game_states.MESSAGE_TIME_OVER:
				timer_time.start(timer_over_length)
			Globals.game_states.MESSAGE_START:
				timer_start.start(timer_start_length)
	
func _on_timer_over_timeout():
	visible = false
	Messenger.reload.emit()
	
func _on_timer_time_timeout():
	visible = false
	#print("time timout")
	
func _on_timer_start_timeout():
	#print("MESSSAGE: Start 2 should show")
	Messenger.update_game_state.emit(Globals.game_states.PLAY,true)
	Messenger.update_level.emit()

	update_text("START LEVEL " + str(Globals.level),false)	
	timer_start2.start(timer_start2_length)
	
func _on_timer_start2_timeout():
	visible = false
	Messenger.open_all_doors.emit()
	
func _on_timer_spawn_timeout():
	Messenger.update_game_state.emit(Globals.game_states.PLAY,true)
	#print("should spawn")
	
	
