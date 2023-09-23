extends Node


func _ready() -> void:
	randomize()
	

func get_random_int(maximum : int) -> int:
	if maximum == 0:
		return 0
		
	return randi() % maximum
