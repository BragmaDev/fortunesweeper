extends Node


# Common signals
signal sequence_started # Used for animated sequences that pause the game state
signal sequence_finished # Used for animated sequences that pause the game state

# Game Manager signals
signal level_ended

# Board signals
signal flag_counts_changed(hole_flags, gold_flags, diamond_flags)
signal board_completion_checked(complete)
signal revealed_hole(cell)
signal revealed_gold(cell)
signal revealed_diamond(cell)
signal hole_flagged_wrong
signal treasure_flagged_wrong
signal hole_flagged_right
signal gold_flagged_right
signal diamond_flagged_right
signal board_mined

# Interface signals
signal finish_button_pressed
