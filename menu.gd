extends CanvasLayer

@onready var button_play: Button = %Button_Play
@onready var button_credits: Button = %Button_Credits

@onready var credits_r: MarginContainer = %Container_Credits_R
@onready var credits_l: MarginContainer = %Container_Credits_L

var show_credits: bool = false

func _ready() -> void:
	Messenger.state_menu.connect(_on_state_menu)
	Messenger.state_play.connect(_on_state_play)
	button_play.pressed.connect(_on_play_pressed)
	button_credits.pressed.connect(_on_credits_pressed)
	
func _on_state_menu():
	visible = true
	button_play.grab_focus.call_deferred()
	
func _on_state_play():
	visible = false
	
func _on_play_pressed():
	Messenger.update_game_state.emit(Globals.game_states.PLAY,true)
	
	if show_credits:
		_on_credits_pressed()
	
func _on_credits_pressed():
	show_credits = !show_credits
	
	if show_credits:
		credits_r.visible = true
		credits_l.visible = true
		credits_r.get_node("animation").play("scroll")
		credits_l.get_node("animation").play("scroll")
	else:
		credits_r.visible = false
		credits_l.visible = false
		credits_r.get_node("animation").stop()
		credits_l.get_node("animation").stop()
		
		
