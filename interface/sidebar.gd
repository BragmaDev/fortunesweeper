extends Control


var _game_state : GameStateData = preload("res://common/game_state_data.tres")

onready var timer_label : Label = $TimerLabel
onready var money_label : Label = $MoneyLabel
onready var hole_flag_label : Label = $FlagPanel/HoleFlagLabel
onready var gold_flag_label : Label = $FlagPanel/GoldFlagLabel
onready var diamond_flag_label : Label = $FlagPanel/DiamondFlagLabel
onready var finish_button : TextureButton = $FinishButton


func _ready() -> void:
	EventBus.connect("flag_counts_changed", self, "_update_flag_labels")
	EventBus.connect("board_completion_checked", self, "_toggle_finish_button")
	EventBus.connect("level_ended", self, "_toggle_finish_button", [false])
	
	_toggle_finish_button(false)
	finish_button.connect("pressed", EventBus, "emit_signal", ["finish_button_pressed"])


func _physics_process(_delta : float) -> void:
	# Update timer label
	timer_label.set_text(Formatter.format_time_string(_game_state.time))
	
	# Update money label
	money_label.set_text(Formatter.format_money_string(_game_state.money))


func _toggle_finish_button(enabled : bool) -> void:
	finish_button.set_disabled(!enabled)


func _update_flag_labels(hole_flags, gold_flags, diamond_flags) -> void:
	hole_flag_label.set_text(str(hole_flags))
	gold_flag_label.set_text(str(gold_flags))
	diamond_flag_label.set_text(str(diamond_flags))
