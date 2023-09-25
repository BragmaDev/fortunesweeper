class_name BoardAnimator
extends Node


signal appear_animation_finished
signal disappear_animation_finished
signal mining_animation_finished
signal triggered_cell_mining(cell)

var _appear_tween_duration = 0.6
var _disappear_tween_duration = 1.0
var _mine_delay = 0.1


func start_appear_animation(cells : Array) -> void:
	EventBus.emit_signal("sequence_started")
	
	for i in range(0, cells.size()):
		for cell in cells[i]:
			# Move cells up	
			cell.set_position(cell.get_position() - Vector2(0, 150))
	
	for n in range(0, cells.size()):
		for m in cells[n].size():
			var cell = cells[n][m]
			var final_pos = cell.get_position() + Vector2(0, 150)
			var timer = get_tree().create_timer(0.1 * (cells.size() - n + 1), false)
			timer.connect("timeout", self, "_tween_cell_to_position", [cell, final_pos, _appear_tween_duration])
	
	# Start finishing timer
	var timer = get_tree().create_timer(0.1 * (cells.size() + 1) + _appear_tween_duration)
	timer.connect("timeout", self, "emit_signal", ["appear_animation_finished"])
	timer.connect("timeout", EventBus, "emit_signal", ["sequence_finished"])


func start_disappear_animation(cells : Array) -> void:
	EventBus.emit_signal("sequence_started")
	
	for n in range(0, cells.size()):
		for m in cells[n].size():
			var cell = cells[n][m]
			var final_pos = cell.get_position() - Vector2(150, 0)
			var timer = get_tree().create_timer(0.07 * (n + m + 1), false)
			timer.connect("timeout", self, "_tween_cell_to_position", [cell, final_pos, _disappear_tween_duration])
	
	# Start finishing timer
	var timer = get_tree().create_timer(0.07 * (2 * cells.size() + 1) + _disappear_tween_duration)
	timer.connect("timeout", self, "emit_signal", ["disappear_animation_finished"])


func start_mining_animation(cells : Array) -> void:
	EventBus.emit_signal("sequence_started")
	
	# Put flagged cells into a separate array
	var flagged_cells = []
	for row in cells.size():
		for col in cells[row].size():
			if not cells[row][col].get_flag() == Cell.Flags.NONE:
				flagged_cells.append(cells[row][col])
	
	# Start a timer for mining each cell
	for i in flagged_cells.size():
		var timer = get_tree().create_timer(_mine_delay * i, false)
		timer.connect("timeout", self, "emit_signal", ["triggered_cell_mining", flagged_cells[i]])
	
	# Start finishing timer
	var timer = get_tree().create_timer(_mine_delay * flagged_cells.size() + 1.0)
	timer.connect("timeout", self, "emit_signal", ["mining_animation_finished"])


func _tween_cell_to_position(cell : Cell, pos : Vector2, duration : float) -> void:
	var tween = create_tween().set_trans(Tween.TRANS_QUART)
	tween.tween_property(cell, "position", pos, duration)
