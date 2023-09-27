extends Node


const PATH : String = "user://save_data.bin"

var best_time : float = -1.0

var _game_state : GameStateData = preload("res://common/game_state_data.tres")


func _init() -> void:
	load_save_data()


func _ready() -> void:
	EventBus.connect("game_won", self, "update_records")


func get_best_time() -> float:
	return best_time


# Loads save data from a binary file
func load_save_data() -> void:
	var save_data = {}
	var file = File.new()
	
	if file.open(PATH, File.READ) == OK:
		save_data = bytes2var(file.get_buffer(256))
		file.close()
	
	else:
		push_warning("Reading save data failed, creating new save file...")
		write_save_data()
		return
	
	best_time = save_data.get("best_time", -1.0)


func set_best_time(time : float) -> void:
	best_time = time


func update_records() -> void:
	if best_time == -1 or best_time > _game_state.time:
		set_best_time(_game_state.time)
		write_save_data()


# Writes save data object to a binary file
func write_save_data() -> void:
	var save_data = {}
	save_data["best_time"] = best_time
	
	var file = File.new()
	if file.open(PATH, File.WRITE) == OK:
		file.store_buffer(var2bytes(save_data))
		file.close()
	
	else:
		push_error("Writing save data failed.")









