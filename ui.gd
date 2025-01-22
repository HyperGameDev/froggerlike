extends CanvasLayer

@onready var label_score: Label = %"Label_Score-Value"
@onready var label_hiscore: Label = %"Label_HiScore-Value"



func _ready() -> void:
	Messenger.update_score.connect(_on_update_score)
	
	
func _on_update_score(score:int):
	Globals.score += score
	label_score.text = str(Globals.score)
