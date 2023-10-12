extends Node


var sfx = {
		"buzzer": "res://sfx/buzzer.wav",
		"cell_reveal": "res://sfx/cell_reveal.wav",
		"confirm": "res://sfx/confirm.wav",
		"flag": "res://sfx/flag.wav",
		"hole_fall": "res://sfx/hole_fall2.wav",
		"hover": "res://sfx/hover.wav",
		"money_increase": "res://sfx/money_increase.wav",
}

var _sfx_bus : String = "SFX"
var _pool = []


func _ready() -> void:
	set_pause_mode(PAUSE_MODE_PROCESS)
	
	# Populate '_pool' with dictionaries containing AudioStreamPlayer nodes and sfx names
	for sound in sfx:
		# Set up AudioStreamPlayer
		var player = AudioStreamPlayer.new()
		add_child(player)
		player.set_bus(_sfx_bus)
		player.set_stream(load(sfx[sound]))
		
		_pool.append({"player": player, "sound": sound})


# Plays a sound effect
func play(
		sound_name : String, # Name of the sound to play
		volume : float = 1.0, # Volume from 0.0 to 1.0
		random_pitch : bool = true, # Alter the pitch slightly in a random direction
		pitch_change : float = 0.0 # Alter the pitch directly
) -> void:
	# Find player with the correct sound name
	var player
	for dict in _pool:
		if dict["sound"] == sound_name: 
			player = dict["player"]
	
	if player == null:
		push_error("Cannot find sound with that name.")
		return
	
	player.set_volume_db(linear2db(volume))
	var pitch = 1.0 + int(random_pitch) * RNG.get_random_float(-0.1, 0.1) + pitch_change
	player.set_pitch_scale(pitch)
	
	player.play()
	
