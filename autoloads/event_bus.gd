extends Node


# Board signals
signal flag_counts_changed(hole_flags, gold_flags, diamond_flags)
signal board_completion_checked(complete)

# Interface signals
signal finish_button_pressed
