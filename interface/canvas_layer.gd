extends CanvasLayer


onready var pause_menu : Control = $PauseMenu


func _ready() -> void:
	EventBus.connect("sequence_started", self, "_toggle_mouse_blocker", [true])
	EventBus.connect("sequence_finished", self, "_toggle_mouse_blocker", [false])


func _process(_delta : float) -> void:
	if Input.is_action_just_pressed("pause"):
		pause_menu.set_visible(not pause_menu.is_visible())
		get_tree().set_pause(pause_menu.is_visible())


func _toggle_mouse_blocker(enabled : bool) -> void:
	if enabled:
		$MouseBlocker.set_mouse_filter(Control.MOUSE_FILTER_STOP)
	else:
		$MouseBlocker.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
