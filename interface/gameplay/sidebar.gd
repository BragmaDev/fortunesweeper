extends Control


var _game_state : GameStateData = preload("res://common/game_state_data.tres")

onready var timer_label : Label = $TimerLabel
onready var money_label : Label = $MoneyLabel
onready var hole_flag_label : Label = $FlagPanel/HoleFlagLabel
onready var gold_flag_label : Label = $FlagPanel/GoldFlagLabel
onready var diamond_flag_label : Label = $FlagPanel/DiamondFlagLabel
onready var finish_button : TextureButton = $FinishButton
onready var anim : AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	EventBus.connect("flag_counts_changed", self, "_update_flag_labels")
	EventBus.connect("board_completion_checked", self, "_toggle_finish_button")
	EventBus.connect("sequence_started", self, "_toggle_finish_button", [false])
	EventBus.connect("level_ended", self, "_toggle_finish_button", [false])
	EventBus.connect("money_increased", self, "_update_money_label", [true, true])
	EventBus.connect("money_decreased", self, "_update_money_label", [true, false])
	EventBus.connect("game_state_reset", self, "_update_money_label", [false])
	
	_update_money_label(false)
	_toggle_finish_button(false)
	finish_button.connect("pressed", EventBus, "emit_signal", ["finish_button_pressed"])


func _physics_process(_delta : float) -> void:
	# Update timer label
	timer_label.set_text(Formatter.format_time_string(_game_state.time))


func _toggle_finish_button(enabled : bool) -> void:
	# Disable button and return immediately if the game is over
	if _game_state.game_over:
		finish_button.set_disabled(true)
		return
	
	finish_button.set_disabled(!enabled)


func _update_flag_labels() -> void:
	hole_flag_label.set_text(str(_game_state.hole_flags_left))
	gold_flag_label.set_text(str(_game_state.gold_flags_left))
	diamond_flag_label.set_text(str(_game_state.diamond_flags_left))


func _update_money_label(animated : bool, increased : bool = true) -> void:
	var string = Formatter.format_money_string(_game_state.money)
	money_label.set_text(string)
	anim.stop()
	if not animated:
		return
		
	if increased:
		anim.play("nudge_money_label_up")
	else:
		anim.play("nudge_money_label_down")
