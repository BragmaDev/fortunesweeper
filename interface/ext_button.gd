class_name ExtButton
extends Button


var _hovered := false


func _ready() -> void:
	connect("pressed", AudioManager, "play", ["confirm", 1.0, false])
	connect("mouse_entered", self, "_play_sound", ["hover"])


func _play_sound(sound_name : String) -> void:
	if not disabled:
		AudioManager.play(sound_name, 1.0, false)
