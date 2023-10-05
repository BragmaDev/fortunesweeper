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
var _game_state : GameStateData = preload("res://common/game_state_data.tres")

onready var animator : BoardAnimator = $BoardAnimator


func _ready() -> void:
	EventBus.connect("finish_button_pressed", animator, "start_mining_animation", [_cells])
	animator.connect("mining_animation_finished", animator, "start_disappear_animation", [_cells])
	animator.connect("disappear_animation_finished", EventBus, "emit_signal", ["board_mined"])
	animator.connect("triggered_cell_mining", self, "_mine_cell")
	
	set_global_position(_pos_offset)
	_create_cells()
	EventBus.emit_signal("board_flags_changed")
	animator.start_appear_animation(_cells)


# Initializes counts for filled cells
func init_values(data : BoardData) -> void:
	_size = data.size
	_pos_offset = data.pos_offset
	_hole_count = data.hole_count
	_gold_count = data.gold_count
	_diamond_count = data.diamond_count


# Checks how many cells have been correctly flagged
# Returns a dictionary with separate counts for each flag type
func get_correct_flags() -> Dictionary:
	var correct_flags = {"hole": 0, "gold": 0, "diamond": 0}
	
	for row in _size:
		for col in _size:
			var cell = _cells[row][col]
			if cell.get_type() == Cell.Types.HOLE and cell.get_flag() == Cell.Flags.HOLE:
				correct_flags["hole"] += 1
			
			if cell.get_type() == Cell.Types.GOLD and cell.get_flag() == Cell.Flags.GOLD:
				correct_flags["gold"] += 1
			
			if cell.get_type() == Cell.Types.DIAMOND and cell.get_flag() == Cell.Flags.DIAMOND:
				correct_flags["diamond"] += 1
	
	return correct_flags


# Counts how many instances of specifics flags are left and returns a dictionary
func get_flag_counts() -> Dictionary:
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
	
	return {"hole": hole_flags, "gold": gold_flags, "diamond": diamond_flags}


# Checks if any of the cells is still unrevealed and unflagged
func _check_completion() -> bool:
	for row in _size:
		for col in _size:
			var cell = _cells[row][col]
			if cell.get_state() == Cell.States.UNREVEALED and cell.get_flag() == Cell.Flags.NONE:
				EventBus.emit_signal("board_completion_checked", false)
				return false
				
	EventBus.emit_signal("board_completion_checked", true)
	return true


# Instances board cells
# Number of rows and columns is determined by the var '_size'
func _create_cells() -> void:
	for row in _size:
		_cells.append([]) # Add new row
		for col in _size:
			var cell : Cell = CELL_SCENE.instance()
			cell.set_row_and_column(row, col)
			# Connect signals
			cell.connect("pressed", self, "_on_cell_pressed", [cell])
			cell.connect("chorded", self, "_on_cell_chorded", [cell])
			cell.connect("flagged", self, "_on_cell_flagged", [cell])
			cell.connect("flag_changed", EventBus, "emit_signal", ["board_flags_changed"])
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


func _mine_cell(cell : Cell) -> void:
	cell.set_state(Cell.States.MINED)
	
	# Incorrectly flagged hole cell
	if cell.get_type() == Cell.Types.HOLE and not cell.get_flag() == Cell.Flags.HOLE:
		EffectManager.create_text_popup(
				cell.global_position + Vector2(4, 0), 
				Formatter.format_money_string(_game_state.HOLE_MINE_PENALTY), 
				Colors.RED
		)
		EventBus.emit_signal("hole_flagged_wrong")
	
	# Incorrectly flagged gold cell
	elif cell.get_type() == Cell.Types.GOLD and not cell.get_flag() == Cell.Flags.GOLD:
		AudioManager.play("buzzer")

	# Incorrectly flagged diamond cell
	elif cell.get_type() == Cell.Types.DIAMOND and not cell.get_flag() == Cell.Flags.DIAMOND:
		AudioManager.play("buzzer")
	
	# Correctly flagged hole cell
	elif cell.get_type() == Cell.Types.HOLE and cell.get_flag() == Cell.Flags.HOLE:
		pass
	
	# Correctly flagged gold cell
	elif cell.get_type() == Cell.Types.GOLD and cell.get_flag() == Cell.Flags.GOLD:
		EffectManager.create_text_popup(
				cell.global_position + Vector2(4, 0), 
				Formatter.format_money_string(_game_state.GOLD_VALUE), 
				Colors.YELLOW
		)
		EventBus.emit_signal("gold_flagged_right")
	
	# Correctly flagged diamond cell
	elif cell.get_type() == Cell.Types.DIAMOND and cell.get_flag() == Cell.Flags.DIAMOND:
		EffectManager.create_text_popup(
				cell.global_position + Vector2(4, 0), 
				Formatter.format_money_string(_game_state.DIAMOND_VALUE), 
				Colors.LIGHT_BLUE
		)
		EventBus.emit_signal("diamond_flagged_right")


