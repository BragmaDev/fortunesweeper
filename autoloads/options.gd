extends Node


const CONFIG_PATH: String = "user://config.ini"

var sound_volume : float = 0.1


func _ready() -> void:
	# Load settings from disk
	load_config(CONFIG_PATH)


func load_config(path: String) -> void:
	var config = ConfigFile.new()
	if not path == "":
		var error_msg = config.load(path)
		if not error_msg == OK:
			push_warning("Reading the options file failed, creating new config...")
			load_config("")
			save_config()
			return
		
	set_sound_volume(config.get_value("audio", "sound_volume", 0.1))


func save_config() -> void:
	var config = ConfigFile.new()
	
	config.set_value("audio", "sound_volume", sound_volume)
	
	var error_msg = config.save(CONFIG_PATH)
	if not error_msg == OK:
		push_warning("Writing the options file failed.")


# 'value': 0.0 - 1.0
func set_sound_volume(value : float) -> void:
	sound_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(sound_volume))
