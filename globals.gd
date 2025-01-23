extends Node

@onready var ui: CanvasLayer = get_tree().get_current_scene().get_node("%Canvas_UI")

var game_state: game_states
enum game_states {
	MENU,
	PLAY,
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

func _ready() -> void:
	Messenger.update_game_state.connect(_update_game_state)
	
	if ui:
		_update_game_state(game_states.MENU,false)
  
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