func _on_cell_chorded(cell : Cell) -> void:
	if not cell.get_type() == Cell.Types.EMPTY:
		return
	
	# Check that neighboring cells have the correct number of flags placed
	# Revealed filled neighbors count as well
	var flagged_neighbors = 0
	var revealed_filled_neighbors = 0
	for neighbor in cell.get_neighbors():
		if not neighbor.get_flag() == Cell.Flags.NONE:
			flagged_neighbors += 1
		elif not neighbor.get_type() == Cell.Types.EMPTY and neighbor.get_state() == Cell.States.REVEALED:
			revealed_filled_neighbors += 1
	
	if flagged_neighbors + revealed_filled_neighbors == cell.get_filled_nb_count():
		# Reveal all surrounding cells that aren't flagged
		for neighbor in cell.get_neighbors():
			if (
					neighbor.get_state() == Cell.States.UNREVEALED 
					and neighbor.get_flag() == Cell.Flags.NONE
			):
				_reveal_cell(neighbor)
	
	_check_completion()


func _on_cell_flagged(cell : Cell) -> void:
	var flag = cell.get_flag()
	
	# Cycle through flag types and apply the next available one
	# If no flags are available, remove the flag
	while flag <= Cell.Flags.size():
		flag += 1
		
		if flag == Cell.Flags.HOLE and _game_state.hole_flags_left > 0:
			cell.set_flag(Cell.Flags.HOLE)
			break
		
		elif flag == Cell.Flags.GOLD and _game_state.gold_flags_left > 0:
			cell.set_flag(Cell.Flags.GOLD)
			break
		
		elif flag == Cell.Flags.DIAMOND and _game_state.diamond_flags_left > 0:
			cell.set_flag(Cell.Flags.DIAMOND)
			break
		
		elif flag >= Cell.Flags.size():
			cell.set_flag(Cell.Flags.NONE)
	
	EventBus.emit_signal("board_flags_changed")
	_check_completion()


func _on_cell_pressed(cell : Cell) -> void:
	_reveal_cell(cell)
	_check_completion()


# Generates positions for filled cells and sets their types
# protected_cells: Array of cells that must be empty
func _place_contents(protected_cells : Array) -> void:
	# Check that there is enough room
	if _hole_count + _gold_count + _diamond_count >= _size * _size - len(protected_cells):
		push_error("Contents cannot fit on the board.")
		return
	
	# Create array of free cell positions
	var free_cells = []
	for row in _size:
		for col in _size:
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
		
		if current.get_type() == Cell.Types.HOLE:
			_hole_count -= 1
			EventBus.emit_signal("board_flags_changed")
			EventBus.emit_signal("revealed_hole", current)
			EffectManager.create_text_popup(
					current.global_position + Vector2(4, 0), 
					Formatter.format_money_string(_game_state.HOLE_PENALTY), 
					Colors.RED
			)
			return
		
		elif current.get_type() == Cell.Types.GOLD:
			_gold_count -= 1
			EventBus.emit_signal("board_flags_changed")
			AudioManager.play("buzzer")
			return
			
		elif current.get_type() == Cell.Types.DIAMOND:
			_diamond_count -= 1
			EventBus.emit_signal("board_flags_changed")
			AudioManager.play("buzzer")
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


func _update_neighbor_arrays() -> void:
	for row in _size:
		for col in _size:
			var cell = _cells[row][col]
			cell.set_neighbors(_get_cell_neighbors(cell.row, cell.col))
