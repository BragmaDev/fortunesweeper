extends Node


func _ready() -> void:
	randomize()
	

func get_random_float(minimum : float, maximum : float) -> float:
	return rand_range(minimum, maximum)


# Returns random int
# Maximum is excluded from the range
func get_random_int(maximum : int) -> int:
	if maximum == 0:
		return 0
		
	return randi() % maximum
