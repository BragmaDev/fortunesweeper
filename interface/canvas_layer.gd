extends CanvasLayer


var _game_state : GameStateData = preload("res://common/game_state_data.tres")

onready var anim : AnimationPlayer = $AnimationPlayer
onready var transition : TransitionRect = $TransitionRect


func _ready() -> void:
	EventBus.connect("sequence_started", self, "_toggle_mouse_blocker", [true])
	EventBus.connect("sequence_finished", self, "_toggle_mouse_blocker", [false])
	EventBus.connect("level_started", anim, "play", ["show_level_sign"])

	transition.start_transition_in()


func _toggle_mouse_blocker(enabled : bool) -> void:
	if enabled:
		$MouseBlocker.set_mouse_filter(Control.MOUSE_FILTER_STOP)
	else:
		$MouseBlocker.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)


func _update_level_sign() -> void:
	$LevelSign/Label.set_text("LEVEL " + str(_game_state.level))
