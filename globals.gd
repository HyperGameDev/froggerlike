extends Node

@onready var ui: CanvasLayer = get_tree().get_current_scene().get_node("%Canvas_UI")


var game_state: game_states
enum game_states {
	MENU,
	PLAY,
	LEVELUP,
	MESSAGE_START,
	MESSAGE_TIME,
	MESSAGE_TIME_OVER,
	MESSAGE_OVER,
	OVER,
	}

var score: int = 0
var score_high: int = 0
var extra_life_tracker: int = 0
@export var extra_life_score: int = 20000
var level: int = 1
var lives: int = 2
var time_left: float = 0.

enum collision {
	DO_NOT_USE = 0,
	GROUND = 1,
	WALL = 2,
	ENEMY = 3,
	ENEMY_WRAP = 4,
	PLATFORM = 5,
	PLATFORM_WRAP = 6,
	PLAYER = 7,
	PLAYER_WRAP = 8,
	KILLER_GAP = 9,
}

var row_max_speeds := [
	0.,  
	0.,
	5.5,
	5.5,
	6.,
	10.,
	7.,
	0.,
	10.,
	5.,
	8.,
	7.,
	4.5,
]

func _ready() -> void:
	Messenger.reload.connect(_on_reload)
	Messenger.update_game_state.connect(_update_game_state)
	Messenger.update_lives.connect(_on_update_lives)
	
	if ui:
		_update_game_state(game_states.MENU,false)

	load_game()

func save_data() -> Dictionary:
	var save_dict :Dictionary = {
		
		"hiscore" = score_high,
	}
	return save_dict


func save_game() -> void:
	var save_score :FileAccess = FileAccess.open("user://save_score.save", FileAccess.WRITE)
	var json_string : String= JSON.stringify(save_data())
	save_score.store_line(json_string)


func load_game() -> void:
	if not FileAccess.file_exists("user://save_score.save"):
		return
	
	var save_score :FileAccess= FileAccess.open("user://save_score.save", FileAccess.READ)
	
	var content: Dictionary = JSON.parse_string(save_score.get_as_text())
	score_high = content["hiscore"]
	Messenger.update_score.emit(0)
		
	

func _on_reload():
	score = 0
	level = 1
	lives = 2
	time_left = 0.
	get_tree().reload_current_scene()

func _on_update_lives(amount):
	lives += amount
	#print("GLOBALS: Lives left: ",lives)
	
func _update_game_state(state,emit) -> void:
	game_state = state
	if emit:
		_emit_game_state()
	
	
func _emit_game_state() -> void:
	match game_state:
		game_states.MENU:
			Messenger.state_menu.emit()
		game_states.PLAY:
			Messenger.state_play.emit()
		game_states.MESSAGE_START:
			Messenger.state_msg_start.emit()
		game_states.MESSAGE_TIME:
			Messenger.state_msg_time.emit()
		game_states.MESSAGE_TIME_OVER:
			Messenger.state_msg_time_over.emit()
		game_states.MESSAGE_OVER:
			Messenger.state_msg_over.emit()
		game_states.OVER:
			Messenger.state_over.emit()
