extends Control


onready var hole_flag_label : Label = $FlagPanel/HoleFlagLabel
onready var gold_flag_label : Label = $FlagPanel/GoldFlagLabel
onready var diamond_flag_label : Label = $FlagPanel/DiamondFlagLabel


func _ready() -> void:
	EventBus.connect("flag_counts_changed", self, "_update_flag_labels")
	

func _update_flag_labels(hole_flags, gold_flags, diamond_flags) -> void:
	hole_flag_label.set_text(str(hole_flags))
	gold_flag_label.set_text(str(gold_flags))
	diamond_flag_label.set_text(str(diamond_flags))
