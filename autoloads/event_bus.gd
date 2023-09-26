extends Node


# Common signals
signal sequence_started # Used for animated sequences that pause the game state
signal sequence_finished # Used for animated sequences that pause the game state

# Game Manager signals
signal level_ended
signal money_increased
signal money_decreased
signal flag_counts_changed

# Board signals
signal board_completion_checked(complete)
signal revealed_hole(cell)
signal revealed_gold(cell)
signal revealed_diamond(cell)
signal board_flags_changed
signal hole_flagged_wrong
signal treasure_flagged_wrong
signal hole_flagged_right
signal gold_flagged_right
signal diamond_flagged_right
signal board_mined

# Interface signals
signal finish_button_pressed
