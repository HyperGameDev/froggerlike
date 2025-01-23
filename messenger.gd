extends Node


@warning_ignore("unused_signal")
signal reload
@warning_ignore("unused_signal")
signal debug_max_speed

@warning_ignore("unused_signal")
signal update_game_state ## arg1: game state enum, arg2: should emit state (bool)
@warning_ignore("unused_signal")
signal state_menu 
@warning_ignore("unused_signal")
signal state_play 
@warning_ignore("unused_signal")
signal state_msg_start
@warning_ignore("unused_signal")
signal state_msg_time
@warning_ignore("unused_signal")
signal state_msg_over
@warning_ignore("unused_signal")
signal state_over

@warning_ignore("unused_signal")
signal update_row_speed ## arg1: type, arg2: row, arg3, speed
@warning_ignore("unused_signal")
signal update_finish_lines

@warning_ignore("unused_signal")
signal player_ready
@warning_ignore("unused_signal")
signal remove_player ## arg1: is_dead, arg2: death type enum
@warning_ignore("unused_signal")
signal respawn


@warning_ignore("unused_signal")
signal update_score ## arg1: score int
@warning_ignore("unused_signal")
signal update_lives ## arg1: life change
