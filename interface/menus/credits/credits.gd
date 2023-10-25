extends Control


signal closed

onready var back_button : ExtButton = $BackButton


func _ready() -> void:
	back_button.connect("pressed", self, "_on_back_pressed")


func _on_back_pressed() -> void:
	hide()
	emit_signal("closed")
