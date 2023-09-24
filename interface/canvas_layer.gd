extends CanvasLayer


func _ready() -> void:
	EventBus.connect("sequence_started", self, "_toggle_mouse_blocker", [true])
	EventBus.connect("sequence_finished", self, "_toggle_mouse_blocker", [false])


func _toggle_mouse_blocker(enabled : bool) -> void:
	if enabled:
		$MouseBlocker.set_mouse_filter(Control.MOUSE_FILTER_STOP)
	else:
		$MouseBlocker.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
