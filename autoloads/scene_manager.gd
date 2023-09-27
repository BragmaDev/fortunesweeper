extends Node


const MAIN_MENU_SCENE_PATH = "res://interface/menus/MainMenu.tscn"
const MAIN_SCENE_PATH = "res://Main.tscn"
const GAME_OVER_SCENE_PATH = "res://interface/menus/GameOverScreen.tscn"
const WIN_SCENE_PATH = "res://interface/menus/WinScreen.tscn"


func change_scene(scene_path : String) -> void:
	var duration : float = 0.7
	EventBus.emit_signal("transition_out_triggered", duration)

	var timer = get_tree().create_timer(duration)
	timer.connect("timeout", get_tree(), "change_scene", [scene_path])


func set_pause(paused : bool) -> void:
	get_tree().set_pause(paused)


func quit_game() -> void:
	var duration : float = 0.7
	EventBus.emit_signal("transition_out_triggered", duration)

	var timer = get_tree().create_timer(duration)
	timer.connect("timeout", get_tree(), "quit")
