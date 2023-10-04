extends Node


const BAT_SCENE : PackedScene = preload("res://cave_bat/CaveBat.tscn")

var _spawn_positions : Array = []
var _game_state : GameStateData = preload("res://common/game_state_data.tres")

onready var spawn_timer : Timer = $SpawnTimer


func _ready() -> void:
	EventBus.connect("level_ended", self, "_stop_spawning")
	EventBus.connect("level_started", self, "_start_spawning")
	spawn_timer.connect("timeout", self, "_spawn_bat")
	
	# Populate _spawn_positions array
	_spawn_positions = $SpawnPositions.get_children()


func _spawn_bat() -> void:
	# Choose random spawn position
	var spawn_pos : EnemySpawnPosition = _spawn_positions[
			RNG.get_random_int(_spawn_positions.size())
	]
	
	var bat = BAT_SCENE.instance()
	bat.init(spawn_pos.global_position, spawn_pos.direction)
	get_tree().get_current_scene().add_child(bat)


func _start_spawning() -> void:
	#if _game_state.level >= 3:
	spawn_timer.start()


func _stop_spawning() -> void:
	spawn_timer.stop()
