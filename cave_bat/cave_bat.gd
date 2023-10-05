extends Area2D


var _start_position := Vector2.ZERO 
var _direction := Vector2.RIGHT
var _active := true
var _game_state : GameStateData = preload("res://common/game_state_data.tres")

export var speed : float = 30.0

onready var sprite : AnimatedSprite = $AnimatedSprite


func _ready() -> void:
	EventBus.connect("sequence_started", self, "queue_free")
	EventBus.connect("level_ended", self, "queue_free")
	connect("mouse_entered", self, "_handle_mouse_collision")
	
	# Create timer to free this node
	var timer = get_tree().create_timer(10.0, false)
	timer.connect("timeout", self, "queue_free")
	
	set_global_position(_start_position)
	_direction = _direction.normalized()
	
	# Sprite flip check
	if _direction.x < 0:
		_flip_sprite(true)


func _physics_process(delta : float) -> void:
	global_translate(_direction * speed * delta)


# Initialize values
func init(start_pos : Vector2, direction : Vector2) -> void:
	_start_position = start_pos
	_direction = direction


func _flip_sprite(value : bool) -> void:
	sprite.flip_h = value
	sprite.get_material().set("shader_param/offset", Vector2(2 - (int(value) * 4), 2))


func _handle_mouse_collision() -> void:
	if not _active:
		return
	
	EventBus.emit_signal("bat_collided")
	EffectManager.create_text_popup(
			global_position + Vector2(0, -8), 
			Formatter.format_money_string(_game_state.BAT_PENALTY), 
			Colors.RED
	)
	_active = false
	sprite.play("carrying")


