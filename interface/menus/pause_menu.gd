extends Control


func _ready() -> void:
	$CenterContainer/VBoxContainer/RestartButton.connect("pressed", EventBus, "emit_signal", ["restart_button_pressed"])
