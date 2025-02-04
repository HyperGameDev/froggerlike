extends Label

@onready var timer: Timer = %Timer

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	Messenger.kill_score_popup.connect(_on_kill_score_popup)
	
func _on_timer_timeout():
	queue_free()

func _on_kill_score_popup():
	queue_free()
