extends Node3D


@export var interval_length: float = 3.
@onready var interval_timer : Timer = Timer.new()
@onready var object_lifetimer : Timer = Timer.new()

@export var bonus_at_finish_score: int = 200

@onready var teleportees: Node3D = %Teleportees
@onready var bonus_finish: Area3D = %Bonus_Finish
@onready var enemy_shooter: Area3D = %Enemy_Shooter

@export var will_teleport_bonus: bool = true

var all_finish_lines = []
var empty_finish_lines = []

func _ready() -> void:
	setup_timers()
	Messenger.bonus_collected_at_finish.connect(_on_bonus_collected_at_finish)
	Messenger.update_finish_lines.connect(_on_update_finish_lines)
	Messenger.state_play.connect(_on_state_play)
	Messenger.open_all_doors.connect(_on_open_all_doors)
	update_finish_line_array()
	
func setup_timers():
	interval_timer.timeout.connect(_on_interval_timeout)
	interval_timer.one_shot = true
	add_child(interval_timer)
	object_lifetimer.timeout.connect(_on_object_lifetimer_timeout)
	object_lifetimer.one_shot = true
	add_child(object_lifetimer)
	
func _on_state_play():
	interval_timer.start(interval_length)
	
func _on_interval_timeout():
	#print("FINISH OBJECT: Coin flip")
	if any_finish_lines_available() and object_not_present():
		var boolean = pow(-1, randi() % 2)
		if boolean > 0:
			
			#print("FINISH OBJECT: Heads!")
			add_object_to_finish_line()
		else:
			#print("FINISH OBJECT: Tails.")
			interval_timer.start(interval_length)

func add_object_to_finish_line():
	var teleport_point: Area3D = pick_teleport_point()
			
	finish_object_to_add().global_position = teleport_point.global_position
	
	if will_teleport_bonus:
		teleport_point.finish_line_state = teleport_point.finish_line_states.BONUS
	else:
		teleport_point.finish_line_state = teleport_point.finish_line_states.ENEMY
	
	object_lifetimer.start(interval_length)

func _on_bonus_collected_at_finish():
	Messenger.update_score.emit(bonus_at_finish_score)
	_on_object_lifetimer_timeout()

func _on_object_lifetimer_timeout():
	#print("FINISH OBJECT: Is dead")
	for area in empty_finish_lines:
		match area.finish_line_state:
			area.finish_line_states.BONUS:
				bonus_finish.global_position = teleportees.global_position
				
			area.finish_line_states.ENEMY:
				enemy_shooter.global_position = teleportees.global_position
		
		area.finish_line_state = area.finish_line_states.EMPTY
	interval_timer.start(interval_length)
			
func pick_teleport_point() -> Area3D:
	return empty_finish_lines.pick_random()
	
func finish_object_to_add() -> Area3D:
	if will_teleport_bonus:
		return bonus_finish
	else:
		return enemy_shooter
				
func any_finish_lines_available() -> bool:
	if empty_finish_lines.size() <= 0:
		return false
	else:
		return true

func object_not_present() -> bool:
	for area in empty_finish_lines:
		if area.finish_line_state == area.finish_line_states.BONUS or area.finish_line_state == area.finish_line_states.ENEMY:
			return false
	return true
	
func _on_update_finish_lines(check_kind_of_finish):
	update_finish_line_array()
	if check_kind_of_finish:
		what_kind_of_finish()
	
func what_kind_of_finish():
	if any_finish_lines_available():
		end_round_only()
	else:
		start_next_level()

func end_round_only() -> void:
	Messenger.update_game_state.emit(Globals.game_states.MESSAGE_TIME,true)

func start_next_level() -> void:
	Messenger.update_game_state.emit(Globals.game_states.MESSAGE_START,true)
	
func _on_open_all_doors() -> void:
	for node in all_finish_lines:
		node.empty_finish_line()
		Messenger.update_finish_lines.emit(false)

func update_finish_line_array():
	empty_finish_lines.clear()
	for node in get_children():
		for subnode in node.get_children():
			if subnode.is_in_group("Finish Line"):
				if not subnode.finish_line_state == subnode.finish_line_states.FILLED:
					empty_finish_lines.append(subnode)
	
	#print("FINISH OBJECT: Updated finish lines")				
	#print(empty_finish_lines)
					

					
