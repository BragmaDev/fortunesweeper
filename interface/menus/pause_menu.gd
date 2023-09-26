extends Control


func _ready() -> void:
	$CenterContainer/VBoxContainer/RestartButton.connect("pressed", self, "_on_restart_pressed")


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
