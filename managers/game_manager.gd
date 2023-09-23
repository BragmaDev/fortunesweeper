extends Node


const BOARD_SCENE : PackedScene = preload("res://board/Board.tscn")
const LEVEL_1_BOARD_DATA : BoardData = preload("res://board/level_board_data/level_1.tres")
const LEVEL_2_BOARD_DATA : BoardData = preload("res://board/level_board_data/level_2.tres")

var _board : Board


func _ready() -> void:
	EventBus.connect("finish_button_pressed", self, "_end_level")
	
	# Set up board
	_board = BOARD_SCENE.instance()
	_board.init_values(LEVEL_1_BOARD_DATA)
	add_child(_board)


func _end_level() -> void:
	_board.check_correct_flags()
	_board.queue_free() # Free current board
	
	_board = BOARD_SCENE.instance() # Instantiate new board
	_board.init_values(LEVEL_2_BOARD_DATA)
	add_child(_board)
