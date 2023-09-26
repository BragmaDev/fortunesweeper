extends Node


const BOARD_SCENE : PackedScene = preload("res://board/Board.tscn")
const LEVEL_1_BOARD_DATA : BoardData = preload("res://board/level_board_data/level_1.tres")
const LEVEL_2_BOARD_DATA : BoardData = preload("res://board/level_board_data/level_2.tres")
const LEVEL_3_BOARD_DATA : BoardData = preload("res://board/level_board_data/level_3.tres")
const LEVEL_4_BOARD_DATA : BoardData = preload("res://board/level_board_data/level_4.tres")

var _board : Board
var _current_level_data : BoardData
var _game_state : GameStateData = preload("res://common/game_state_data.tres")


func _ready() -> void:
	EventBus.connect("sequence_started", self, "_pause_game_state", [true])
	EventBus.connect("sequence_finished", self, "_pause_game_state", [false])
	EventBus.connect("revealed_hole", self, "_end_level")
	EventBus.connect("hole_flagged_wrong", self, "_add_to_money", [_game_state.HOLE_PENALTY / 2])
	EventBus.connect("gold_flagged_right", self, "_add_to_money", [_game_state.GOLD_VALUE])
	EventBus.connect("diamond_flagged_right", self, "_add_to_money", [_game_state.DIAMOND_VALUE])
	EventBus.connect("board_mined", self, "_finish_level")
	EventBus.connect("board_flags_changed", self, "_update_flag_counts")
	EventBus.connect("restart_button_pressed", self, "_reset")
	
	get_tree().set_pause(false)
	
	# Set up game state
	_game_state.level = 1
	_game_state.money = 0
	_game_state.time = 0.0
	_game_state.paused = false
	
	# Set up board
	_current_level_data = LEVEL_1_BOARD_DATA
	_create_board()
	EventBus.emit_signal("level_started")


func _physics_process(delta : float) -> void:
	# Run timer
	if not _game_state.paused:
		_game_state.time += delta


func _add_to_money(amount : int) -> void:
	if amount == 0:
		return
	
	_game_state.money += amount
	if amount > 0:
		EventBus.emit_signal("money_increased")
	else:
		EventBus.emit_signal("money_decreased")


func _create_board() -> void:
	_board = BOARD_SCENE.instance()
	_board.init_values(_current_level_data)
	add_child(_board)
	

# Handles premature level endings, i.e. from revealing a hole
func _end_level(cell : Cell) -> void:
	EventBus.emit_signal("sequence_started")
	EventBus.emit_signal("level_ended")
	
	_add_to_money(_game_state.HOLE_PENALTY)
	
	EffectManager.create_hole_circle_effect(cell.get_global_position() + Vector2(4, 4))
	yield(get_tree().create_timer(2.0, false), "timeout") # Wait until the circle effect ends
	
	_board.queue_free() # Free current board
	
	if _game_state.money < 0:
		# Game over
		return
	
	# Switch to the next level
	_game_state.level += 1
	_switch_level_data(_game_state.level)
	
	_create_board()
	EventBus.emit_signal("level_started")


# Handles the normal end of the level, i.e. from clicking the finish button
func _finish_level() -> void:
	EventBus.emit_signal("level_ended")
	
	# Deprecated - Calculate rewards and penalties
#	var correct_flags = _board.get_correct_flags()
#	for i in correct_flags["gold"]:
#		_add_to_money(_game_state.GOLD_VALUE)
#	for i in correct_flags["diamond"]:
#		_add_to_money(_game_state.DIAMOND_VALUE)
#	var incorrect_holes_count = _current_level_data.hole_count - correct_flags["hole"]
#	_add_to_money(_game_state.HOLE_PENALTY * incorrect_holes_count)
		
	_board.queue_free() # Free current board
	
	if _game_state.money < 0:
		# Game over
		return
	elif _game_state.money >= 1000000:
		# Game completed
		return
		
	# Switch to the next level
	_game_state.level += 1
	_switch_level_data(_game_state.level)
	
	_create_board()
	EventBus.emit_signal("level_started")


func _pause_game_state(paused : bool) -> void:
	_game_state.paused = paused


func _reset() -> void:
	# Set up game state
	_game_state.level = 1
	_game_state.money = 0
	_game_state.time = 0.0
	_game_state.paused = false
	
	get_tree().reload_current_scene()


func _switch_level_data(level : int) -> void:
	match level:
		1:
			_current_level_data = LEVEL_1_BOARD_DATA
		2:
			_current_level_data = LEVEL_2_BOARD_DATA
		3:
			_current_level_data = LEVEL_3_BOARD_DATA
		_:
			_current_level_data = LEVEL_4_BOARD_DATA


func _update_flag_counts() -> void:
	var flags_left = _board.get_flag_counts()
	_game_state.hole_flags_left = flags_left["hole"]
	_game_state.gold_flags_left = flags_left["gold"]
	_game_state.diamond_flags_left = flags_left["diamond"]
	EventBus.emit_signal("flag_counts_changed")
