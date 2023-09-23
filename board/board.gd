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


# Initializes counts for filled cells
func init_values(data : BoardData) -> void:
	_size = data.size
	_pos_offset = data.pos_offset
	_hole_count = data.hole_count
	_gold_count = data.gold_count
	_diamond_count = data.diamond_count


# Instances board cells
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
			cell.connect("flag_changed", self, "_update_flag_counts")
			add_child(cell)
			cell.set_position(Vector2(CELL_SIZE * col, CELL_SIZE * row))
			_cells[row].append(cell)


# Returns array of neighboring cells at position (row, col)
func _get_cell_neighbors(row : int, col : int) -> Array:
	var neighbors = []
	
	if col > 0: # Left
		neighbors.append(_cells[row][col - 1])
		
	if col < _size - 1: # Right
		neighbors.append(_cells[row][col + 1])
		
	if row > 0: # Up
		neighbors.append(_cells[row - 1][col])
		
	if row < _size - 1: # Down
		neighbors.append(_cells[row + 1][col])
		
	if col > 0 and row > 0: # Up-left
		neighbors.append(_cells[row - 1][col - 1])
		
	if col < _size - 1 and row > 0: # Up-right
		neighbors.append(_cells[row - 1][col + 1])
		
	if col > 0 and row < _size - 1: # Down-left
		neighbors.append(_cells[row + 1][col - 1])
		
	if col < _size - 1 and row < _size - 1: # Down-right
		neighbors.append(_cells[row + 1][col + 1])
	
	return neighbors


func _on_cell_flagged(cell : Cell) -> void:
	if cell.get_flag() == Cell.Flags.NONE:
		cell.set_flag(Cell.Flags.HOLE)
	
	elif cell.get_flag() == Cell.Flags.HOLE:
		cell.set_flag(Cell.Flags.GOLD)
	
	elif cell.get_flag() == Cell.Flags.GOLD:
		cell.set_flag(Cell.Flags.DIAMOND)
	
	elif cell.get_flag() == Cell.Flags.DIAMOND:
		cell.set_flag(Cell.Flags.NONE)
	
	_update_flag_counts()


func _on_cell_pressed(cell : Cell) -> void:
	_reveal_cell(cell)


# Generates positions for filled cells and sets their types
# protected_cells: Array of cells that must be empty
func _place_contents(protected_cells : Array) -> void:
	# Check that there is enough room
	if _hole_count + _gold_count + _diamond_count >= _size * _size - len(protected_cells):
		push_error("Contents cannot fit on the board.")
		return
	
	# Create array of free cell positions
	var free_cells = []
	for row in range(_size):
		for col in range(_size):
			var cell = _cells[row][col]
			if cell.get_type() == Cell.Types.EMPTY and not cell in protected_cells:
				free_cells.append(cell)
	
	# Place holes
	for i in _hole_count:
		var cell = free_cells[RNG.get_random_int(len(free_cells) - 1)]
		cell.set_type(Cell.Types.HOLE)
		free_cells.erase(cell)
	
	# Place gold
	for i in _gold_count:
		var cell = free_cells[RNG.get_random_int(len(free_cells) - 1)]
		cell.set_type(Cell.Types.GOLD)
		free_cells.erase(cell)
	
	# Place diamonds
	for i in _diamond_count:
		var cell = free_cells[RNG.get_random_int(len(free_cells) - 1)]
		cell.set_type(Cell.Types.DIAMOND)
		free_cells.erase(cell)


func _reveal_cell(cell : Cell) -> void:
	# Set up board if this is the first click
	if not _initiated:
		# Establish protected cells that must be empty
		var protected_cells = _get_cell_neighbors(cell.row, cell.col)
		protected_cells.append(cell)
		_place_contents(protected_cells)
		_update_neighbor_arrays()
		_initiated = true
	
	var queue = [cell] # Queue for cells to reveal
	var visited = [cell]
	
	while not queue.empty():
		var current = queue.pop_front()
		current.set_state(Cell.States.REVEALED)
		
		if not current.get_type() == Cell.Types.EMPTY:
			return
		
		# Add surrounding empty cells to reveal queue
		if current.get_filled_nb_count() == 0:
			var neighbors = current.get_neighbors()
			for neighbor in neighbors:
				if neighbor in visited:
					continue
				
				if neighbor.get_type() == Cell.Types.EMPTY:
					queue.push_back(neighbor)
				
				visited.append(neighbor)


# Counts how many instances of specifics flags are left
# Emits an EventBus signal with the results
func _update_flag_counts() -> void:
	var hole_flags = _hole_count
	var gold_flags = _gold_count
	var diamond_flags = _diamond_count
	
	for row in _size:
		for col in _size:
			if _cells[row][col].get_flag() == Cell.Flags.HOLE:
				hole_flags -= 1
			elif _cells[row][col].get_flag() == Cell.Flags.GOLD:
				gold_flags -= 1
			elif _cells[row][col].get_flag() == Cell.Flags.DIAMOND:
				diamond_flags -= 1
	
	EventBus.emit_signal("flag_counts_changed", hole_flags, gold_flags, diamond_flags)


func _update_neighbor_arrays() -> void:
	for row in range(_size):
		for col in range(_size):
			var cell = _cells[row][col]
			cell.set_neighbors(_get_cell_neighbors(cell.row, cell.col))
