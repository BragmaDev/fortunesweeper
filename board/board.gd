extends Node2D


const CELL_SIZE : int = 8
const CELL_SCENE : PackedScene = preload("res://board/cell/Cell.tscn")

var size : int = 12

var _cells : Array = []
var _initiated : bool = false
var _hole_count : int
var _gold_count : int
var _diamond_count : int


func _ready() -> void:
	init_values(10, 10, 1)
	_create_cells()


# Initialize counts for filled cells
func init_values(hole_count: int, gold_count : int, diamond_count : int) -> void:
	_hole_count = hole_count
	_gold_count = gold_count
	_diamond_count = diamond_count


# Instance board cells
# Number of rows and columns is determined by the var 'size'
func _create_cells() -> void:
	for row in range(size):
		_cells.append([]) # Add new row
		for col in range(size):
			var cell : Cell = CELL_SCENE.instance()
			# Connect signals
			cell.connect("pressed", self, "_on_cell_pressed", [cell])
			cell.connect("flagged", self, "_on_cell_flagged", [cell])
			add_child(cell)
			cell.set_position(Vector2(CELL_SIZE * col, CELL_SIZE * row))
			_cells[row].append(cell)


func _on_cell_flagged(cell : Cell) -> void:
	pass


func _on_cell_pressed(cell : Cell) -> void:
	pass


func _place_contents() -> void:
	pass
