extends Node


var sound_volume : float = 0.1


# 'value': 0 - 100
func set_sound_volume(value : float) -> void:
	var normalized = value / 100.0
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(normalized))
