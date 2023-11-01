extends Node


# Common signals
signal sequence_started # Used for animated sequences that pause the game state
signal sequence_finished # Used for animated sequences that pause the game state
signal transition_in_triggered(duration) # Used for the transition effect
signal transition_out_triggered(duration) # Used for the transition effect

# Scene Manager signals
signal scene_changed

# Game Manager signals
signal level_ended
signal level_started
signal money_increased
signal money_decreased
signal flag_counts_changed
signal game_won
signal game_state_reset

# Board signals
signal board_completion_checked(complete)
signal revealed_hole(cell)
signal revealed_gold
signal revealed_diamond
signal board_flags_changed
signal hole_flagged_wrong
signal treasure_flagged_wrong
signal hole_flagged_right
signal gold_flagged_right
signal diamond_flagged_right
signal board_mined

# Enemy signals
signal bat_collided

# Interface signals
signal finish_button_pressed
signal pause_button_pressed
signal restart_button_pressed
signal quit_button_pressed

