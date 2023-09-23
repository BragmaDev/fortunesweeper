extends Area2D
class_name Cell


signal pressed # Left-click
signal flagged # User-initiated flag changes
signal flag_changed # Automatic flag changes

enum Types {EMPTY, HOLE, GOLD, DIAMOND}
enum Flags {NONE, HOLE, GOLD, DIAMOND}
enum States {UNREVEALED, REVEALED}

const NUMBER_COLORS = {
	"hole": Color("e27285"),
	"gold": Color("f8c53a"),
	"diamond": Color("d0ffea")
}

var row : int
var col : int

var _filled_nb_count : int # Count of filled neigbor cells
var _type : int = Types.EMPTY
var _state : int = States.UNREVEALED
var _flag : int = Flags.NONE
var _neighbors : Array = []

onready var sprite : AnimatedSprite = $AnimatedSprite
onready var content_sprite : AnimatedSprite = $ContentSprite
onready var flag_sprite : AnimatedSprite = $FlagSprite
onready var number_label : Label = $NumberLabel


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


func get_filled_nb_count() -> int:
	return _filled_nb_count


func get_flag() -> int:
	return _flag


func get_neighbors() -> Array:
	return _neighbors


func get_type() -> int:
	return _type


func set_flag(flag : int) -> void:
	_flag = flag


func set_neighbors(neighbors : Array) -> void:
	_neighbors = neighbors


func set_row_and_column(row : int, col : int) -> void:
	self.row = row
	self.col = col


func set_state(state : int) -> void:
	_state = state
	if _state == States.UNREVEALED:
		sprite.set_animation("unrevealed")
		
	elif _state == States.REVEALED:
		sprite.set_animation("revealed")
		# Remove flag automatically
		set_flag(Flags.NONE)
		emit_signal("flag_changed")
		
	# Set content sprite if filled
	if _type == Types.HOLE:
		content_sprite.set_animation("hole")
		return
		
	elif _type == Types.GOLD:
		content_sprite.set_animation("gold")
		return
		
	elif _type == Types.DIAMOND:
		content_sprite.set_animation("diamond")
		return
	
	# Update filled neighbor count
	_filled_nb_count = 0
	for neighbor in _neighbors:
		if not neighbor.get_type() == Types.EMPTY:
			_filled_nb_count += 1

	# Update number label
	if not _filled_nb_count == 0: 
		number_label.set_text(str(_filled_nb_count))
		# Set color
		number_label.set("custom_colors/font_color", NUMBER_COLORS["hole"])
		for neighbor in _neighbors:
			if neighbor.get_type() == Types.DIAMOND:
				number_label.set("custom_colors/font_color", NUMBER_COLORS["diamond"])
				break
			
			elif neighbor.get_type() == Types.GOLD:
				number_label.set("custom_colors/font_color", NUMBER_COLORS["gold"])
	else:
		number_label.set_text("")
	

func set_type(type : int) -> void:
	_type = type



