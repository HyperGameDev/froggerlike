extends CanvasLayer

@onready var message: Label = %Label_Message
@onready var timer: Timer = %Timer

@export var timer_length: int = 3

func _ready() -> void:
	Messenger.state_msg_over.connect(_on_state_msg_over)
	timer.timeout.connect(_on_timer_timeout)
	
func _on_state_msg_over():
	visible = true
	update_text("GAME OVER")
	
func update_text(new_text):
	message.text = new_text
	timer.start(timer_length)
	
func _on_timer_timeout():
	visible = false
	Messenger.reload.emit()
