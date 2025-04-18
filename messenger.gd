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
signal state_msg_time_over
@warning_ignore("unused_signal")
signal state_msg_over
@warning_ignore("unused_signal")
signal state_over

@warning_ignore("unused_signal")
signal start_progress_timer
@warning_ignore("unused_signal")
signal stop_progress_timer

@warning_ignore("unused_signal")
signal return_to_start_pos

@warning_ignore("unused_signal")
signal update_row_speed ## arg1: type, arg2: row, arg3, speed
@warning_ignore("unused_signal")
signal update_finish_lines ## arg1: check what kind of finish? (bool)
@warning_ignore("unused_signal")
signal open_all_doors

@warning_ignore("unused_signal")
signal player_ready
@warning_ignore("unused_signal")
signal remove_player ## arg1: is_dead, arg2: death type enum
@warning_ignore("unused_signal")
signal respawn


@warning_ignore("unused_signal")
signal kill_score_popup 

@warning_ignore("unused_signal")
signal update_score ## arg1: score (int)
@warning_ignore("unused_signal")
signal update_lives ## arg1: life change
@warning_ignore("unused_signal")
signal update_level

@warning_ignore("unused_signal")
signal bonus_collected_at_finish
@warning_ignore("unused_signal")
signal wall_collided_at_finish

@warning_ignore("unused_signal")
signal is_enemy

@warning_ignore("unused_signal")
signal player_moved
@warning_ignore("unused_signal")
signal player_fell_off_edge
@warning_ignore("unused_signal")
signal player_died_of_time
@warning_ignore("unused_signal")
signal player_falling
@warning_ignore("unused_signal")
signal alien_eating
@warning_ignore("unused_signal")
signal electric_shock
@warning_ignore("unused_signal")
signal door_closing
@warning_ignore("unused_signal")
signal door_closed
