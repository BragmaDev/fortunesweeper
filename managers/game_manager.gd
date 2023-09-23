extends Node


const BOARD_SCENE : PackedScene = preload("res://board/Board.tscn")
const LEVEL_1_BOARD_DATA : BoardData = preload("res://board/level_board_data/level_1.tres")
const LEVEL_2_BOARD_DATA : BoardData = preload("res://board/level_board_data/level_2.tres")
const LEVEL_3_BOARD_DATA : BoardData = preload("res://board/level_board_data/level_3.tres")

var _board : Board
var _current_level_data : BoardData
var _game_state : GameStateData = preload("res://common/game_state_data.tres")


func _ready() -> void:
	EventBus.connect("finish_button_pressed", self, "_end_level")
	
	# Set up game state
	_game_state.level = 1
	_game_state.money = 0
	_game_state.time = 0.0
	_game_state.paused = false
	
	# Set up board
	_current_level_data = LEVEL_1_BOARD_DATA
	_board = BOARD_SCENE.instance()
	_board.init_values(_current_level_data)
	add_child(_board)


func _physics_process(delta : float) -> void:
	# Run timer
	if not _game_state.paused:
		_game_state.time += delta


func _end_level() -> void:
	# Calculate rewards
	var correct_flags = _board.get_correct_flags()
	for i in correct_flags["gold"]:
		_game_state.money += 15000
	for i in correct_flags["diamond"]:
		_game_state.money += 60000
		
	_board.queue_free() # Free current board
	
	# Switch to the next level
	_game_state.level += 1
	_switch_level_data(_game_state.level)
	
	_board = BOARD_SCENE.instance() # Instantiate new board
	_board.init_values(_current_level_data)
	add_child(_board)
	EventBus.emit_signal("level_ended")


func _switch_level_data(level : int) -> void:
	match level:
		1:
			_current_level_data = LEVEL_1_BOARD_DATA
		2:
			_current_level_data = LEVEL_2_BOARD_DATA
		_:
			_current_level_data = LEVEL_3_BOARD_DATA
