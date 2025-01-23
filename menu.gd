extends CanvasLayer

@onready var button_play: Button = %Button_Play


func _ready() -> void:
	Messenger.state_menu.connect(_on_state_menu)
	Messenger.state_play.connect(_on_state_play)
	button_play.pressed.connect(_on_play_pressed)
	
func _on_state_menu():
	visible = true
	button_play.grab_focus.call_deferred()
	
func _on_state_play():
	visible = false
	
func _on_play_pressed():
	Messenger.update_game_state.emit(Globals.game_states.PLAY,true)
	
