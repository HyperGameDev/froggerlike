extends Node

@onready var ui: CanvasLayer = get_tree().get_current_scene().get_node("%Canvas_UI")

var game_state: game_states
enum game_states {
	MENU,
	PLAY,
	LEVELUP,
	MESSAGE_START,
	MESSAGE_TIME,
	MESSAGE_OVER,
	OVER,
	}

var score: int = 0
var score_high: int = 0

enum collision {
	DO_NOT_USE = 0,
	GROUND = 1,
	WALL = 2,
	ENEMY = 3,
	PLATFORM = 4,
	PLAYER = 5,
	PLAYER_WRAP = 6,
	KILLER_GAP = 7,
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
	
	if ui:
		_update_game_state(game_states.MENU,false)
  
func _on_reload():
	score = 0
	get_tree().reload_current_scene()

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
		game_states.MESSAGE_OVER:
			Messenger.state_msg_over.emit()
		game_states.OVER:
			Messenger.state_over.emit()
