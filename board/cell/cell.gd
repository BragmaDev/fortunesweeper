extends Area2D
class_name Cell


signal pressed # Left-click
signal chorded # Middle-click
signal flagged # User-initiated flag changes, i.e. right-click
signal flag_changed # Automatic flag changes

enum Types {EMPTY, HOLE, GOLD, DIAMOND}
enum Flags {NONE, HOLE, GOLD, DIAMOND}
enum States {UNREVEALED, REVEALED, MINED}

var row : int
var col : int

var _filled_nb_count : int # Count of filled neigbor cells
var _type : int = Types.EMPTY
var _state : int = States.UNREVEALED
var _flag : int = Flags.NONE
var _neighbors : Array = []

onready var sprite : AnimatedSprite = $AnimatedSprite
onready var content_bg_sprite : AnimatedSprite = $ContentBGSprite
onready var content_sprite : AnimatedSprite = $ContentSprite
onready var flag_sprite : AnimatedSprite = $FlagSprite
onready var number_sprite : AnimatedSprite = $NumberSprite
onready var sparkle : AnimatedSprite = $Sparkle
onready var particles : CPUParticles2D = $CPUParticles2D
onready var anim : AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	number_sprite.set_animation("none")
	sparkle.play("default")
	sparkle.set_visible(false) # Make sparkle invisible


func _input_event(_viewport, event, _shape_idx) -> void:
	# Check if the cell was pressed
	if (
			event is InputEventMouseButton
			and event.get_button_index() == BUTTON_LEFT
			and not event.is_pressed()
			and _state == States.UNREVEALED
	):
		emit_signal("pressed")
	
	# Check if the cell was chorded
	elif (
			event is InputEventMouseButton
			and (event.get_button_index() == BUTTON_MIDDLE or event.get_button_index() == BUTTON_LEFT)
			and not event.is_pressed()
			and _state == States.REVEALED
	):
		emit_signal("chorded")
	
	# Check if the cell was flagged by the player
	elif (
			event is InputEventMouseButton
			and event.get_button_index() == BUTTON_RIGHT
			and not event.is_pressed()
			and _state == States.UNREVEALED
	):
		emit_signal("flagged")


func get_filled_nb_count() -> int:
	return _filled_nb_count


func get_flag() -> int:
	return _flag


func get_neighbors() -> Array:
	return _neighbors


func get_state() -> int:
	return _state


func get_type() -> int:
	return _type


func set_flag(flag : int) -> void:
	_flag = flag
	if flag == Flags.NONE:
		flag_sprite.set_animation("none")
	
	elif flag == Flags.HOLE:
		flag_sprite.set_animation("hole")
		AudioManager.play("flag", 1.0, false, -0.2)
	
	elif flag == Flags.GOLD:
		flag_sprite.set_animation("gold")
		AudioManager.play("flag", 1.0, false, -0.1)
	
	elif flag == Flags.DIAMOND:
		flag_sprite.set_animation("diamond")
		AudioManager.play("flag", 1.0, false, 0.0)


func set_neighbors(neighbors : Array) -> void:
	_neighbors = neighbors


func set_row_and_column(row : int, col : int) -> void:
	self.row = row
	self.col = col


func set_state(state : int) -> void:
	# Redundancy check
	if _state == state:
		return
	
	_state = state
	if _state == States.UNREVEALED:
		sprite.set_animation("unrevealed")
		return
		
	elif _state == States.REVEALED:
		sprite.set_animation("revealed")
		particles.set_emitting(true)
		AudioManager.play("cell_reveal")
		
		# Remove flag automatically
		set_flag(Flags.NONE)
		emit_signal("flag_changed")
		
		# Check if the cell has treasure
		if not _type == Types.EMPTY and not _type == Types.HOLE:
			AudioManager.play("buzzer")
	
	elif _state == States.MINED:
		sprite.set_animation("revealed")
		flag_sprite.set_animation("none")
		particles.set_emitting(true)
		AudioManager.play("cell_reveal")
	
	_update_content_sprite()
	
	# Update filled neighbor count
	_filled_nb_count = 0
	for neighbor in _neighbors:
		if not neighbor.get_type() == Types.EMPTY:
			_filled_nb_count += 1

	_update_number_label()
	

func set_type(type : int) -> void:
	_type = type
	
	# Set sparkle animation at this point for syncing purposes
	# Sparkle should still be invisible
	if type == Types.DIAMOND:
		sparkle.play("diamond")
	
	elif type == Types.GOLD:
		sparkle.play("gold")


# Updates the sparkle animation, but does not make it visible
func update_sparkle() -> void:
	for neighbor in _neighbors:
		if neighbor.get_type() == Types.DIAMOND:
			sparkle.play("diamond")
			break
		
		elif neighbor.get_type() == Types.GOLD:
			sparkle.play("gold")


func _update_content_sprite() -> void:
	# Set content sprite if filled
	if _type == Types.HOLE:
		content_sprite.set_animation("hole")
		
	elif _type == Types.GOLD:
		content_sprite.set_animation("gold")
		content_bg_sprite.set_animation("gold")
		if _state == States.REVEALED or (_state == States.MINED and not _flag == Flags.GOLD):
			anim.play("drop_content")
				
	elif _type == Types.DIAMOND:
		content_sprite.set_animation("diamond")
		content_bg_sprite.set_animation("diamond")
		if _state == States.REVEALED or (_state == States.MINED and not _flag == Flags.DIAMOND):
			anim.play("drop_content")


func _update_number_label() -> void:
	if not _type == Types.EMPTY:
		return
	
	# Update number label
	if not _filled_nb_count <= 0:
		number_sprite.set_animation("default")
		number_sprite.set_frame(_filled_nb_count - 1)
		
		# Set animation and frame
		for neighbor in _neighbors:
			if neighbor.get_type() == Types.DIAMOND:
				number_sprite.set_animation("diamond")
				number_sprite.set_frame(_filled_nb_count - 1)
				break
			
			elif neighbor.get_type() == Types.GOLD:
				number_sprite.set_animation("gold")
				number_sprite.set_frame(_filled_nb_count - 1)
		
		# Make the sparkle visible
		#sparkle.set_visible(true)
		
	else:
		# No filled neighbors, set invisible
		number_sprite.set_animation("none")
