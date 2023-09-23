extends Node2D
class_name Board


const CELL_SIZE : int = 8
const CELL_SCENE : PackedScene = preload("res://board/cell/Cell.tscn")

var _size : int
var _pos_offset : Vector2
var _cells : Array = []
var _initiated : bool = false
var _hole_count : int
var _gold_count : int
var _diamond_count : int


func _ready() -> void:
	set_global_position(_pos_offset)
	_create_cells()


# Initialize counts for filled cells
func init_values(data : BoardData) -> void:
	_size = data.size
	_pos_offset = data.pos_offset
	_hole_count = data.hole_count
	_gold_count = data.gold_count
	_diamond_count = data.diamond_count


# Instance board cells
# Number of rows and columns is determined by the var '_size'
func _create_cells() -> void:
	for row in range(_size):
		_cells.append([]) # Add new row
		for col in range(_size):
			var cell : Cell = CELL_SCENE.instance()
			cell.set_row_and_column(row, col)
			# Connect signals
			cell.connect("pressed", self, "_on_cell_pressed", [cell])
			cell.connect("flagged", self, "_on_cell_flagged", [cell])
			add_child(cell)
			cell.set_position(Vector2(CELL_SIZE * col, CELL_SIZE * row))
			_cells[row].append(cell)


func _on_cell_flagged(cell : Cell) -> void:
	pass


func _on_cell_pressed(cell : Cell) -> void:
	print(cell._row, " ", cell._col)


func _place_contents() -> void:
	pass
