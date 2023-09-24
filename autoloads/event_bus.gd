extends Node


# Game Manager signals
signal level_ended

# Board signals
signal flag_counts_changed(hole_flags, gold_flags, diamond_flags)
signal board_completion_checked(complete)
signal revealed_hole(cell)
signal revealed_gold(cell)
signal revealed_diamond(cell)

# Interface signals
signal finish_button_pressed
