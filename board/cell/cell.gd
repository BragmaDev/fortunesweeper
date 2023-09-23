extends Area2D
class_name Cell


enum Types {
	EMPTY,
	HOLE,
	GOLD,
	DIAMOND
}
enum Flags {
	NONE,
	HOLE,
	GOLD,
	DIAMOND
}
enum States {
	UNREVEALED,
	REVEALED
}

signal pressed
signal flagged

var _row : int
var _col : int
var _filled_nb_count : int # Count of filled neigbor cells
var _type : int = Types.EMPTY
var _state : int = States.UNREVEALED
var _flag : int = Flags.NONE
var _neighbors : Array = []

onready var sprite : AnimatedSprite = $AnimatedSprite
onready var content_sprite : AnimatedSprite = $ContentSprite
onready var flag_sprite : AnimatedSprite = $FlagSprite


func _input_event(_viewport, event, _shape_idx) -> void:
	# Check if the cell was pressed
	if (
			event is InputEventMouseButton
			and event.get_button_index() == BUTTON_LEFT
			and event.is_pressed()
	):
		emit_signal("pressed")
	# Check if the cell was flagged by the player
	elif (
			event is InputEventMouseButton
			and event.get_button_index() == BUTTON_RIGHT
			and event.is_pressed()
			and _state == States.UNREVEALED
	):
		emit_signal("flagged")


func set_row_and_column(row : int, col : int) -> void:
	_row = row
	_col = col


func set_neighbors(neighbors : Array) -> void:
	_neighbors = neighbors


func get_neighbors() -> Array:
	return _neighbors


func set_type(type : int) -> void:
	_type = type


func get_type() -> int:
	return _type
